import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let backupChannelName = "co.helm.finance/backup"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let controller = engineBridge.viewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: backupChannelName,
      binaryMessenger: controller.engine!.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      if call.method == "excludeFromBackup" {
        if let args = call.arguments as? [String: Any],
           let path = args["path"] as? String {
          self.excludeFromBackup(path: path)
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func excludeFromBackup(path: String) {
    var url = URL(fileURLWithPath: path)
    var resourceValues = URLResourceValues()
    resourceValues.isExcludedFromBackup = true
    do {
      try url.setResourceValues(resourceValues)
    } catch {
      NSLog("Helm: failed to exclude %@ from backup: %@", path, error.localizedDescription)
    }
  }
}
