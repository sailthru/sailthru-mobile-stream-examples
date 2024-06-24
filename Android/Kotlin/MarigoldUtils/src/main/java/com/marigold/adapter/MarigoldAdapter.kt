package com.marigold.adapter

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import androidx.recyclerview.widget.RecyclerView
import com.marigold.R
import com.marigold.sdk.model.Message

abstract class MarigoldAdapter<VH : RecyclerView.ViewHolder>(context: Context) : RecyclerView.Adapter<VH>() {
    var messages: ArrayList<Message>? = ArrayList()
    private var mLastPosition = -1
    var animation = R.anim.abc_slide_in_bottom
    private val mContext: Context

    init {
        mContext = context.applicationContext
        setHasStableIds(true)
    }

    constructor(context: Context, messages: ArrayList<Message>?) : this(context) {
        this.messages = messages
    }

    abstract override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH

    override fun onBindViewHolder(holder: VH, position: Int) {
        val message = messages!![position]
        onBindViewHolder(holder, position, message)
        applyAnimation(holder.itemView, position)
    }

    override fun onViewDetachedFromWindow(holder: VH) {
        holder.itemView.clearAnimation()
    }

    abstract fun onBindViewHolder(holder: VH, position: Int, message: Message?)

    /**
     * Adds an animation to the cards loaded into the RecyclerView so
     * that new views animate in from the bottom as you scroll.
     * @param viewToAnimate The View to set the animation on
     * @param position The index of the View in the RecyclerView
     */
    private fun applyAnimation(viewToAnimate: View, position: Int) {
        if (position > mLastPosition && animation > 0) {
            val animation = AnimationUtils.loadAnimation(mContext, animation)
            viewToAnimate.startAnimation(animation)
            mLastPosition = position
        }
    }

    /**
     * Uses a Message's hash code to get a unique ID for each item.
     * @param position Item's index in the RecyclerView
     * @return Message's hash code as a unique ID
     */
    override fun getItemId(position: Int): Long {
        val message = messages!![position]
        return message.hashCode().toLong()
    }

    override fun getItemCount(): Int {
        return if (messages != null) {
            messages!!.size
        } else 0
    }

    open fun getItemViewType(position: Int, message: Message?): Int {
        return 0
    }

    override fun getItemViewType(position: Int): Int {
        val message = messages!![position]
        return getItemViewType(position, message)
    }
}