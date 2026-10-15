import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/connection/data/datasources/connection_remote_datasource.dart';
import 'package:nuropulse/features/connection/domain/entity/connected_doctor.dart';
import 'package:nuropulse/features/connection/domain/repositories/connection_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  ConnectionRepositoryImpl(this._datasource);

  final ConnectionRemoteDatasource _datasource;

  @override
  Future<ConnectedDoctor> connect(String code) async {
    try {
      final doctorId = await _datasource.connectToDoctor(code);
      return await getConnectedDoctor(doctorId);
    } on PostgrestException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ConnectionCodeFailure(
          'Failed to connect: ${error.message}',
          reason: error.code == 'P0002'
              ? ConnectionCodeFailureReason.invalidCode
              : ConnectionCodeFailureReason.other,
        ),
        stackTrace,
      );
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        ConnectionCodeFailure('Failed to connect: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<ConnectedDoctor> getConnectedDoctor(String doctorId) async {
    try {
      final json = await _datasource.fetchProfile(doctorId);
      return ConnectedDoctor(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
      );
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        ConnectionCodeFailure('Failed to load doctor profile: $error'),
        stackTrace,
      );
    }
  }
}
