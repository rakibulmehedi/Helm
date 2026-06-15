import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'pinned_http_client.dart';

/// Provides a pinned HTTP client for API calls.
///
/// When the backend is deployed, [PinnedHttpClient.withDefaults] will enforce
/// certificate pinning. Until then, this returns a plain [http.Client] so
/// development is not blocked.
final httpClientProvider = Provider<http.Client>((ref) {
  // TODO: Swap to PinnedHttpClient.withDefaults() when the backend is live.
  return http.Client();
});
