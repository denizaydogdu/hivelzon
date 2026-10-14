package tr.velzon.hivelzon

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.speech.SpeechRecognizer
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// H-068: audio_service'in paylaşılan FlutterEngine'i (kitap dinleme arka
// planda ve bildirimde sürer).
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // H-055: "Söyle" yalnızca cihazda tanıma varsa açılır (API 31+,
        // isOnDeviceRecognitionAvailable). Yoksa eklenti normal (ağ
        // kullanabilen) tanıyıcıya düşerdi; bu yüzden özellik hiç görünmez.
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "tr.velzon.hivelzon/speech",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "onDeviceSupport" -> {
                    val ok = Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                        SpeechRecognizer.isOnDeviceRecognitionAvailable(this)
                    result.success(
                        mapOf("supported" to ok, "locale" to if (ok) "en-US" else null),
                    )
                }
                "permissionStatus" -> {
                    val granted = checkSelfPermission(Manifest.permission.RECORD_AUDIO) ==
                        PackageManager.PERMISSION_GRANTED
                    result.success(if (granted) "granted" else "notDetermined")
                }
                else -> result.notImplemented()
            }
        }
    }
}
