package com.carnivalmobile.stream.list;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.google.android.material.snackbar.Snackbar;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;
import androidx.appcompat.widget.Toolbar;
import android.text.TextUtils;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.carnival.sdk.Carnival;
import com.carnival.sdk.Message;
import com.carnival.sdk.MessageActivity;
import com.carnivalmobile.adapter.CarnivalAdapter;
import com.carnivalmobile.stream.list.databinding.TileCompactBinding;
import com.carnivalmobile.view.CarnivalLoadingView;
import com.github.brnunes.swipeablerecyclerview.SwipeableRecyclerViewTouchListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;


public class ListStreamActivity extends AppCompatActivity {

    private static final String TAG = ListStreamActivity.class.getSimpleName();
    private static final String BUNDLE_MESSAGES = "com.carnival.NativeStreamActivity.messages";

    private RecyclerView mRecyclerView;
    private ListAdapter mAdapter;
    private int mShortAnimationDuration;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_single_column);

        final CarnivalLoadingView loadingLayout = (CarnivalLoadingView) findViewById(R.id.loading_layout);

        //Get support v7 Toolbar and set as the active ActionBar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        mShortAnimationDuration = getResources().getInteger(android.R.integer.config_shortAnimTime);

        mRecyclerView = (RecyclerView) findViewById(R.id.stream_recycler_view);
        StaggeredGridLayoutManager gridLayoutManager =
                new StaggeredGridLayoutManager(getColumnCount(), StaggeredGridLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(gridLayoutManager);

        /*
         * When reloading after configuration change, load messages
         * from the saved bundle rather than re-downloading.
         */
        if (savedInstanceState != null && savedInstanceState.containsKey(BUNDLE_MESSAGES)) {
            ArrayList<Message> messages = savedInstanceState.getParcelableArrayList(BUNDLE_MESSAGES);

            if (messages == null || messages.size() < 1) {
                loadingLayout.setFeedbackText(getString(R.string.no_messages));
                loadingLayout.stop();
            } else {
                mAdapter = new ListAdapter(this, messages);
                loadingLayout.setVisibility(View.GONE);
                mRecyclerView.setVisibility(View.VISIBLE);
            }
        } else {
            mAdapter = new ListAdapter(this);

            Carnival.getMessages(new Carnival.MessagesHandler() {
                @Override
                public void onSuccess(final ArrayList<Message> messages) {
                    mAdapter.setMessages(messages);
                    if (messages.size() < 1) {
                        ListStreamActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                loadingLayout.setFeedbackText(getString(R.string.no_messages));
                                loadingLayout.stop();
                                crossfadeViews(mRecyclerView, loadingLayout);
                            }
                        });
                    } else {
                        ListStreamActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mAdapter.notifyItemRangeInserted(0, messages.size() - 1);
                                crossfadeViews(loadingLayout, mRecyclerView);
                            }
                        });
                    }
                }

                @Override
                public void onFailure(Error error) {
                    Log.e(TAG, "getMessages(): " + error.getLocalizedMessage());
                    ListStreamActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            loadingLayout.setFeedbackText(getString(R.string.get_message_failed));
                            loadingLayout.stop();
                            crossfadeViews(mRecyclerView, loadingLayout);
                        }
                    });
                }
            });
        }

        mRecyclerView.setAdapter(mAdapter);

        SwipeableRecyclerViewTouchListener swipeTouchListener =
                new SwipeableRecyclerViewTouchListener(mRecyclerView, new CarnivalSwipeListener());

        mRecyclerView.addOnItemTouchListener(swipeTouchListener);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        //Save Messages to outState bundle to prevent re-downloading on configuration change.
        outState.putParcelableArrayList(BUNDLE_MESSAGES, mAdapter.getMessages());

        super.onSaveInstanceState(outState);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                finish();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * Used by the StaggeredGridLayoutManager to set the number of
     * columns to display based on device rotation.
     * @return 1 column for portrait and 2 for landscape.
     */
    private int getColumnCount() {
        return 1;
    }

    private void crossfadeViews(final View disappearing, final View appearing) {
        if (appearing.getVisibility() != View.VISIBLE) {
            // Set the content view to 0% opacity but visible, so that it is visible
            // (but fully transparent) during the animation.
            appearing.setAlpha(0f);
            appearing.setVisibility(View.VISIBLE);

            // Animate the content view to 100% opacity, and clear any animation
            // listener set on the view.
            appearing.animate()
                    .alpha(1f)
                    .setDuration(mShortAnimationDuration)
                    .setListener(null);
        }

        if (disappearing.getVisibility() != View.GONE) {
            // Animate the loading view to 0% opacity. After the animation ends,
            // set its visibility to GONE as an optimization step (it won't
            // participate in layout passes, etc.)
            disappearing.animate()
                    .alpha(0f)
                    .setDuration(mShortAnimationDuration)
                    .setListener(new AnimatorListenerAdapter() {
                        @Override
                        public void onAnimationEnd(Animator animation) {
                            disappearing.setVisibility(View.GONE);
                        }
                    });
        }
    }

    private class ListAdapter extends CarnivalAdapter<CardViewHolder> {

        public ListAdapter(Context context) {
            super(context);
        }

        public ListAdapter(Context context, ArrayList<Message> messages) {
            super(context, messages);
        }

        @Override
        public CardViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            LayoutInflater layoutInflater = LayoutInflater.from(getApplicationContext());
            TileCompactBinding binding = TileCompactBinding.inflate(layoutInflater);

            return new CardViewHolder(binding);
        }

        @Override
        public void onBindViewHolder(CardViewHolder holder, int position, Message message) {
            CharSequence relativeTime = DateUtils.getRelativeTimeSpanString(message.getCreatedAt().getTime(), System.currentTimeMillis(), DateUtils.DAY_IN_MILLIS);


            TileCompactBinding binding = holder.mBinding;
            binding.setMessage(message);
            binding.setRelativeTime(relativeTime.toString());
            //Remove any pending animations if this cell is reused.
            binding.getRoot().clearAnimation();
            //Set the Message's ID to the button view's tag so that the button knows which message to open.
            binding.button.setTag(message.getMessageID());

            TextView typeTextView = binding.typeTextView;
            ImageView mediaImageView = binding.mediaImageView;
            View unreadIndicator = binding.unreadIndicatorView;
            mediaImageView.setImageDrawable(null);

            if (!TextUtils.isEmpty(message.getImageURL())) {
                mediaImageView.setVisibility(View.VISIBLE);
                Picasso.with(getApplicationContext()).load(message.getImageURL()).into(mediaImageView);
            } else {
                mediaImageView.setVisibility(View.GONE);
            }

            if (typeTextView != null) {
                formatTypeTextView(message, typeTextView);
            }

            if (unreadIndicator != null) {
                unreadIndicator.setVisibility(message.isRead() ? View.GONE : View.VISIBLE);
            }
        }
    }

    private void formatTypeTextView(Message message, TextView typeTextView) {
        if (Message.TYPE_VIDEO.equals(message.getType())) {
            typeTextView.setText(R.string.video);
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_video, 0, 0, 0);
        } else if (Message.TYPE_LINK.equals(message.getType())) {
            typeTextView.setText(R.string.link);
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_link, 0, 0, 0);
        } else if (Message.TYPE_IMAGE.equals(message.getType())) {
            typeTextView.setText(R.string.image);
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_camera, 0, 0, 0);
        } else if (Message.TYPE_FAKE_CALL_MESSAGE.equals(message.getType())) {
            typeTextView.setText(R.string.call);
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_text, 0, 0, 0);
        } else {
            typeTextView.setText(R.string.text);
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_text, 0, 0, 0);
        }
    }

    /**
     * CardViewHolder is just a wrapper around the CardTextBinding that holds all the information regarding each item's view.
     */
    private class CardViewHolder extends RecyclerView.ViewHolder {

        TileCompactBinding mBinding;

        public CardViewHolder(TileCompactBinding binding) {
            super(binding.getRoot());
            mBinding = binding;

            //When item is tapped, get Message's ID from the view tag and open the Message detail.
            mBinding.button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent i = new Intent(getApplicationContext(), MessageActivity.class);
                    String messageId = (String) v.getTag();
                    i.putExtra(Carnival.EXTRA_MESSAGE_ID, messageId);
                    startActivity(i);
                }
            });
        }
    }

    private class CarnivalSwipeListener implements SwipeableRecyclerViewTouchListener.SwipeListener {

        @Override
        public boolean canSwipe(int position) {
            return true;
        }

        @Override
        public void onDismissedBySwipeLeft(RecyclerView recyclerView, int[] reverseSortedPositions) {
            Message message = null;
            for (int position : reverseSortedPositions) {
                message = mAdapter.getMessages().remove(position);
                mAdapter.notifyItemRemoved(position);
            }
            mAdapter.notifyDataSetChanged();

            deleteMessageBySwipe(message);
        }

        @Override
        public void onDismissedBySwipeRight(RecyclerView recyclerView, int[] reverseSortedPositions) {
            Message message = null;
            for (int position : reverseSortedPositions) {
                message = mAdapter.getMessages().remove(position);
                mAdapter.notifyItemRemoved(position);
            }
            mAdapter.notifyDataSetChanged();

            deleteMessageBySwipe(message);
        }

        private void deleteMessageBySwipe(final Message message) {
            Carnival.deleteMessage(message, new Carnival.MessageDeletedHandler() {
                @Override
                public void onSuccess() { }

                @Override
                public void onFailure(Error error) {
                    Snackbar.make(mRecyclerView, R.string.failed_delete_message, Snackbar.LENGTH_LONG)
                            .setAction(R.string.retry, new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    deleteMessageBySwipe(message);
                                }
                            })
                            .show();
                }
            });
        }
    }
}
