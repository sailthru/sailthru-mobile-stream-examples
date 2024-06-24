package com.marigold.stream.card

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.text.Html
import android.text.TextUtils
import android.text.format.DateUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.github.brnunes.swipeablerecyclerview.SwipeableRecyclerViewTouchListener
import com.google.android.material.snackbar.Snackbar
import com.marigold.adapter.MarigoldAdapter
import com.marigold.sdk.MessageActivity
import com.marigold.sdk.MessageStream
import com.marigold.sdk.model.Message
import com.marigold.sdk.model.Message.Companion.TYPE_IMAGE
import com.marigold.sdk.model.Message.Companion.TYPE_LINK
import com.marigold.sdk.model.Message.Companion.TYPE_VIDEO
import com.marigold.stream.card.databinding.CardTextBinding
import com.marigold.view.MarigoldLoadingView
import com.squareup.picasso.Picasso

class CardStreamActivity : AppCompatActivity() {
    private var mRecyclerView: RecyclerView? = null
    private var mAdapter: CardAdapter? = null
    private var mShortAnimationDuration = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_double_column)
        val loadingLayout = findViewById<View>(R.id.loading_layout) as MarigoldLoadingView

        //Get support v7 Toolbar and set as the active ActionBar
        val toolbar = findViewById<View>(R.id.toolbar) as Toolbar
        setSupportActionBar(toolbar)
        val actionBar = supportActionBar
        actionBar?.setDisplayHomeAsUpEnabled(true)
        mShortAnimationDuration = resources.getInteger(android.R.integer.config_shortAnimTime)
        mRecyclerView = findViewById<View>(R.id.stream_recycler_view) as RecyclerView
        val gridLayoutManager =
            StaggeredGridLayoutManager(columnCount, StaggeredGridLayoutManager.VERTICAL)
        mRecyclerView!!.layoutManager = gridLayoutManager

        /*
         * When reloading after configuration change, load messages
         * from the saved bundle rather than re-downloading.
         */if (savedInstanceState != null && savedInstanceState.containsKey(BUNDLE_MESSAGES)) {
            val messages = savedInstanceState.getParcelableArrayList<Message>(
                BUNDLE_MESSAGES
            )
            if (messages == null || messages.isEmpty()) {
                loadingLayout.setFeedbackText(getString(R.string.no_messages))
                loadingLayout.stop()
            } else {
                mAdapter = CardAdapter(this, messages)
                loadingLayout.visibility = View.GONE
                mRecyclerView!!.visibility = View.VISIBLE
            }
        } else {
            mAdapter = CardAdapter(this)
            MessageStream().getMessages(object : MessageStream.MessagesHandler {
                override fun onSuccess(messages: ArrayList<Message>) {
                    mAdapter!!.messages = messages
                    if (messages.isEmpty()) {
                        runOnUiThread {
                            loadingLayout.setFeedbackText(getString(R.string.no_messages))
                            loadingLayout.stop()
                            crossfadeViews(mRecyclerView, loadingLayout)
                        }
                    } else {
                        runOnUiThread {
                            mAdapter!!.notifyItemRangeInserted(0, messages.size)
                            crossfadeViews(loadingLayout, mRecyclerView)
                        }
                    }
                }

                override fun onFailure(error: Error) {
                    Log.e(TAG, "getMessages(): " + error.localizedMessage)
                    runOnUiThread {
                        loadingLayout.setFeedbackText(getString(R.string.get_message_failed))
                        loadingLayout.stop()
                        crossfadeViews(mRecyclerView, loadingLayout)
                    }
                }
            })
        }
        mRecyclerView!!.adapter = mAdapter
        val swipeTouchListener =
            SwipeableRecyclerViewTouchListener(mRecyclerView, MarigoldSwipeListener())
        mRecyclerView!!.addOnItemTouchListener(swipeTouchListener)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        //Save Messages to outState bundle to prevent re-downloading on configuration change.
        outState.putParcelableArrayList(BUNDLE_MESSAGES, mAdapter!!.messages)
        super.onSaveInstanceState(outState)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Respond to the action bar's Up/Home button
        if (item.itemId == android.R.id.home) {
            finish()
            return true
        }
        return super.onOptionsItemSelected(item)
    }

    private val columnCount: Int
    /**
     * Used by the StaggeredGridLayoutManager to set the number of
     * columns to display based on device rotation.
     * @return 1 column for portrait and 2 for landscape.
     */
    get() = when (resources.configuration.orientation) {
        Configuration.ORIENTATION_LANDSCAPE -> 2
        else -> 1
    }

    private fun crossfadeViews(disappearing: View?, appearing: View?) {
        if (appearing!!.visibility != View.VISIBLE) {
            // Set the content view to 0% opacity but visible, so that it is visible
            // (but fully transparent) during the animation.
            appearing.setAlpha(0f)
            appearing.visibility = View.VISIBLE

            // Animate the content view to 100% opacity, and clear any animation
            // listener set on the view.
            appearing.animate()
                .alpha(1f)
                .setDuration(mShortAnimationDuration.toLong())
                .setListener(null)
        }
        if (disappearing!!.visibility != View.GONE) {
            // Animate the loading view to 0% opacity. After the animation ends,
            // set its visibility to GONE as an optimization step (it won't
            // participate in layout passes, etc.)
            disappearing.animate()
                .alpha(0f)
                .setDuration(mShortAnimationDuration.toLong())
                .setListener(object : AnimatorListenerAdapter() {
                    override fun onAnimationEnd(animation: Animator) {
                        disappearing.visibility = View.GONE
                    }
                })
        }
    }

    private inner class CardAdapter : MarigoldAdapter<CardViewHolder> {
        constructor(context: Context) : super(context)
        constructor(context: Context, messages: ArrayList<Message>?) : super(context, messages)

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CardViewHolder {
            val layoutInflater = LayoutInflater.from(applicationContext)
            val binding = CardTextBinding.inflate(layoutInflater)
            return CardViewHolder(binding)
        }

        override fun onBindViewHolder(holder: CardViewHolder, position: Int, message: Message?) {
            val relativeTime = DateUtils.getRelativeTimeSpanString(
                message!!.createdAt.time, System.currentTimeMillis(), DateUtils.DAY_IN_MILLIS
            )
            val binding = holder.mBinding
            binding.setMessage(message)
            binding.setRelativeTime(relativeTime.toString())
            //Remove any pending animations if this cell is reused.
            binding.root.clearAnimation()
            //Set the Message's ID to the button view's tag so that the button knows which message to open.
            binding.button.tag = message.messageID
            val typeTextView = binding.typeTextView
            val contentTextView = binding.contentTextView
            val mediaImageView: ImageView = binding.mediaImageView
            val unreadIndicator: View = binding.unreadIndicatorView
            mediaImageView.setImageDrawable(null)
            if (!TextUtils.isEmpty(message.imageURL)) {
                mediaImageView.setVisibility(View.VISIBLE)
                Picasso.with(applicationContext).load(message.imageURL).into(mediaImageView)
            } else {
                mediaImageView.setVisibility(View.GONE)
            }
            if (TextUtils.isEmpty(message.text)) {
                contentTextView.visibility = View.GONE
            } else {
                contentTextView.visibility = View.VISIBLE
                contentTextView.text = Html.fromHtml(message.htmlText)
            }
            formatTypeTextView(message, typeTextView)
            unreadIndicator.visibility = if (message.isRead) View.GONE else View.VISIBLE
        }
    }

    private fun formatTypeTextView(message: Message?, typeTextView: TextView) {
        if (TYPE_VIDEO == message!!.type) {
            typeTextView.setText(R.string.video)
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_video, 0, 0, 0)
        } else if (TYPE_LINK == message.type) {
            typeTextView.setText(R.string.link)
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_link, 0, 0, 0)
        } else if (TYPE_IMAGE == message.type) {
            typeTextView.setText(R.string.image)
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_camera, 0, 0, 0)
        } else {
            typeTextView.setText(R.string.text)
            typeTextView.setCompoundDrawablesWithIntrinsicBounds(R.drawable.ic_meta_text, 0, 0, 0)
        }
    }

    /**
     * CardViewHolder is just a wrapper around the CardTextBinding that holds all the information regarding each item's view.
     */
    private inner class CardViewHolder(var mBinding: CardTextBinding) : RecyclerView.ViewHolder(
        mBinding.root
    ) {
        init {

            //When item is tapped, get Message's ID from the view tag and open the Message detail.
            mBinding.button.setOnClickListener { v ->
                val i = Intent(
                    applicationContext,
                    MessageActivity::class.java
                )
                val messageId = v.tag as String
                i.putExtra(MessageStream.EXTRA_MESSAGE_ID, messageId)
                startActivity(i)
            }
        }
    }

    private inner class MarigoldSwipeListener : SwipeableRecyclerViewTouchListener.SwipeListener {
        override fun canSwipe(position: Int): Boolean {
            return true
        }

        override fun onDismissedBySwipeLeft(
            recyclerView: RecyclerView,
            reverseSortedPositions: IntArray
        ) {
            var message: Message? = null
            for (position in reverseSortedPositions) {
                message = mAdapter!!.messages!!.removeAt(position)
                mAdapter!!.notifyItemRemoved(position)
            }
            mAdapter!!.notifyDataSetChanged()
            deleteMessageBySwipe(message)
        }

        override fun onDismissedBySwipeRight(
            recyclerView: RecyclerView,
            reverseSortedPositions: IntArray
        ) {
            var message: Message? = null
            for (position in reverseSortedPositions) {
                message = mAdapter!!.messages!!.removeAt(position)
                mAdapter!!.notifyItemRemoved(position)
            }
            mAdapter!!.notifyDataSetChanged()
            deleteMessageBySwipe(message)
        }

        private fun deleteMessageBySwipe(message: Message?) {
            MessageStream().deleteMessage(message!!, object : MessageStream.MessageDeletedHandler {
                override fun onSuccess() {}
                override fun onFailure(error: Error) {
                    Snackbar.make(
                        mRecyclerView!!,
                        R.string.failed_delete_message,
                        Snackbar.LENGTH_LONG
                    )
                        .setAction(
                            R.string.retry
                        ) { deleteMessageBySwipe(message) }
                        .show()
                }
            })
        }
    }

    companion object {
        private val TAG = CardStreamActivity::class.java.getSimpleName()
        private const val BUNDLE_MESSAGES = "com.marigold.NativeStreamActivity.messages"
    }
}
