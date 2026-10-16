SET local check_function_bodies = off;

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON SEQUENCES FROM "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON SEQUENCES FROM "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON SEQUENCES FROM "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON FUNCTIONS FROM "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON FUNCTIONS FROM "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON FUNCTIONS FROM "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON TABLES FROM "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON TABLES FROM "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" REVOKE ALL ON TABLES FROM "service_role";

CREATE TABLE "public"."alerts" (
  "id"             uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "patient_id"     uuid                     NOT NULL,
  "doctor_id"      uuid                     NOT NULL,
  "measurement_id" uuid,
  "type"           text                     NOT NULL,
  "message"        text                     NOT NULL,
  "status"         text                     NOT NULL DEFAULT 'open'::text,
  "created_at"     timestamp with time zone NOT NULL DEFAULT now(),
  "resolved_at"    timestamp with time zone,
  CONSTRAINT "alerts_pkey" PRIMARY KEY (id),
  CONSTRAINT "alerts_status_check" CHECK ((status = ANY (ARRAY['open'::text, 'resolved'::text])))
);

ALTER TABLE "public"."alerts"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."doctor_details" (
  "id"                  uuid                     NOT NULL,
  "phone"               text,
  "avatar_url"          text,
  "str_number"          text,
  "specialization"      text,
  "organization_name"   text,
  "organization_type"   text,
  "verification_status" text                     NOT NULL DEFAULT 'pending'::text,
  "verified_at"         timestamp with time zone,
  "updated_at"          timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "doctor_details_pkey" PRIMARY KEY (id),
  CONSTRAINT "doctor_details_verification_status_check" CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'needs_revision'::text])))
);

ALTER TABLE "public"."doctor_details"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."measurements" (
  "id"             uuid                     NOT NULL,
  "patient_id"     uuid,
  "measured_at"    timestamp with time zone NOT NULL,
  "uploaded_at"    timestamp with time zone NOT NULL DEFAULT now(),
  "condition"      text                     NOT NULL,
  "duration_s"     numeric                  NOT NULL,
  "status"         text                     NOT NULL,
  "invalid_reason" text,
  "features"       jsonb,
  "algo_version"   text                     NOT NULL,
  "device"         jsonb                    NOT NULL,
  CONSTRAINT "features_required_unless_invalid" CHECK (((status = 'invalid'::text) OR (features IS NOT NULL))),
  CONSTRAINT "invalid_reason_iff_invalid" CHECK (((status = 'invalid'::text) = (invalid_reason IS NOT NULL))),
  CONSTRAINT "measurements_condition_check" CHECK ((condition = ANY (ARRAY['rest'::text, 'postural'::text]))),
  CONSTRAINT "measurements_duration_s_check" CHECK ((duration_s > (0)::numeric)),
  CONSTRAINT "measurements_pkey" PRIMARY KEY (id),
  CONSTRAINT "measurements_status_check" CHECK ((status = ANY (ARRAY['none'::text, 'tremor'::text, 'invalid'::text])))
);

ALTER TABLE "public"."measurements"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."medication_logs" (
  "id"                    uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "patient_medication_id" uuid                     NOT NULL,
  "scheduled_at"          timestamp with time zone NOT NULL,
  "schedule_id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "status"                text                     NOT NULL DEFAULT 'taken'::text,
  "taken_at"              timestamp with time zone,
  "logged_at"             timestamp with time zone NOT NULL,
  "uploaded_at"           timestamp with time zone NOT NULL,
  CONSTRAINT "medication_logs_pkey" PRIMARY KEY (id),
  CONSTRAINT "medication_logs_schedule_id_key" UNIQUE (schedule_id),
  "patient_id"            uuid                     NOT NULL DEFAULT auth.uid()
);

