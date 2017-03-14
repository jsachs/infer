package edu.columbia.cs.infers;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

public class Option1Activity extends Activity {

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Remove title bar
        this.requestWindowFeature(getWindow().FEATURE_NO_TITLE);
        // Remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_option_1);

        // Set back button action
        this.findViewById(R.id.backOption1Button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Option1Activity.this.finish();
            }
        });
    }
}