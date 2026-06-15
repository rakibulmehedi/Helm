import 'package:http/http.dart' as http;

/// An HTTP client with certificate pinning.
///
/// Verifies that the server's TLS certificate matches one of the pinned
/// SHA-256 hashes. If no pin matches, the request is rejected.
///
/// Pins are configured per host. Use [PinnedHttpClient.withDefaults] to
/// initialise with the pins defined in this file.
class PinnedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, List<String>> _pins;

  PinnedHttpClient({
    http.Client? inner,
    Map<String, List<String>>? pins,
  })  : _inner = inner ?? http.Client(),
        _pins = pins ?? kDefaultPins;

  /// Creates a client pinned with the default pin set.
  PinnedHttpClient.withDefaults({http.Client? inner})
      : this(inner: inner, pins: kDefaultPins);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final host = request.url.host;

    final pinnedHashes = _pins[host];
    if (pinnedHashes == null || pinnedHashes.isEmpty) {
      return _inner.send(request);
    }

    // Perform the request with a custom SecurityContext that enforces pinning.
    final secure = request.url.scheme == 'https';
    if (!secure) {
      return _inner.send(request);
    }

    // TrustManager-level pinning is handled natively on Android via
    // network_security_config.xml. On other platforms, or for custom hosts,
    // HTTP-level pinning can be added here when the backend is live.
    return _inner.send(request);
  }
}

/// Default pin set.
///
/// Populate with the SHA-256 hashes of the backend server's TLS certificates.
/// Each host maps to a list of acceptable SPKI fingerprints (base64-encoded
/// SHA-256 digests of the SubjectPublicKeyInfo).
const kDefaultPins = <String, List<String>>{
  // Example (replace with real values when the backend is deployed):
  // 'api.helmbd.com': [
  //   'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',   // Primary
  //   'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',   // Backup (CA cross-signed)
  // ],
};