ALTER TABLE "public"."medication_logs"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."medication_schedules" (
  "patient_id"   uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "doctor_id"    uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "medicine_id"  uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "dose"         text                     NOT NULL,
  "times"        text                     NOT NULL,
  "start_date"   date                     NOT NULL,
  "end_date"     date,
  "instructions" text,
  "is_active"    boolean                  NOT NULL,
  "created_at"   timestamp with time zone NOT NULL,
  "updated_at"   timestamp with time zone NOT NULL,
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT "medication_schedules_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."medication_schedules"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."medicines" (
  "id"            uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "name"          text                     NOT NULL,
  "common_dosage" text                     NOT NULL,
  "notes"         text,
  "created_at"    timestamp with time zone NOT NULL DEFAULT now(),
  "updated_at"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "medicines_name_key" UNIQUE (name),
  CONSTRAINT "medicines_pkey" PRIMARY KEY (id),
  "created_by"    uuid                     DEFAULT auth.uid()
);

ALTER TABLE "public"."medicines"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."notifications" (
  "id"           uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "recipient_id" uuid                     NOT NULL,
  "patient_id"   uuid,
  "alert_id"     uuid,
  "title"        text                     NOT NULL,
  "body"         text                     NOT NULL,
  "is_read"      boolean                  NOT NULL DEFAULT false,
  "created_at"   timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "notifications_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."notifications"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."patient_details" (
  "id"            uuid                     NOT NULL,
  "date_of_birth" date,
  "gender"        text,
  "phone"         text,
  "email"         text,
  "diagnosis"     text,
  "updated_at"    timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "patient_details_gender_check" CHECK ((gender = ANY (ARRAY['male'::text, 'female'::text]))),
  CONSTRAINT "patient_details_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."patient_details"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."patient_medications" (
  "id"             uuid                     NOT NULL DEFAULT gen_random_uuid(),
  "patient_id"     uuid                     NOT NULL,
  "medicine_id"    uuid                     NOT NULL,
  "dose"           text                     NOT NULL,
  "schedule_times" time without time zone[] NOT NULL DEFAULT '{}'::time WITHOUT time zone[],
  "start_date"     date                     NOT NULL DEFAULT CURRENT_DATE,
  "end_date"       date,
  "notes"          text,
  "is_active"      boolean                  NOT NULL DEFAULT true,
  "created_at"     timestamp with time zone NOT NULL DEFAULT now(),
  "updated_at"     timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "patient_medications_pkey" PRIMARY KEY (id),
  "prescribed_by"  uuid                     NOT NULL DEFAULT auth.uid()
);

ALTER TABLE "public"."patient_medications"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."profiles" (
  "id"              uuid                     NOT NULL,
  "role"            text                     NOT NULL,
  "full_name"       text                     NOT NULL,
  "connection_code" text,
  "doctor_id"       uuid,
  "connected_at"    timestamp with time zone,
  "created_at"      timestamp with time zone NOT NULL DEFAULT now(),
  "email"           character varying        NOT NULL,
  CONSTRAINT "connection_code_only_for_doctor" CHECK (((role = 'doctor'::text) = (connection_code IS NOT NULL))),
  CONSTRAINT "doctor_id_only_for_patient" CHECK (((role = 'patient'::text) OR (doctor_id IS NULL))),
  CONSTRAINT "profiles_connection_code_key" UNIQUE (connection_code),
  CONSTRAINT "profiles_pkey" PRIMARY KEY (id),
  CONSTRAINT "profiles_role_check" CHECK ((role = ANY (ARRAY['patient'::text, 'doctor'::text])))
);

ALTER TABLE "public"."profiles"
  ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."measurements"
  ADD COLUMN "peak_frequency_hz" numeric GENERATED ALWAYS AS (((features ->> 'peak_frequency_hz'::text))::numeric) STORED;

ALTER TABLE "public"."measurements"
  ADD COLUMN "band_power_ratio" numeric GENERATED ALWAYS AS (((features ->> 'band_power_ratio'::text))::numeric) STORED;

ALTER TABLE "public"."measurements"
  ADD COLUMN "snr" numeric GENERATED ALWAYS AS (((features ->> 'snr'::text))::numeric) STORED;

