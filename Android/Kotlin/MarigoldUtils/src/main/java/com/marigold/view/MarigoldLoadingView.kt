package com.marigold.view

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.animation.AnimationUtils
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.RelativeLayout
import android.widget.TextSwitcher
import android.widget.TextView
import com.marigold.R

class MarigoldLoadingView(context: Context, attrs: AttributeSet?) : RelativeLayout(context, attrs) {
    private val mLoadingProgress: ProgressBar
    private val mFeedbackTextView: TextSwitcher
    private val mMarigoldDots: ImageView
    private val mShortAnimationDuration: Int

    init {
        mShortAnimationDuration = context.resources.getInteger(android.R.integer.config_shortAnimTime)
        val marigoldBubble = buildMarigoldBubble(context)
        addView(marigoldBubble)
        mMarigoldDots = buildMarigoldDots(context)
        addView(mMarigoldDots)
        mLoadingProgress = buildProgressBar(context)
        addView(mLoadingProgress)
        mFeedbackTextView = buildFeedbackText(context)
        addView(mFeedbackTextView)
        if (isInEditMode) {
            mLoadingProgress.visibility = GONE
            marigoldBubble.setImageResource(R.drawable.bg_marigold_bubble)
            mFeedbackTextView.setCurrentText("Nothing to see here\nMove along please")
        }
    }

    private fun buildProgressBar(context: Context): ProgressBar {
        val r = context.resources
        val loadingProgressSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 64f, r.displayMetrics).toInt()
        val progressLayout = LayoutParams(loadingProgressSize, loadingProgressSize)
        progressLayout.addRule(CENTER_IN_PARENT, TRUE)
        val loadingProgress = ProgressBar(context)
        loadingProgress.layoutParams = progressLayout
        loadingProgress.isIndeterminate = true
        return loadingProgress
    }

    private fun buildMarigoldBubble(context: Context): ImageView {
        val r = context.resources
        val bubbleLayout = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        bubbleLayout.addRule(CENTER_IN_PARENT, TRUE)
        val bubblePaddingSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 7f, r.displayMetrics).toInt()
        val marigoldBubble = ImageView(context)
        marigoldBubble.id = R.id.marigold_bubble
        marigoldBubble.layoutParams = bubbleLayout
        marigoldBubble.setPadding(0, bubblePaddingSize, 0, 0)
        marigoldBubble.setImageResource(R.drawable.bg_marigold_bubble_blank)
        return marigoldBubble
    }

    private fun buildFeedbackText(context: Context): TextSwitcher {
        val r = context.resources
        val topMarginSize = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 25f, r.displayMetrics).toInt()
        val feedbackLayout = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        feedbackLayout.addRule(BELOW, R.id.marigold_bubble)
        feedbackLayout.addRule(CENTER_HORIZONTAL, TRUE)
        feedbackLayout.setMargins(0, topMarginSize, 0, 0)
        val switcher = TextSwitcher(context)
        switcher.layoutParams = feedbackLayout
        switcher.setFactory {
            val t = TextView(context)
            t.setTextColor(Color.parseColor("#9B9BA2"))
            t.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
            t.gravity = Gravity.CENTER
            t
        }
        val `in` = AnimationUtils.loadAnimation(context, android.R.anim.fade_in)
        val out = AnimationUtils.loadAnimation(context, android.R.anim.fade_out)
        switcher.inAnimation = `in`
        switcher.outAnimation = out
        return switcher
    }

    private fun buildMarigoldDots(context: Context): ImageView {
        val dotsLayout = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
        dotsLayout.addRule(CENTER_IN_PARENT, TRUE)
        val dotsImageView = ImageView(context)
        dotsImageView.layoutParams = dotsLayout
        dotsImageView.setImageResource(R.drawable.marigold_dots)
        dotsImageView.visibility = GONE
        return dotsImageView
    }

    fun setFeedbackText(text: String?) {
        mFeedbackTextView.setText(text)
    }

    fun stop() {
        crossfadeViews(mLoadingProgress, mMarigoldDots, mShortAnimationDuration.toLong())
    }

    fun start() {
        crossfadeViews(mMarigoldDots, mLoadingProgress, mShortAnimationDuration.toLong())
    }

    private fun crossfadeViews(disappearing: View, appearing: View, duration: Long) {
        if (appearing.visibility != VISIBLE) {
            // Set the content view to 0% opacity but visible, so that it is visible
            // (but fully transparent) during the animation.
            appearing.alpha = 0f
            appearing.visibility = VISIBLE

            // Animate the content view to 100% opacity, and clear any animation
            // listener set on the view.
            appearing.animate()
                    .alpha(1f)
                    .setDuration(duration)
                    .setListener(null)
        }
        if (disappearing.visibility != GONE) {
            // Animate the loading view to 0% opacity. After the animation ends,
            // set its visibility to GONE as an optimization step (it won't
            // participate in layout passes, etc.)
            disappearing.animate()
                    .alpha(0f)
                    .setDuration(duration)
                    .setListener(object : AnimatorListenerAdapter() {
                        override fun onAnimationEnd(animation: Animator) {
                            disappearing.visibility = GONE
                        }
                    })
        }
    }
}
