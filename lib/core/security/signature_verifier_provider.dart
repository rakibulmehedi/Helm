import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'signature_verifier.dart';

/// The expected SHA-256 hex digest of the APK signing certificate.
///
/// When the keystore is rotated, update this hash to match the new certificate.
const kExpectedApkSignatureHash =
    '4be9cc5a4d3c3729d3668b37db4a712045db1d0acf8eba66a77fd2e280161e8d';

final signatureVerifierProvider =
    FutureProvider<SignatureVerificationResult>((ref) async {
  final verifier = SignatureVerifier();
  return verifier.verifySignature(expectedHash: kExpectedApkSignatureHash);
});
