package edu.columbia.cs.infers;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.SystemClock;
import android.support.v4.app.ActivityCompat;
import android.view.WindowManager;
import android.widget.Toast;

public class SplashActivity extends Activity {

    // Wait duration
    private final int SPLASH_DISPLAY_LENGTH = 1500;

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Remove title bar
        this.requestWindowFeature(getWindow().FEATURE_NO_TITLE);

        // Remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        // Set Layout
        setContentView(R.layout.activity_splash);

        // Ask for Storage Permission (Used by LeakCanary)
        ActivityCompat.requestPermissions(SplashActivity.this,
                new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                1);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // Permission was granted
                    // New Handler to start the Menu-Activity and close this splash screen after some wait time
                    new Handler().postDelayed(new Runnable(){
                        @Override
                        public void run() {
                            // Create an Intent that will start the Menu Activity
                            Intent mainIntent = new Intent(SplashActivity.this,MenuActivity.class);
                            SplashActivity.this.startActivity(mainIntent);
                            // Close the Splash Activity
                            SplashActivity.this.finish();
                        }
                    }, SPLASH_DISPLAY_LENGTH);
                } else {
                    // Permission denied
                    Toast.makeText(SplashActivity.this, "Storage permission required.", Toast.LENGTH_SHORT).show();
                    // Close the Splash Activity
                    SplashActivity.this.finish();
                }
                return;
            }
        }
    }
}