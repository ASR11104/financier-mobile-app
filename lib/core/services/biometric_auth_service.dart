import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

/// Thin wrapper around [LocalAuthentication] for biometric / device-PIN auth.
@lazySingleton
class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Returns true if the device supports biometric or device-credential auth.
  Future<bool> canAuthenticate() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Triggers the system auth prompt.
  ///
  /// Returns true on success, false if the user cancels or fails.
  Future<bool> authenticate([String reason = 'Authenticate to access Finsight']) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
