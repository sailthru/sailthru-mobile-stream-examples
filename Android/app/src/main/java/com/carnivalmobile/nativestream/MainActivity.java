package com.carnivalmobile.nativestream;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.TextSwitcher;
import android.widget.TextView;
import android.widget.ViewSwitcher;

import com.carnivalmobile.stream.card.CardStreamActivity;
import com.carnivalmobile.stream.graphical.GraphicalStreamActivity;
import com.carnivalmobile.stream.list.ListStreamActivity;
import com.carnivalmobile.stream.standard.TileStreamActivity;

import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private TextSwitcher mSwitcher;
    private String[] mGreetings;

    private Random mRandom = new Random();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mSwitcher = (TextSwitcher) findViewById(R.id.greeting_text_view);
        mSwitcher.setFactory(new ViewSwitcher.ViewFactory() {

            @Override
            public View makeView() {
                FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT);
                TextView t = new TextView(MainActivity.this);
                t.setTextColor(Color.WHITE);
                t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 45);
                t.setGravity(Gravity.CENTER);
                t.setLayoutParams(params);
                return t;
            }
        });

        Animation in = AnimationUtils.loadAnimation(this, android.R.anim.fade_in);
        Animation out = AnimationUtils.loadAnimation(this, android.R.anim.fade_out);
        mSwitcher.setInAnimation(in);
        mSwitcher.setOutAnimation(out);

        mGreetings = getResources().getStringArray(R.array.greetings);

        updateGreeting();
    }

    private void updateGreeting() {
        int index = mRandom.nextInt(mGreetings.length);
        mSwitcher.setText(mGreetings[index]);
        mSwitcher.postDelayed(new Runnable() {
            @Override
            public void run() {
                updateGreeting();
            }
        }, 5000);
    }

    public void openCardStream(View v) {
        Intent i = new Intent(this, CardStreamActivity.class);
        startActivity(i);
    }

    public void openStandardStream(View v) {
        Intent i = new Intent(this, TileStreamActivity.class);
        startActivity(i);
    }

    public void openGraphicalStream(View v) {
        Intent i = new Intent(this, GraphicalStreamActivity.class);
        startActivity(i);
    }

    public void openListStream(View v) {
        Intent i = new Intent(this, ListStreamActivity.class);
        startActivity(i);
    }
}
