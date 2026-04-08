import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class TaraVoiceService {
  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();

  bool isAwake = false;
  bool isListening = false;

  Timer? sleepTimer;

  // ✅ Init Tara
  Future<void> init() async {
    // ✅ Ask mic permission
    await Permission.microphone.request();

    bool available = await speech.initialize(
      onStatus: (status) => print("🎙 Tara Status: $status"),
      onError: (error) => print("❌ Tara Error: $error"),
    );

    if (!available) {
      print("❌ Speech Recognition NOT Available");
      return;
    }

    // ✅ Female voice setup
    await tts.setLanguage("en-IN");
    await tts.setPitch(1.1);
    await tts.setSpeechRate(0.45);

    await speak("Tara is sleeping. Say Wake up Tara.");
  }

  // ✅ Speak function
  Future<void> speak(String msg) async {
    await tts.stop();
    await tts.speak(msg);
  }

  // ✅ Start Listening Always
  void start(Function(String) onCommand) async {
    if (isListening) return;

    isListening = true;

    speech.listen(
      listenMode: ListenMode.confirmation,
      onResult: (result) {
        String text = result.recognizedWords.toLowerCase();

        print("🗣 Heard: $text");

        if (text.isEmpty) return;

        // ✅ Wake Command
        if (!isAwake && text.contains("wake up tara")) {
          wakeUp();
          return;
        }

        // ✅ Sleep Command
        if (isAwake && text.contains("sleep tara")) {
          goSleep();
          return;
        }

        // ✅ Process Commands
        if (isAwake) {
          resetSleepTimer();
          onCommand(text);
        }
      },
    );
  }

  // ✅ Wake Tara
  Future<void> wakeUp() async {
    isAwake = true;
    await speak("Hello Abhinay. Tara is active now.");
    resetSleepTimer();
  }

  // ✅ Sleep Tara
  Future<void> goSleep() async {
    isAwake = false;
    await speak("Okay. Tara is going to sleep.");
    sleepTimer?.cancel();
  }

  // ✅ Auto Sleep After 5 Minutes
  void resetSleepTimer() {
    sleepTimer?.cancel();

    sleepTimer = Timer(const Duration(minutes: 5), () {
      goSleep();
    });
  }

  // ✅ Dispose
  void stop() {
    speech.stop();
    sleepTimer?.cancel();
  }
}
