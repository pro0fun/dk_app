import io.flutter.plugins.google.signin.GoogleSignInPlugin;  // Make sure this is imported

public class MainActivity extends FlutterActivity {
  @Override
  protected void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    GoogleSignInPlugin.registerWith(flutterEngine.getDartExecutor());  // Register the plugin
  }
}
