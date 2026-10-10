part of 'failure.dart';

/// Local storage (Hive) could not save or read a measurement.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
