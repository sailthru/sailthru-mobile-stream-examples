package com.marigold.nativestream

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.animation.AnimationUtils
import android.widget.FrameLayout
import android.widget.TextSwitcher
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.marigold.stream.card.CardStreamActivity
import com.marigold.stream.graphical.GraphicalStreamActivity
import com.marigold.stream.list.ListStreamActivity
import com.marigold.stream.standard.TileStreamActivity
import java.util.Random

class MainActivity : AppCompatActivity() {
    private var mSwitcher: TextSwitcher? = null
    private lateinit var mGreetings: Array<String>
    private val mRandom = Random()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        mSwitcher = findViewById<View>(R.id.greeting_text_view) as TextSwitcher
        mSwitcher!!.setFactory {
            val params = FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT)
            val t = TextView(this@MainActivity)
            t.setTextColor(Color.WHITE)
            t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 45f)
            t.setGravity(Gravity.CENTER)
            t.setLayoutParams(params)
            t
        }
        val `in` = AnimationUtils.loadAnimation(this, android.R.anim.fade_in)
        val out = AnimationUtils.loadAnimation(this, android.R.anim.fade_out)
        mSwitcher!!.inAnimation = `in`
        mSwitcher!!.outAnimation = out
        mGreetings = resources.getStringArray(R.array.greetings)
        updateGreeting()
    }

    private fun updateGreeting() {
        val index = mRandom.nextInt(mGreetings.size)
        mSwitcher!!.setText(mGreetings[index])
        mSwitcher!!.postDelayed({ updateGreeting() }, 5000)
    }

    fun openCardStream(v: View?) {
        val i = Intent(this, CardStreamActivity::class.java)
        startActivity(i)
    }

    fun openStandardStream(v: View?) {
        val i = Intent(this, TileStreamActivity::class.java)
        startActivity(i)
    }

    fun openGraphicalStream(v: View?) {
        val i = Intent(this, GraphicalStreamActivity::class.java)
        startActivity(i)
    }

    fun openListStream(v: View?) {
        val i = Intent(this, ListStreamActivity::class.java)
        startActivity(i)
    }
}
