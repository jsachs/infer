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

import com.squareup.leakcanary.RefWatcher;

public class SplashActivity extends Activity {

    // Wait duration
    private final int SPLASH_DISPLAY_LENGTH = 1500;

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Remove title bar
        //this.requestWindowFeature(getWindow().FEATURE_NO_TITLE);
        // Remove notification bar
        //this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_splash);

        ActivityCompat.requestPermissions(SplashActivity.this,
                new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                1);

        leakMemory();

        /* New Handler to start the Menu-Activity 
         * and close this splash screen after some wait time
        new Handler().postDelayed(new Runnable(){
            @Override
            public void run() {
                // Create an Intent that will start the Menu Activity
                Intent mainIntent = new Intent(SplashActivity.this,MenuActivity.class);
                SplashActivity.this.startActivity(mainIntent);
                // Close the Splash Activity
                SplashActivity.this.finish();
            }
        }, SPLASH_DISPLAY_LENGTH);*/
    }

    private void leakMemory(){
        new Thread() {
            @Override
            public void run(){
                while (true){
                    SystemClock.sleep(1000);
                }
            }
        }.start();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1: {

                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.
                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Toast.makeText(SplashActivity.this, "Permission denied to read your External storage", Toast.LENGTH_SHORT).show();
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }
}