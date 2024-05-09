package com.marigold.view

import android.content.Context
import android.util.AttributeSet
import androidx.appcompat.widget.AppCompatImageView
import com.marigold.R

class RectangleImageView : AppCompatImageView {
    private var mFixedDimension = -1
    private var mWidthRatio = 1
    private var mHeightRatio = 1

    constructor(context: Context?) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        val a = context.theme.obtainStyledAttributes(
                attrs,
                R.styleable.RectangleImageView,
                0, 0)
        try {
            mFixedDimension = a.getInteger(R.styleable.RectangleImageView_fixedDimension, FIXED_DIMENSION_WIDTH)
            mWidthRatio = a.getInteger(R.styleable.RectangleImageView_widthRatio, 1)
            mHeightRatio = a.getInteger(R.styleable.RectangleImageView_heightRatio, 1)
        } finally {
            a.recycle()
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        if (mFixedDimension == FIXED_DIMENSION_WIDTH) {
            val height = measuredWidth / mWidthRatio * mHeightRatio
            setMeasuredDimension(measuredWidth, height)
        } else if (mFixedDimension == FIXED_DIMENSION_HEIGHT) {
            val width = measuredHeight / mHeightRatio * mWidthRatio
            setMeasuredDimension(width, measuredHeight)
        }
    }

    companion object {
        private const val FIXED_DIMENSION_WIDTH = 0
        private const val FIXED_DIMENSION_HEIGHT = 1
    }
}
