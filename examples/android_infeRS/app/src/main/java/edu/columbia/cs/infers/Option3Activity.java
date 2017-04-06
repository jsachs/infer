package edu.columbia.cs.infers;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

/* Inner Classes */
public class Option3Activity extends Activity {

    // Inner Class Definition
    class InnerClass {}
    // Static Reference
    static InnerClass innerClass;

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
        imageView.setImageResource(R.drawable.running_title_3);

        // Set back button action
        this.findViewById(R.id.backOption1Button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Option3Activity.this.finish();
            }
        });

        // Leak memory
        leakMemory();
    }

    private void leakMemory(){
        innerClass = new InnerClass();
    }
}