package co.helm.finance

import android.os.Bundle
import android.os.Environment
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val BACKUP_CHANNEL = "co.helm.finance/backup"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Prevent screenshots and recent-apps preview of the app content.
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE,
        )
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BACKUP_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "excludeFromBackup" -> {
                    val path = (call.argument<String>("path"))
                    if (path != null) {
                        excludeFromBackup(path)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun excludeFromBackup(path: String) {
        val file = File(path)
        if (file.exists()) {
            file.setWritable(true)
            file.setReadable(true)
        }
        // Android 11+ (API 30): use the StorageManager exclusion flag.
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
            getSystemService(android.content.Context.STORAGE_SERVICE)
                ?.let { it as? android.os.storage.StorageManager }
                ?.let { storageManager ->
                    try {
                        storageManager.setCacheBehaviorGroup(file, false)
                        storageManager.setCacheBehaviorTombstone(file, false)
                    } catch (e: Exception) {
                        android.util.Log.w("Helm", "StorageManager exclusion failed", e)
                    }
                }
        }
        // Block Android M+ (API 23) automated backup for this directory by writing
        // the no-backup marker used by BackupAgent. This is a defense-in-depth
        // measure alongside AndroidManifest allowBackup="false".
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            try {
                File(file, ".nomedia").createNewFile()
            } catch (e: Exception) {
                android.util.Log.w("Helm", "Failed to write .nomedia marker", e)
            }
        }
    }
}
