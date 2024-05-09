package com.marigold.stream.graphical

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.Html
import android.text.TextUtils
import android.text.format.DateUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.marigold.adapter.MarigoldAdapter
import com.marigold.sdk.MessageActivity
import com.marigold.sdk.MessageStream
import com.marigold.sdk.model.Message
import com.marigold.stream.graphical.databinding.TileGraphicalBinding
import com.marigold.stream.graphical.databinding.TileGraphicalTextBinding
import com.marigold.view.MarigoldLoadingView
import com.squareup.picasso.Picasso

class GraphicalStreamActivity : AppCompatActivity() {
    private var mRecyclerView: RecyclerView? = null
    private var mAdapter: GraphicalAdapter? = null
    private var mShortAnimationDuration = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_single_column)
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
            if (messages.isNullOrEmpty()) {
                loadingLayout.setFeedbackText(getString(R.string.no_messages))
                loadingLayout.stop()
            } else {
                mAdapter = GraphicalAdapter(this, messages)
                loadingLayout.visibility = View.GONE
                mRecyclerView!!.visibility = View.VISIBLE
            }
        } else {
            mAdapter = GraphicalAdapter(this)
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
    }

    override fun onSaveInstanceState(outState: Bundle) {
        //Save Messages to outState bundle to prevent re-downloading on configuration change.
        if (mAdapter != null) {
            //Only save if we actually have some messages.
            val messages = mAdapter!!.messages
            if (messages != null && !messages.isEmpty()) {
                outState.putParcelableArrayList(BUNDLE_MESSAGES, mAdapter!!.messages)
            }
        }
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
    get() = 1

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

    private inner class GraphicalAdapter : MarigoldAdapter<CardViewHolder> {
        constructor(context: Context) : super(context)
        constructor(context: Context, messages: ArrayList<Message>?) : super(context, messages)

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CardViewHolder {
            val layoutInflater = LayoutInflater.from(applicationContext)
            return if (viewType == R.layout.tile_graphical) {
                val binding = TileGraphicalBinding.inflate(layoutInflater)
                CardViewHolder(binding)
            } else {
                val binding = TileGraphicalTextBinding.inflate(layoutInflater)
                CardViewHolder(binding)
            }
        }

        override fun onBindViewHolder(holder: CardViewHolder, position: Int, message: Message?) {
            val relativeTime = DateUtils.getRelativeTimeSpanString(
                message!!.createdAt.time, System.currentTimeMillis(), DateUtils.DAY_IN_MILLIS
            )
            var mediaImageView: ImageView? = null
            var contentTextView: TextView? = null
            var unreadIndicator: View? = null
            if (holder.mGraphicalBinding != null) {
                val binding = holder.mGraphicalBinding
                binding!!.setMessage(message)
                binding.setRelativeTime(relativeTime.toString())
                //Set the Message's ID to the button view's tag so that the button knows which message to open.
                binding.button.tag = message.messageID
                mediaImageView = binding.mediaImageView
                unreadIndicator = binding.unreadIndicatorView
            } else if (holder.mTextBinding != null) {
                val binding = holder.mTextBinding
                binding!!.setMessage(message)
                binding.setRelativeTime(relativeTime.toString())
                //Set the Message's ID to the button view's tag so that the button knows which message to open.
                binding.button.tag = message.messageID
                unreadIndicator = binding.unreadIndicatorView
                contentTextView = binding.contentTextView
            }
            if (unreadIndicator != null) {
                unreadIndicator.visibility = if (message.isRead) View.GONE else View.VISIBLE
            }
            if (contentTextView != null) {
                contentTextView.text = Html.fromHtml(message.htmlText)
            }
            if (mediaImageView != null) {
                mediaImageView.setImageDrawable(null)
                if (!TextUtils.isEmpty(message.imageURL)) {
                    Picasso.with(applicationContext).load(message.imageURL).into(mediaImageView)
                }
            }
        }

        override fun getItemViewType(position: Int, message: Message?): Int {
            return if (!TextUtils.isEmpty(message!!.imageURL)) {
                R.layout.tile_graphical
            } else {
                R.layout.tile_graphical_text
            }
        }
    }

    /**
     * CardViewHolder is just a wrapper around the TileCompactBinding that holds all the information regarding each item's view.
     */
    private inner class CardViewHolder : RecyclerView.ViewHolder {
        var mGraphicalBinding: TileGraphicalBinding? = null
        var mTextBinding: TileGraphicalTextBinding? = null

        constructor(binding: TileGraphicalBinding) : super(binding.root) {
            mGraphicalBinding = binding
            setOnClick(binding.button)
        }

        constructor(binding: TileGraphicalTextBinding) : super(binding.root) {
            mTextBinding = binding
            setOnClick(binding.button)
        }

        //When item is tapped, get Message's ID from the view tag and open the Message detail.
        private fun setOnClick(button: Button) {
            button.setOnClickListener { v ->
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

    companion object {
        private val TAG = GraphicalStreamActivity::class.java.getSimpleName()
        private const val BUNDLE_MESSAGES = "com.marigold.NativeStreamActivity.messages"
    }
}
