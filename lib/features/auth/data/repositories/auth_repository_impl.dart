import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuropulse/features/auth/data/datasources/profile_remote_datasource.dart';
import 'package:nuropulse/features/auth/data/models/profile_model.dart';
import 'package:nuropulse/features/auth/domain/entity/profile.dart';
import 'package:nuropulse/features/auth/domain/entity/user_role.dart';
import 'package:nuropulse/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._auth, this._profiles);

  final AuthRemoteDatasource _auth;
  final ProfileRemoteDatasource _profiles;

  @override
  Stream<Profile?> get profileChanges {
    return _auth.authStateChanges().asyncMap((session) async {
      if (session == null) return null;
      try {
        return await _fetchProfile(session.user.id);
      } catch (error, stackTrace) {
        if (error is Failure) rethrow;
        Error.throwWithStackTrace(
          AuthFailure('Failed to load profile: $error'),
          stackTrace,
        );
      }
    });
  }

  @override
  Future<Profile?> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      final userId = response.session?.user.id;
      // No session means the project requires email confirmation. The
      // account exists but can't sign in yet.
      if (userId == null) return null;
      return await _enforcePatientRole(userId);
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        AuthFailure('Failed to register: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<Profile> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.session?.user.id;
      if (userId == null) {
        throw const AuthFailure('Signed in but no session was returned');
      }
      return await _enforcePatientRole(userId);
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        AuthFailure('Failed to log in: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthFailure('Failed to log out: $error'),
        stackTrace,
      );
    }
  }

  @override
  Future<Profile> refreshProfile() async {
    final userId = _auth.currentUserId;
    if (userId == null) {
      throw const AuthFailure('Not signed in');
    }
    try {
      return await _fetchProfile(userId);
    } catch (error, stackTrace) {
      if (error is Failure) rethrow;
      Error.throwWithStackTrace(
        AuthFailure('Failed to refresh profile: $error'),
        stackTrace,
      );
    }
  }

  /// The app never sets role, but still must refuse a non-patient account
  /// rather than let it stay signed in.
  Future<Profile> _enforcePatientRole(String userId) async {
    final profile = await _fetchProfile(userId);
    if (profile.role != UserRole.patient) {
      await _auth.signOut();
      throw const AuthFailure(
        'Only patient accounts can sign in on mobile',
        reason: AuthFailureReason.wrongRole,
      );
    }
    return profile;
  }

  Future<Profile> _fetchProfile(String userId) async {
    final json = await _profiles.fetch(userId);
    return ProfileModel.fromJson(json).toEntity();
  }
}
