# Helm ProGuard / R8 rules for release builds.
# Keep Hive generated adapters and models — they are reflectively instantiated.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep local_auth plugin classes referenced via reflection.
-keep class androidx.biometric.** { *; }
-keep class androidx.core.hardware.fingerprint.** { *; }

# Keep flutter_secure_storage KeyStore-backed classes.
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep jailbreak / root detection plugin classes.
-keep class com.techlads.** { *; }

# Keep Hive CE generated type adapters.
-keepclassmembers class * {
    @com.isaribi.hive_ce.HiveField <fields>;
}
-keep class * extends com.isaribi.hive_ce.TypeAdapter { *; }

# Google Play Core is referenced by Flutter deferred components but not used by Helm.
-dontwarn com.google.android.play.core.**
