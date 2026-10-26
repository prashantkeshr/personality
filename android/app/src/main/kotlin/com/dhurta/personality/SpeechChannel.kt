package com.dhurta.personality

import android.content.Context
import android.speech.tts.TextToSpeech
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

/// Workout voice cues through the phone's own text-to-speech engine.
/// Started on first use; lines that arrive before it is ready wait for it.
class SpeechChannel(private val context: Context) {
    private var tts: TextToSpeech? = null
    private var ready = false
    private var pending: Pair<String, String>? = null

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "speak" -> {
                val text = call.argument<String>("text") ?: ""
                val lang = call.argument<String>("lang") ?: "en"
                speak(text, lang)
                result.success(null)
            }
            "stop" -> {
                pending = null
                tts?.stop()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun speak(text: String, lang: String) {
        if (text.isBlank()) return
        if (!ready) {
            pending = text to lang
            if (tts == null) {
                tts = TextToSpeech(context.applicationContext) { status ->
                    ready = status == TextToSpeech.SUCCESS
                    pending?.let { (t, l) -> if (ready) say(t, l) }
                    pending = null
                }
            }
            return
        }
        say(text, lang)
    }

    private fun say(text: String, lang: String) {
        val engine = tts ?: return
        val locale = Locale.forLanguageTag(lang)
        // No voice for the app's language: stay quiet rather than read the
        // words with another language's voice.
        if (engine.isLanguageAvailable(locale) < TextToSpeech.LANG_AVAILABLE) return
        engine.language = locale
        engine.speak(text, TextToSpeech.QUEUE_FLUSH, null, "cue")
    }

    fun shutdown() {
        tts?.shutdown()
        tts = null
        ready = false
    }
}
