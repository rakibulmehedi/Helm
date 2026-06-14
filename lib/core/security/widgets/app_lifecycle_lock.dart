// lib/core/security/widgets/app_lifecycle_lock.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/features/auth/presentation/providers/auth_provider.dart';

/// Observes app lifecycle and locks the authenticated session whenever the
/// app leaves the foreground. This prevents the "pick up unlocked phone"
/// attack vector (C-5): backgrounding the app invalidates the session, and
/// the fail-closed router redirect forces PIN re-entry on resume.
class AppLifecycleLock extends ConsumerStatefulWidget {
  const AppLifecycleLock({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLifecycleLock> createState() => _AppLifecycleLockState();
}

class _AppLifecycleLockState extends ConsumerState<AppLifecycleLock>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Lock on any transition away from foreground. The exact states that mean
    // "not visible to user" vary by platform, so treat everything except
    // resumed as backgrounding.
    if (state == AppLifecycleState.resumed) return;

    _lockSession();
  }

  void _lockSession() {
    // Reading the notifier is safe here: this callback runs on the UI thread,
    // and if the provider is already disposed the read will be a no-op.
    final notifier = ref.read(authProvider.notifier);
    notifier.lock();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
