SET local check_function_bodies = off;

ALTER TABLE "public"."patient_medications"
  DROP CONSTRAINT "patient_medications_medicine_id_fkey";

ALTER TABLE "public"."patient_medications"
  DROP CONSTRAINT "patient_medications_patient_id_fkey";

ALTER TABLE "public"."patient_medications"
  DROP CONSTRAINT "patient_medications_prescribed_by_fkey";

DROP TABLE "public"."patient_medications";

CREATE OR REPLACE FUNCTION public.alert_to_notification()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
begin
  insert into public.notifications (recipient_id, patient_id, alert_id, title, body)
  select new.doctor_id, new.patient_id, new.id,
         'Pasien Memerlukan Perhatian',
         p.full_name || ': ' || new.message
    from public.profiles p where p.id = new.patient_id;
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.claim_measurements (
  p_ids uuid[]
)
  RETURNS integer
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare n integer;
begin
  if public.my_role() is distinct from 'patient' then
    raise exception 'Hanya pasien yang dapat mengklaim pengukuran.';
  end if;
  update public.measurements
     set patient_id = auth.uid()
   where id = any(p_ids) and patient_id is null;
  get diagnostics n = row_count;
  return n;
end $function$;

CREATE OR REPLACE FUNCTION public.connect_to_doctor (
  p_code text
)
  RETURNS uuid
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare v_doctor uuid;
begin
  if public.my_role() is distinct from 'patient' then
    raise exception 'Hanya pasien yang dapat memasukkan kode koneksi.';
  end if;

  select id into v_doctor
    from public.profiles
   where role = 'doctor' and connection_code = upper(trim(p_code));

  if v_doctor is null then
    raise exception 'Kode koneksi tidak valid.' using errcode = 'P0002';
  end if;

  update public.profiles
     set doctor_id = v_doctor, connected_at = now()
   where id = auth.uid();

  return v_doctor;
end $function$;

CREATE OR REPLACE FUNCTION public.generate_connection_code()
  RETURNS text
  LANGUAGE plpgsql
  SET search_path TO ''
  AS $function$
declare
  chars constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  code text;
begin
  loop
    code := '';
    for i in 1..8 loop
      code := code || substr(chars, floor(random() * length(chars))::int + 1, 1);
    end loop;
    exit when not exists (select 1 from public.profiles where connection_code = code);
  end loop;
  return code;
end $function$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare
  v_connection_code text;
  v_phone text;
begin
  v_phone := coalesce(new.phone, new.raw_user_meta_data ->> 'phone');

  insert into public.profiles (id, email, full_name, phone, role)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    v_phone,
    'patient'
  );

  -- If signup came from web, upgrade to doctor
  if new.raw_user_meta_data ->> 'signup_source' = 'web' then
    -- make_doctor updates the role and returns the unique connection code
    v_connection_code := public.make_doctor(new.id);

    update public.profiles
    set connection_code = v_connection_code
    where id = new.id;
  else
    insert into public.patient_details (id, phone, email, updated_at)
    values (new.id, v_phone, new.email, now());
  end if;

  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION public.is_my_patient (
  p_patient uuid
)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
  select exists (
    select 1 from public.profiles
    where id = p_patient and doctor_id = auth.uid()
  )
$function$;

CREATE OR REPLACE FUNCTION public.make_doctor (
  p_user_id uuid
)
  RETURNS text
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare v_code text := public.generate_connection_code();
begin
  update public.profiles
     set role = 'doctor', connection_code = v_code, doctor_id = null, connected_at = null
   where id = p_user_id;
  delete from public.patient_details where id = p_user_id;
  insert into public.doctor_details (id) values (p_user_id) on conflict do nothing;
  return v_code;
end $function$;

CREATE OR REPLACE FUNCTION public.measurement_to_alert()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare v_doctor uuid;
begin
  if new.status <> 'tremor' or new.patient_id is null then
    return new;
  end if;
  select doctor_id into v_doctor from public.profiles where id = new.patient_id;
  if v_doctor is null then
    return new;
  end if;
  insert into public.alerts (patient_id, doctor_id, measurement_id, type, message)
  values (new.patient_id, v_doctor, new.id, 'tremor_detected',
          'Tremor terdeteksi (' || coalesce(round(new.peak_frequency_hz, 1)::text, '?') || ' Hz).');
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.measurements_set_uploaded_at()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
begin
  new.uploaded_at := now();
  return new;
end $function$;

CREATE OR REPLACE FUNCTION public.my_doctor_id()
  RETURNS uuid
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
  select doctor_id from public.profiles where id = auth.uid()
$function$;

CREATE OR REPLACE FUNCTION public.my_role()
  RETURNS text
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
  select role from public.profiles where id = auth.uid()
$function$;

CREATE OR REPLACE FUNCTION public.regenerate_connection_code()
  RETURNS text
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare v_code text;
begin
  if public.my_role() is distinct from 'doctor' then
    raise exception 'Hanya dokter yang memiliki kode koneksi.';
  end if;
  v_code := public.generate_connection_code();
  update public.profiles set connection_code = v_code where id = auth.uid();
  return v_code;
end $function$;

CREATE OR REPLACE FUNCTION public.set_updated_at()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
begin
  new.updated_at := now();
  return new;
end $function$;