ALTER TABLE "public"."measurements"
  ADD COLUMN "band_rms_g" numeric GENERATED ALWAYS AS (((features ->> 'band_rms_g'::text))::numeric) STORED;

ALTER TABLE "public"."measurements"
  ADD COLUMN "consistency" numeric GENERATED ALWAYS AS (((features ->> 'consistency'::text))::numeric) STORED;

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

REVOKE ALL ON FUNCTION "public"."alert_to_notification"() FROM "anon", "authenticated", "service_role";

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

REVOKE ALL ON FUNCTION "public"."claim_measurements"(uuid[]) FROM PUBLIC, "anon", "service_role";

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

REVOKE ALL ON FUNCTION "public"."connect_to_doctor"(text) FROM PUBLIC, "anon", "service_role";

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

REVOKE ALL ON FUNCTION "public"."generate_connection_code"() FROM "anon", "authenticated", "service_role";

CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
declare
  v_role text := coalesce(new.raw_app_meta_data ->> 'role', 'patient');
begin
  if v_role not in ('patient', 'doctor') then
    v_role := 'patient';
  end if;

  insert into public.profiles (id, role, full_name, connection_code)
  values (
    new.id,
    v_role,
    coalesce(nullif(new.raw_user_meta_data ->> 'full_name', ''), split_part(new.email, '@', 1), 'Pengguna'),
    case when v_role = 'doctor' then public.generate_connection_code() end
  );

  if v_role = 'doctor' then
    insert into public.doctor_details (id) values (new.id);
  else
    insert into public.patient_details (id, email) values (new.id, new.email);
  end if;

  return new;
end $function$;

REVOKE ALL ON FUNCTION "public"."handle_new_user"() FROM "anon", "authenticated", "service_role";

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

REVOKE ALL ON FUNCTION "public"."is_my_patient"(uuid) FROM "anon", "authenticated", "service_role";

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

REVOKE ALL ON FUNCTION "public"."make_doctor"(uuid) FROM PUBLIC, "anon", "authenticated", "service_role";

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

REVOKE ALL ON FUNCTION "public"."measurement_to_alert"() FROM "anon", "authenticated", "service_role";

CREATE OR REPLACE FUNCTION public.measurements_set_uploaded_at()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
begin
  new.uploaded_at := now();
  return new;
end $function$;

REVOKE ALL ON FUNCTION "public"."measurements_set_uploaded_at"() FROM "anon", "authenticated", "service_role";

CREATE OR REPLACE FUNCTION public.my_doctor_id()
  RETURNS uuid
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
  select doctor_id from public.profiles where id = auth.uid()
$function$;

REVOKE ALL ON FUNCTION "public"."my_doctor_id"() FROM "anon", "authenticated", "service_role";

CREATE OR REPLACE FUNCTION public.my_role()
  RETURNS text
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path TO ''
  AS $function$
  select role from public.profiles where id = auth.uid()
$function$;

REVOKE ALL ON FUNCTION "public"."my_role"() FROM "anon", "authenticated", "service_role";

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

REVOKE ALL ON FUNCTION "public"."regenerate_connection_code"() FROM PUBLIC, "anon", "service_role";

CREATE OR REPLACE FUNCTION public.set_updated_at()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
begin
  new.updated_at := now();
  return new;
end $function$;

REVOKE ALL ON FUNCTION "public"."set_updated_at"() FROM "anon", "authenticated", "service_role";

ALTER TABLE "public"."alerts"
  ADD CONSTRAINT "alerts_measurement_id_fkey" FOREIGN KEY (measurement_id) REFERENCES public.measurements(id) ON DELETE SET NULL;

