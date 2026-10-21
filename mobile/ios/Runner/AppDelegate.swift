import AVFoundation
import Flutter
import Speech
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // H-042: günlük hatırlatma (flutter_local_notifications, README "iOS
    // setup"): uygulama öndeyken de bildirim çizilsin.
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    if let registrar = self.registrar(forPlugin: "HvDevice") {
      HvDevice.register(messenger: registrar.messenger())
    }
    if let registrar = self.registrar(forPlugin: "HvSpeechCapability") {
      HvSpeechCapability.register(messenger: registrar.messenger())
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

/// H-042: günlük hatırlatma cihazın saat diliminde kurulur (IANA adı, ör.
/// "Europe/Istanbul"). Ek eklenti gerekmesin diye burada.
enum HvDevice {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "tr.velzon.hivelzon/device", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "timeZone":
        result(TimeZone.current.identifier)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

/// H-055: "Söyle" yalnızca cihazda tanıma varsa açılır. İzin sormadan ve ağ
/// kullanmadan destek ve izin durumu okunur; ses işlenmez.
enum HvSpeechCapability {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "tr.velzon.hivelzon/speech", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "onDeviceSupport":
        var locale: String? = nil
        if #available(iOS 13.0, *) {
          for id in ["en-US", "en-GB"] {
            if let r = SFSpeechRecognizer(locale: Locale(identifier: id)),
              r.supportsOnDeviceRecognition
            {
              locale = id
              break
            }
          }
        }
        result(["supported": locale != nil, "locale": locale as Any])
      case "permissionStatus":
        let speech = SFSpeechRecognizer.authorizationStatus()
        let mic = AVAudioSession.sharedInstance().recordPermission
        if speech == .denied || speech == .restricted || mic == .denied {
          result("denied")
        } else if speech == .authorized && mic == .granted {
          result("granted")
        } else {
          result("notDetermined")
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
