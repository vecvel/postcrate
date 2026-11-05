package com.vecvel.postcrate

import com.vecvel.postcrate.media.PostcrateMediaPlugin
import com.vecvel.postcrate.share.PostcrateSharePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    flutterEngine.plugins.add(PostcrateSharePlugin())
    flutterEngine.plugins.add(PostcrateMediaPlugin())
  }
}