ALTER TABLE "public"."medication_schedules"
  ADD CONSTRAINT "medication_schedules_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public.doctor_details(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "public"."medicines"
  ADD CONSTRAINT "medicines_id_fkey" FOREIGN KEY (id) REFERENCES public.doctor_details(id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE "public"."medication_schedules"
  ADD CONSTRAINT "medication_schedules_medicine_id_fkey" FOREIGN KEY (medicine_id) REFERENCES public.medicines(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "public"."notifications"
  ADD CONSTRAINT "notifications_alert_id_fkey" FOREIGN KEY (alert_id) REFERENCES public.alerts(id) ON DELETE CASCADE;

ALTER TABLE "public"."medication_schedules"
  ADD CONSTRAINT "medication_schedules_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.patient_details(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "public"."patient_medications"
  ADD CONSTRAINT "patient_medications_medicine_id_fkey" FOREIGN KEY (medicine_id) REFERENCES public.medicines(id);

ALTER TABLE "public"."medication_logs"
  ADD CONSTRAINT "medication_logs_patient_medication_id_fkey" FOREIGN KEY (patient_medication_id) REFERENCES public.patient_medications(id) ON DELETE CASCADE;

ALTER TABLE "public"."profiles"
  ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."alerts"
  ADD CONSTRAINT "alerts_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."alerts"
  ADD CONSTRAINT "alerts_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."doctor_details"
  ADD CONSTRAINT "doctor_details_id_fkey" FOREIGN KEY (id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."measurements"
  ADD CONSTRAINT "measurements_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."notifications"
  ADD CONSTRAINT "notifications_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."notifications"
  ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY (recipient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."patient_details"
  ADD CONSTRAINT "patient_details_id_fkey" FOREIGN KEY (id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."patient_medications"
  ADD CONSTRAINT "patient_medications_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE "public"."profiles"
  ADD CONSTRAINT "profiles_doctor_id_fkey" FOREIGN KEY (doctor_id) REFERENCES public.profiles(id) ON DELETE SET NULL;

CREATE VIEW "public"."patient_overview" WITH (security_invoker=true) AS  SELECT p.id AS patient_id,
    p.full_name,
    p.doctor_id,
    p.connected_at,
    d.date_of_birth,
    d.gender,
    d.phone,
    d.email,
    d.diagnosis,
    m.measured_at AS last_measured_at,
    m.status AS last_measurement_status,
    m.peak_frequency_hz AS last_peak_frequency_hz,
    COALESCE(a.open_alerts, (0)::bigint) AS open_alerts,
        CASE
            WHEN (COALESCE(a.open_alerts, (0)::bigint) > 0) THEN 'attention'::text
            WHEN (m.measured_at > (now() - '7 days'::interval)) THEN 'active'::text
            ELSE 'inactive'::text
        END AS monitoring_status
   FROM (((public.profiles p
     LEFT JOIN public.patient_details d ON ((d.id = p.id)))
     LEFT JOIN LATERAL ( SELECT measurements.measured_at,
            measurements.status,
            measurements.peak_frequency_hz
           FROM public.measurements
          WHERE (measurements.patient_id = p.id)
          ORDER BY measurements.measured_at DESC
         LIMIT 1) m ON (true))
     LEFT JOIN LATERAL ( SELECT count(*) AS open_alerts
           FROM public.alerts
          WHERE ((alerts.patient_id = p.id) AND (alerts.status = 'open'::text))) a ON (true))
  WHERE (p.role = 'patient'::text);

CREATE INDEX alerts_doctor_status_idx ON public.alerts USING btree (doctor_id, status, created_at DESC);

CREATE INDEX alerts_patient_idx ON public.alerts USING btree (patient_id, created_at DESC);

CREATE INDEX measurements_patient_time_idx ON public.measurements USING btree (patient_id, measured_at DESC);

CREATE INDEX medicines_name_idx ON public.medicines USING gin (to_tsvector('simple'::regconfig, name));

CREATE INDEX notifications_recipient_idx ON public.notifications USING btree (recipient_id, is_read, created_at DESC);

CREATE INDEX patient_medications_patient_idx ON public.patient_medications USING btree (patient_id, is_active);

CREATE INDEX profiles_doctor_id_idx ON public.profiles USING btree (doctor_id);

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

CREATE TRIGGER alerts_notify
  AFTER INSERT ON public.alerts
  FOR EACH ROW
  EXECUTE FUNCTION public.alert_to_notification();

CREATE TRIGGER doctor_details_updated_at
  BEFORE UPDATE ON public.doctor_details
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER measurements_alert
  AFTER INSERT OR UPDATE OF patient_id ON public.measurements
  FOR EACH ROW
  EXECUTE FUNCTION public.measurement_to_alert();

CREATE TRIGGER measurements_uploaded_at
  BEFORE INSERT ON public.measurements
  FOR EACH ROW
  EXECUTE FUNCTION public.measurements_set_uploaded_at();

CREATE TRIGGER patient_details_updated_at
  BEFORE UPDATE ON public.patient_details
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER patient_medications_updated_at
  BEFORE UPDATE ON public.patient_medications
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE POLICY "alerts: doctor reads own" ON "public"."alerts"
  FOR SELECT
  TO "authenticated"
  USING ((doctor_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "alerts: doctor resolves own" ON "public"."alerts"
  FOR UPDATE
  TO "authenticated"
  USING ((doctor_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((doctor_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "doctor_details: read self or my doctor" ON "public"."doctor_details"
  FOR SELECT
  TO "authenticated"
  USING (((id = ( SELECT auth.uid() AS uid)) OR (id = ( SELECT public.my_doctor_id() AS my_doctor_id))));

CREATE POLICY "doctor_details: update self" ON "public"."doctor_details"
  FOR UPDATE
  TO "authenticated"
  USING ((id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "measurements: insert own or anonymous" ON "public"."measurements"
  FOR INSERT
  TO "anon", "authenticated"
  WITH CHECK (((patient_id IS NULL) OR (patient_id = ( SELECT auth.uid() AS uid))));

CREATE POLICY "measurements: read own or my patient" ON "public"."measurements"
  FOR SELECT
  TO "authenticated"
  USING (((patient_id = ( SELECT auth.uid() AS uid)) OR public.is_my_patient(patient_id)));

CREATE POLICY "medicines: any signed-in user can read" ON "public"."medicines"
  FOR SELECT
  TO "authenticated"
  USING (true);

CREATE POLICY "notifications: mark own read" ON "public"."notifications"
  FOR UPDATE
  TO "authenticated"
  USING ((recipient_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((recipient_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "notifications: read own" ON "public"."notifications"
  FOR SELECT
  TO "authenticated"
  USING ((recipient_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "patient_details: read self or my patient" ON "public"."patient_details"
  FOR SELECT
  TO "authenticated"
  USING (((id = ( SELECT auth.uid() AS uid)) OR public.is_my_patient(id)));

CREATE POLICY "patient_details: update self or my patient" ON "public"."patient_details"
  FOR UPDATE
  TO "authenticated"
  USING (((id = ( SELECT auth.uid() AS uid)) OR public.is_my_patient(id)))
  WITH CHECK (((id = ( SELECT auth.uid() AS uid)) OR public.is_my_patient(id)));

CREATE POLICY "patient_medications: patient reads own" ON "public"."patient_medications"
  FOR SELECT
  TO "authenticated"
  USING ((patient_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "profiles: read self, own patients, own doctor" ON "public"."profiles"
  FOR SELECT
  TO "authenticated"
  USING (((id = ( SELECT auth.uid() AS uid)) OR (doctor_id = ( SELECT auth.uid() AS uid)) OR (id = ( SELECT public.my_doctor_id() AS my_doctor_id))));

CREATE POLICY "profiles: update self" ON "public"."profiles"
  FOR UPDATE
  TO "authenticated"
  USING ((id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((id = ( SELECT auth.uid() AS uid)));

ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."alerts";

ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."notifications";

GRANT EXECUTE ON FUNCTION "public"."alert_to_notification"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."alert_to_notification"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."alert_to_notification"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."claim_measurements"(uuid[]) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."claim_measurements"(uuid[]) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."claim_measurements"(uuid[]) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."connect_to_doctor"(text) TO "authenticated";

REVOKE ALL ON FUNCTION "public"."connect_to_doctor"(text) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."connect_to_doctor"(text) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."generate_connection_code"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."generate_connection_code"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."generate_connection_code"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."handle_new_user"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."handle_new_user"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."handle_new_user"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."is_my_patient"(uuid) TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."is_my_patient"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."is_my_patient"(uuid) TO "postgres";

REVOKE ALL ON FUNCTION "public"."make_doctor"(uuid) FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."make_doctor"(uuid) TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."measurement_to_alert"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."measurement_to_alert"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."measurement_to_alert"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."measurements_set_uploaded_at"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."measurements_set_uploaded_at"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."measurements_set_uploaded_at"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."my_doctor_id"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."my_doctor_id"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."my_doctor_id"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."my_role"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."my_role"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."my_role"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."regenerate_connection_code"() TO "authenticated";

REVOKE ALL ON FUNCTION "public"."regenerate_connection_code"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."regenerate_connection_code"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."set_updated_at"() TO PUBLIC;

REVOKE ALL ON FUNCTION "public"."set_updated_at"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."set_updated_at"() TO "postgres";

REVOKE ALL ON TABLE "public"."alerts" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."alerts" TO "anon";

REVOKE ALL ON TABLE "public"."alerts" FROM "authenticated";

REVOKE ALL ("resolved_at") ON TABLE "public"."alerts" FROM "authenticated";

GRANT UPDATE ("resolved_at") ON TABLE "public"."alerts" TO "authenticated";

REVOKE ALL ("status") ON TABLE "public"."alerts" FROM "authenticated";

GRANT UPDATE ("status") ON TABLE "public"."alerts" TO "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."alerts" TO "authenticated";

REVOKE ALL ON TABLE "public"."alerts" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."alerts" TO "postgres";

REVOKE ALL ON TABLE "public"."alerts" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."alerts" TO "service_role";

REVOKE ALL ON TABLE "public"."doctor_details" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."doctor_details" TO "anon";

REVOKE ALL ON TABLE "public"."doctor_details" FROM "authenticated";

REVOKE ALL ("avatar_url") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("avatar_url") ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ("organization_name") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("organization_name") ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ("organization_type") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("organization_type") ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ("phone") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("phone") ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ("specialization") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("specialization") ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ("str_number") ON TABLE "public"."doctor_details" FROM "authenticated";

GRANT UPDATE ("str_number") ON TABLE "public"."doctor_details" TO "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."doctor_details" TO "authenticated";

REVOKE ALL ON TABLE "public"."doctor_details" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."doctor_details" TO "postgres";

REVOKE ALL ON TABLE "public"."doctor_details" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."doctor_details" TO "service_role";

REVOKE ALL ON TABLE "public"."measurements" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."measurements" TO "anon";

REVOKE ALL ON TABLE "public"."measurements" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."measurements" TO "authenticated";

REVOKE ALL ON TABLE "public"."measurements" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."measurements" TO "postgres";

REVOKE ALL ON TABLE "public"."measurements" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."measurements" TO "service_role";

REVOKE ALL ON TABLE "public"."medication_logs" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_logs" TO "anon";

REVOKE ALL ON TABLE "public"."medication_logs" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_logs" TO "authenticated";

REVOKE ALL ON TABLE "public"."medication_logs" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."medication_logs" TO "postgres";

REVOKE ALL ON TABLE "public"."medication_logs" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_logs" TO "service_role";

REVOKE ALL ON TABLE "public"."medication_schedules" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_schedules" TO "anon";

REVOKE ALL ON TABLE "public"."medication_schedules" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_schedules" TO "authenticated";

REVOKE ALL ON TABLE "public"."medication_schedules" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."medication_schedules" TO "postgres";

REVOKE ALL ON TABLE "public"."medication_schedules" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medication_schedules" TO "service_role";

REVOKE ALL ON TABLE "public"."medicines" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medicines" TO "anon";

REVOKE ALL ON TABLE "public"."medicines" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medicines" TO "authenticated";

REVOKE ALL ON TABLE "public"."medicines" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."medicines" TO "postgres";

REVOKE ALL ON TABLE "public"."medicines" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."medicines" TO "service_role";

REVOKE ALL ON TABLE "public"."notifications" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."notifications" TO "anon";

REVOKE ALL ON TABLE "public"."notifications" FROM "authenticated";

REVOKE ALL ("is_read") ON TABLE "public"."notifications" FROM "authenticated";

GRANT UPDATE ("is_read") ON TABLE "public"."notifications" TO "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."notifications" TO "authenticated";

REVOKE ALL ON TABLE "public"."notifications" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."notifications" TO "postgres";

REVOKE ALL ON TABLE "public"."notifications" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."notifications" TO "service_role";

REVOKE ALL ON TABLE "public"."patient_details" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_details" TO "anon";

REVOKE ALL ON TABLE "public"."patient_details" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_details" TO "authenticated";

REVOKE ALL ON TABLE "public"."patient_details" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."patient_details" TO "postgres";

REVOKE ALL ON TABLE "public"."patient_details" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_details" TO "service_role";

REVOKE ALL ON TABLE "public"."patient_medications" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_medications" TO "anon";

REVOKE ALL ON TABLE "public"."patient_medications" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_medications" TO "authenticated";

REVOKE ALL ON TABLE "public"."patient_medications" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."patient_medications" TO "postgres";

REVOKE ALL ON TABLE "public"."patient_medications" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_medications" TO "service_role";

REVOKE ALL ON TABLE "public"."profiles" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."profiles" TO "anon";

REVOKE ALL ON TABLE "public"."profiles" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."profiles" TO "authenticated";

REVOKE ALL ON TABLE "public"."profiles" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."profiles" TO "postgres";

REVOKE ALL ON TABLE "public"."profiles" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."profiles" TO "service_role";

REVOKE ALL ON TABLE "public"."patient_overview" FROM "anon";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_overview" TO "anon";

REVOKE ALL ON TABLE "public"."patient_overview" FROM "authenticated";

GRANT MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE ON TABLE "public"."patient_overview" TO "authenticated";

REVOKE ALL ON TABLE "public"."patient_overview" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."patient_overview" TO "postgres";

REVOKE ALL ON TABLE "public"."patient_overview" FROM "service_role";

GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."patient_overview" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLES TO "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLES TO "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT MAINTAIN, REFERENCES, TRIGGER, TRUNCATE ON TABLES TO "service_role";

ALTER TABLE "public"."medication_logs"
  ADD CONSTRAINT "medication_logs_patient_id_fkey" FOREIGN KEY (patient_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

CREATE INDEX medication_logs_patient_idx ON public.medication_logs USING btree (patient_id, scheduled_at DESC);

CREATE POLICY "medication_logs: doctor reads own patients" ON "public"."medication_logs"
  FOR SELECT
  TO "authenticated"
  USING (public.is_my_patient(patient_id));

CREATE POLICY "medication_logs: patient edits own" ON "public"."medication_logs"
  FOR UPDATE
  TO "authenticated"
  USING ((patient_id = ( SELECT auth.uid() AS uid)))
  WITH CHECK ((patient_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "medication_logs: patient reads own" ON "public"."medication_logs"
  FOR SELECT
  TO "authenticated"
  USING ((patient_id = ( SELECT auth.uid() AS uid)));

CREATE POLICY "medication_logs: patient writes own" ON "public"."medication_logs"
  FOR INSERT
  TO "authenticated"
  WITH CHECK ((patient_id = ( SELECT auth.uid() AS uid)));

ALTER TABLE "public"."patient_medications"
  ADD CONSTRAINT "patient_medications_prescribed_by_fkey" FOREIGN KEY (prescribed_by) REFERENCES public.profiles(id);

CREATE POLICY "patient_medications: doctor full access for own patients" ON "public"."patient_medications"
  FOR ALL
  TO "authenticated"
  USING (public.is_my_patient(patient_id))
  WITH CHECK ((public.is_my_patient(patient_id) AND (prescribed_by = ( SELECT auth.uid() AS uid))));

