package edu.columbia.cs.infers;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MenuActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Remove title bar
        getSupportActionBar().hide();

        setContentView(R.layout.activity_menu);

        // Set the on-click actions to all buttons
        setButtonsActions();
    }

    void setButtonsActions(){
        this.findViewById(R.id.aboutButton).setOnClickListener(openNewActivityClickListener(MenuActivity.class));
        this.findViewById(R.id.optionButton1).setOnClickListener(openNewActivityClickListener(MenuActivity.class));
        this.findViewById(R.id.optionButton2).setOnClickListener(openNewActivityClickListener(MenuActivity.class));
        this.findViewById(R.id.optionButton3).setOnClickListener(openNewActivityClickListener(MenuActivity.class));
        this.findViewById(R.id.optionButton4).setOnClickListener(openNewActivityClickListener(MenuActivity.class));

    }

    View.OnClickListener openNewActivityClickListener(final Class<?> cls){
        // Return a new OnClickListener
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Create an Intent that will start the provided activity
                Intent intent = new Intent(MenuActivity.this, cls);
                MenuActivity.this.startActivity(intent);
            }
        };
    }
}
