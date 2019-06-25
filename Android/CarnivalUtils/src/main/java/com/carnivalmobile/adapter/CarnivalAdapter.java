package com.carnivalmobile.adapter;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

import com.carnival.sdk.Message;
import com.carnivalmobile.R;

import java.util.ArrayList;

public abstract class CarnivalAdapter<VH extends RecyclerView.ViewHolder> extends RecyclerView.Adapter<VH> {

    private ArrayList<Message> mMessages = new ArrayList<>();
    private int mLastPosition = -1;
    private int mAnimation = R.anim.abc_slide_in_bottom;
    private Context mContext;

    public CarnivalAdapter(Context context) {
        this.mContext = context.getApplicationContext();
        setHasStableIds(true);
    }

    public CarnivalAdapter(Context context, ArrayList<Message> messages) {
        this(context);
        setMessages(messages);
    }

    public void setMessages(ArrayList<Message> messages) {
        mMessages = messages;
    }

    public ArrayList<Message> getMessages() {
        return mMessages;
    }

    @Override
    public abstract VH onCreateViewHolder(ViewGroup parent, int viewType);

    @Override
    public void onBindViewHolder(VH holder, int position) {
        Message message = mMessages.get(position);
        onBindViewHolder(holder, position, message);

        if (holder.itemView != null) {
            applyAnimation(holder.itemView, position);
        }
    }

    @Override
    public void onViewDetachedFromWindow(VH holder) {
        if (holder.itemView != null) {
            holder.itemView.clearAnimation();
        }
    }

    public abstract void onBindViewHolder(VH holder, int position, Message message);

    /**
     * Adds an animation to the cards loaded into the RecyclerView so
     * that new views animate in from the bottom as you scroll.
     * @param viewToAnimate The View to set the animation on
     * @param position The index of the View in the RecyclerView
     */
    private void applyAnimation(View viewToAnimate, int position) {
        if (position > mLastPosition && mAnimation > 0)
        {
            Animation animation = AnimationUtils.loadAnimation(mContext, mAnimation);
            viewToAnimate.startAnimation(animation);
            mLastPosition = position;
        }
    }

    /**
     * Uses a Message's hash code to get a unique ID for each item.
     * @param position Item's index in the RecyclerView
     * @return Message's hash code as a unique ID
     */
    @Override
    public long getItemId(int position) {
        Message message = mMessages.get(position);
        return message.hashCode();
    }

    @Override
    public int getItemCount() {
        if (mMessages != null) {
            return mMessages.size();
        }
        return 0;
    }

    public int getItemViewType(int position, Message message) {
        return 0;
    }

    @Override
    public int getItemViewType(int position) {
        Message message = mMessages.get(position);
        return getItemViewType(position, message);
    }

    public int getAnimation() {
        return mAnimation;
    }

    public void setAnimation(int mAnimation) {
        this.mAnimation = mAnimation;
    }

}