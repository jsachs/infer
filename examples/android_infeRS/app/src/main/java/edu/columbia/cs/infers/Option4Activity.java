package edu.columbia.cs.infers;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.widget.ImageView;

/* Anonymous Classes */
public class Option4Activity extends Activity {

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);

        // Remove title bar
        //this.requestWindowFeature(getWindow().FEATURE_NO_TITLE);
        // Remove notification bar
        //this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_option);

        // Set title image
        ImageView imageView = (ImageView) this.findViewById(R.id.running_title);
        imageView.setImageResource(R.drawable.running_title_4);

        // Set back button action
        this.findViewById(R.id.backOption1Button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Option4Activity.this.finish();
            }
        });

        // Leak memory
        leakMemory();
    }

    private void leakMemory(){
        new AsyncTask<Void, Void, Void>() {
            @Override protected Void doInBackground(Void... params) {
                while(true);
            }
        }.execute();
    }
}