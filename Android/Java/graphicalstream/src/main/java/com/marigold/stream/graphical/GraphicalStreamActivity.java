package com.marigold.stream.graphical;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

import com.marigold.sdk.MessageStream;
import com.marigold.sdk.model.Message;
import com.marigold.sdk.MessageActivity;
import com.marigold.adapter.MarigoldAdapter;
import com.marigold.stream.graphical.databinding.TileGraphicalBinding;
import com.marigold.stream.graphical.databinding.TileGraphicalTextBinding;
import com.marigold.view.MarigoldLoadingView;
import com.squareup.picasso.Picasso;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class GraphicalStreamActivity extends AppCompatActivity {

    private static final String TAG = GraphicalStreamActivity.class.getSimpleName();
    private static final String BUNDLE_MESSAGES = "com.marigold.NativeStreamActivity.messages";

    private RecyclerView mRecyclerView;
    private GraphicalAdapter mAdapter;
    private int mShortAnimationDuration;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_single_column);

        final MarigoldLoadingView loadingLayout = (MarigoldLoadingView) findViewById(R.id.loading_layout);

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

            if (messages == null || messages.isEmpty()) {
                loadingLayout.setFeedbackText(getString(R.string.no_messages));
                loadingLayout.stop();
            } else {
                mAdapter = new GraphicalAdapter(this, messages);
                loadingLayout.setVisibility(View.GONE);
                mRecyclerView.setVisibility(View.VISIBLE);
            }
        } else {
            mAdapter = new GraphicalAdapter(this);

            new MessageStream().getMessages(new MessageStream.MessagesHandler() {

                @Override
                public void onSuccess(final @NotNull ArrayList<Message> messages) {
                    mAdapter.setMessages(messages);
                    if (messages.isEmpty()) {
                        GraphicalStreamActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                loadingLayout.setFeedbackText(getString(R.string.no_messages));
                                loadingLayout.stop();
                                crossfadeViews(mRecyclerView, loadingLayout);
                            }
                        });
                    } else {
                        GraphicalStreamActivity.this.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mAdapter.notifyItemRangeInserted(0, messages.size());
                                crossfadeViews(loadingLayout, mRecyclerView);
                            }
                        });
                    }
                }

                @Override
                public void onFailure(@NotNull Error error) {
                    Log.e(TAG, "getMessages(): " + error.getLocalizedMessage());
                    GraphicalStreamActivity.this.runOnUiThread(new Runnable() {
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
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        //Save Messages to outState bundle to prevent re-downloading on configuration change.
        if (mAdapter != null) {
            //Only save if we actually have some messages.
            ArrayList<Message> messages = mAdapter.getMessages();
            if (messages != null && !messages.isEmpty()) {
                outState.putParcelableArrayList(BUNDLE_MESSAGES, mAdapter.getMessages());
            }
        }

        super.onSaveInstanceState(outState);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Respond to the action bar's Up/Home button
        if (item.getItemId() == android.R.id.home) {
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

    private class GraphicalAdapter extends MarigoldAdapter<CardViewHolder> {

        public GraphicalAdapter(Context context) {
            super(context);
        }

        public GraphicalAdapter(Context context, ArrayList<Message> messages) {
            super(context, messages);
        }

        @Override
        public @NotNull CardViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            LayoutInflater layoutInflater = LayoutInflater.from(getApplicationContext());
            if (viewType == R.layout.tile_graphical) {
                TileGraphicalBinding binding = TileGraphicalBinding.inflate(layoutInflater);
                return new CardViewHolder(binding);
            } else {
                TileGraphicalTextBinding binding = TileGraphicalTextBinding.inflate(layoutInflater);
                return new CardViewHolder(binding);
            }
        }

        @Override
        public void onBindViewHolder(CardViewHolder holder, int position, Message message) {
            CharSequence relativeTime = DateUtils.getRelativeTimeSpanString(message.getCreatedAt().getTime(), System.currentTimeMillis(), DateUtils.DAY_IN_MILLIS);
            ImageView mediaImageView = null;
            TextView contentTextView = null;
            View unreadIndicator = null;

            if (holder.mGraphicalBinding != null) {
                TileGraphicalBinding binding = holder.mGraphicalBinding;
                binding.setMessage(message);
                binding.setRelativeTime(relativeTime.toString());
                //Set the Message's ID to the button view's tag so that the button knows which message to open.
                binding.button.setTag(message.getMessageID());

                mediaImageView = binding.mediaImageView;
                unreadIndicator = binding.unreadIndicatorView;
            } else if (holder.mTextBinding != null) {
                TileGraphicalTextBinding binding = holder.mTextBinding;
                binding.setMessage(message);
                binding.setRelativeTime(relativeTime.toString());
                //Set the Message's ID to the button view's tag so that the button knows which message to open.
                binding.button.setTag(message.getMessageID());

                unreadIndicator = binding.unreadIndicatorView;
                contentTextView = binding.contentTextView;
            }

            if (unreadIndicator != null) {
                unreadIndicator.setVisibility(message.isRead() ? View.GONE : View.VISIBLE);
            }

            if (contentTextView != null) {
                contentTextView.setText(Html.fromHtml(message.getHtmlText()));
            }

            if (mediaImageView != null) {
                mediaImageView.setImageDrawable(null);

                if (!TextUtils.isEmpty(message.getImageURL())) {
                    Picasso.with(getApplicationContext()).load(message.getImageURL()).into(mediaImageView);
                }
            }
        }

        @Override
        public int getItemViewType(int position, Message message) {
            if (!TextUtils.isEmpty(message.getImageURL())) {
                return R.layout.tile_graphical;
            } else {
                return R.layout.tile_graphical_text;
            }
        }

    }

    /**
     * CardViewHolder is just a wrapper around the TileCompactBinding that holds all the information regarding each item's view.
     */
    private class CardViewHolder extends RecyclerView.ViewHolder {

        TileGraphicalBinding mGraphicalBinding;
        TileGraphicalTextBinding mTextBinding;

        public CardViewHolder(TileGraphicalBinding binding) {
            super(binding.getRoot());
            mGraphicalBinding = binding;
            setOnClick(binding.button);
        }

        public CardViewHolder(TileGraphicalTextBinding binding) {
            super(binding.getRoot());
            mTextBinding = binding;
            setOnClick(binding.button);
        }

        //When item is tapped, get Message's ID from the view tag and open the Message detail.
        private void setOnClick(Button button) {
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent i = new Intent(getApplicationContext(), MessageActivity.class);
                    String messageId = (String) v.getTag();
                    i.putExtra(MessageStream.EXTRA_MESSAGE_ID, messageId);
                    startActivity(i);
                }
            });
        }
    }

}
