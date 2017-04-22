package edu.columbia.cs.infers;

import android.app.Activity;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.widget.ImageView;

/* Static View */
public class Option2Activity extends Activity {

    // Static View Variable
    static View view;
    View nonStaticView;

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
        imageView.setImageResource(R.drawable.running_title_2);

        // Set back button action
        this.findViewById(R.id.backOption1Button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Option2Activity.this.finish();
            }
        });

        // Leak memory
        leakMemory();
    }

    private void leakMemory(){
        //view = this.findViewById(R.id.backOption1Button);
        view = new ImageView(this);
	nonStaticView = new ImageView(this);
    }

   @Override
   public void onDestroy(){
        super.onDestroy();
        //view = null;
        nonStaticView = null;
   }
}
