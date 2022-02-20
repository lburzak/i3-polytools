import 'package:googleapis_auth/googleapis_auth.dart';

abstract class CredentialsStorage {
  Future<AccessCredentials?> get();
  Future<void> put(AccessCredentials accessCredentials);
}