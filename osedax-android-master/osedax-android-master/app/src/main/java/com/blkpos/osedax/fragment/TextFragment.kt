package com.blkpos.osedax.fragment

import android.content.res.Configuration
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.*
import android.widget.TextView
import android.widget.Toast
import androidx.constraintlayout.motion.widget.MotionLayout
import androidx.core.widget.NestedScrollView
import com.blkpos.osedax.R
import com.blkpos.osedax.event.*
import com.blkpos.osedax.extension.isSubViewVisible
import com.blkpos.osedax.extension.selectText
import com.blkpos.osedax.extension.setChildViewOnScreenListener
import com.blkpos.osedax.manager.PurchaseManager
import com.blkpos.osedax.model.Bookmark
import com.blkpos.osedax.model.Episode
import com.blkpos.osedax.model.TextClipping
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.ui.LockableNestedScrollView
import com.blkpos.osedax.util.LocaleHelper
import kotlinx.android.synthetic.main.fragment_text.*
import kotlinx.android.synthetic.main.fragment_text.view.*
import org.greenrobot.eventbus.EventBus
import org.json.JSONObject
import java.util.*


class TextFragment : BaseFragment() {

    var chapterId = 0
    var episodeId = 0
    var isNextFragment = false

    companion object {

        private const val ARGUMENT_CHAPTER_ID = "ARGUMENT_CHAPTER_ID"
        private const val ARGUMENT_EPISODE_ID = "ARGUMENT_EPISODE_ID"
        private const val ARGUMENT_IS_NEXT_FRAGMENT = "ARGUMENT_IS_NEXT_FRAGMENT"

        fun newInstance(chapterId: Int, episodeId: Int, isNextFragment: Boolean = false): TextFragment {
            val f = TextFragment()

            val args = Bundle()

            args.putInt(ARGUMENT_CHAPTER_ID, chapterId)
            args.putInt(ARGUMENT_EPISODE_ID, episodeId)
            args.putBoolean(ARGUMENT_IS_NEXT_FRAGMENT, isNextFragment)


            f.arguments = args
            return f
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        retainInstance = true;

        if (arguments != null) {
            this.chapterId = requireArguments().getInt(ARGUMENT_CHAPTER_ID)
            this.episodeId = requireArguments().getInt(ARGUMENT_EPISODE_ID)
            this.isNextFragment = requireArguments().getBoolean(ARGUMENT_IS_NEXT_FRAGMENT)
        }

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_text, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)


    }

    private var imageAppeared = false
    private var reachedEnd = false

    private fun setupUI(view: View){

        view.viewTreeObserver.addOnGlobalLayoutListener {

            if ( !isNextFragment && scrollView != null  ){


                val aView = scrollView.scrollView.getChildAt(scrollView.scrollView.childCount-1)
                val diff = aView.bottom - (scrollView.scrollView.height + scrollView.scrollView.scrollY)

               if(diff < 60 && !reachedEnd) {
                   reachedEnd = true
                   EventBus.getDefault().post(DisplayAdEvent())
               }

                if(!imageAppeared && scrollView.scrollView.isSubViewVisible(imageView)) {
                    imageAppeared = true

                    requireActivity().runOnUiThread {
                        EventBus.getDefault().post(DisplayAdEvent())
                        imageView.animate().alpha(1f).setDuration(1000).setListener(null)

                    }

                }

            }

        }

        scrollView.scrollView.setChildViewOnScreenListener(imageView) {

            if(!isNextFragment &&  !imageAppeared) {
                imageAppeared = true

                requireActivity().runOnUiThread {
                    EventBus.getDefault().post(DisplayAdEvent())
                    imageView.animate().alpha(1f).setDuration(1000).setListener(null)

                }


            }

        }

        val chapter = chapterStore.chapter(chapterId)
        val numberOfCharacters = chapter.numberOfCharacters
        val episode = chapterStore.episode(chapterId, episodeId)

        val bookmark = chapterStore.bookmark
        var characterCode = ""
        if(bookmark?.characterCode != null && bookmark.characterCode?.isEmpty() == false) {
            characterCode = bookmark.characterCode!!
        } else {
            val arr = arrayListOf<String>()
            if (numberOfCharacters >= 1 && episode.isFirstCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterOneName)?.option.toString())
            }
            if (numberOfCharacters >= 2 && episode.isSecondCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterTwoName)?.option.toString())
            }
            if (numberOfCharacters >= 3 && episode.isThirdCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterThreeName)?.option.toString())
            }
            if (numberOfCharacters >= 4 && episode.isFourthCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterFourName)?.option.toString())
            }
            if (numberOfCharacters >= 5 && episode.isFifthCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterFiveName)?.option.toString())
            }

            if (numberOfCharacters >= 6 && episode.isSixthCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterSixName)?.option.toString())
            }

            if (numberOfCharacters >= 7 && episode.isSeventhCharacterPresent) {
                arr.add(chapterStore.characterSelection(chapter.characterSevenName)?.option.toString())
            }

            characterCode = arr.joinToString("_")
        }

        val image = "image_${episode.id}_${characterCode}"

        // broadcast episode navigation (for main menu selection)
        EventBus.getDefault().post(EpisodeLoadedEvent(chapter.id, episode.id))

        GlideApp.with(requireContext()).load("${config.imagesUrl()}${image}.webp").into(imageView)

        val text = chapterStore.getEpisodeText(chapterId, episodeId)
        val text2 = chapterStore.getEpisodeText2(chapterId, episodeId)

//        val thumbnailView: ImageView = view.findViewById(R.id.thumbnail_view)
        val messageView = view.findViewById(R.id.message_view) as TextView
        val message2View = view.findViewById(R.id.message2_view) as TextView



        messageView.customSelectionActionModeCallback = object: ActionMode.Callback {
            override fun onCreateActionMode(mode: ActionMode?, menu: Menu?): Boolean {
                return true
            }

            override fun onPrepareActionMode(mode: ActionMode?, menu: Menu?): Boolean {
                menu?.clear()
                return false
            }

            override fun onActionItemClicked(mode: ActionMode?, item: MenuItem?): Boolean {
                return false
            }

            override fun onDestroyActionMode(mode: ActionMode?) {

            }

        }

        message2View.customSelectionActionModeCallback = object: ActionMode.Callback {
            override fun onCreateActionMode(mode: ActionMode?, menu: Menu?): Boolean {
                return true
            }

            override fun onPrepareActionMode(mode: ActionMode?, menu: Menu?): Boolean {
                menu?.clear()
                return false
            }

            override fun onActionItemClicked(mode: ActionMode?, item: MenuItem?): Boolean {
                return false
            }

            override fun onDestroyActionMode(mode: ActionMode?) {

            }

        }


//        val display: Display = requireActivity().windowManager.defaultDisplay
//        tryFlowText(
//            if (text.length > 1) text.removePrefix(text.substring(0, 1)) else text,
//            thumbnailView,
//            messageView,
//            display
//        )

//        messageView.text = if (text.length > 1) text.removePrefix(text.substring(0, 1)) else text
        messageView.text = JSONObject(text).optString(characterCode, "")
        message2View.text = JSONObject(text2).optString(characterCode, "")

//        select text
//        messageView.selectText(requireContext(), 0, 10)
//        messageView.selectText(requireContext(), 25, 32)

        val identifier = requireContext().resources.getIdentifier(
            "letter_${
                text.subSequence(0, 1).toString().toLowerCase(
                    Locale.ROOT
                )
            }", "drawable", requireContext().packageName
        )
//        thumbnailView.setImageDrawable(ContextCompat.getDrawable(requireContext(), identifier))

        scrollView.setOnScrollChangeListener(onScrollChange)

        /* bookmark */
        if(bookmark != null && bookmark.chapter?.id == chapter.id && bookmark.episode?.id == episode.id){
            scrollView.post(Runnable {
                scrollView.scrollTo(0, bookmark.position)
                message_view.visibility = View.VISIBLE
                message2_view.visibility = View.VISIBLE
//                thumbnail_view.visibility = View.VISIBLE
//                thumbnail2_view.visibility = View.VISIBLE

            })
        } else {
            chapterStore.bookmark = Bookmark(chapter, episode)

            val bookmark = chapterStore.bookmark
            if(bookmark!=null) saveBookmark(bookmark)

            message_view.visibility = View.VISIBLE
            message2_view.visibility = View.VISIBLE
//            thumbnail_view.visibility = View.VISIBLE
//            thumbnail2_view.visibility = View.VISIBLE

        }

        /* purchase content */

        if ( chapterStore.episodeAfter(chapter.id, episodeId) != null ) { /* if it's not the end of the text */

            arrowLayout.setTransitionListener(object : MotionLayout.TransitionListener {
                override fun onTransitionTrigger(
                    p0: MotionLayout?,
                    p1: Int,
                    p2: Boolean,
                    p3: Float
                ) {

                }

                override fun onTransitionStarted(p0: MotionLayout?, p1: Int, p2: Int) {

                }

                override fun onTransitionChange(
                    p0: MotionLayout?,
                    p1: Int,
                    p2: Int,
                    p3: Float
                ) {

                }

                override fun onTransitionCompleted(p0: MotionLayout?, p1: Int) {
                    arrowLayout.progress = 0f
                    arrowLayout.transitionToEnd()
                }


            })

            arrowLayout.progress = 0f
            arrowLayout.transitionToEnd()
            arrowLayout.visibility = View.VISIBLE
        } else {

//            removeAdsTextView.text = getString(R.string.in_order_to_read_end)

        }

        if ( !chapter.purchased) {

//            purchaseLayout.visibility = View.VISIBLE

//            purchaseButton.setOnClickListener {
//
//                val purchaseManager = PurchaseManager(requireActivity()) {
//
//                    val userCall =
//                        retrofit.create(RestApi::class.java).purchase(
//                            LocaleHelper.getLocale(),
//                            chapter.sku
//                        )
//
//                    userCall!!.process { chapter, _ ->
//
//                        if (chapter != null) {
//
//                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterOneOptionA}.webp").preload()
//                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterOneOptionB}.webp").preload()
//
//                            if  ( chapter.numberOfCharacters > 1) {
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterTwoOptionA}.webp").preload()
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterTwoOptionB}.webp").preload()
//
//                            }
//
//                            if  ( chapter.numberOfCharacters > 2) {
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterThreeOptionA}.webp").preload()
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterThreeOptionB}.webp").preload()
//
//                            }
//
//                            if  ( chapter.numberOfCharacters > 3) {
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterFourOptionA}.webp").preload()
//                                GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterFourOptionB}.webp").preload()
//
//                            }
//
//                            requireActivity().runOnUiThread {
//
//                                chapterStore.addChapter(chapter)
//                                EventBus.getDefault().post(ReloadSlidesEvent())
//
//
//                            }
//                        }
//
////                            gotoMainActivity()
//
//                    }
//
//
//
//
//                }
//
//                purchaseManager.purchase(chapter.sku)
//
//
//
//            }
        }

        /* text selection */
        var selectedText: String? = null
        var startIndex: Int = 0
        var endIndex: Int = 0
        var paragraph: Int = 0
        message_view.observeSelectedText { textView, s, start, end ->

            if(textView.hasSelection()) {
                selectedText = s
                startIndex = start
                endIndex = end
                paragraph = 0
                saveTextButton.visibility = View.VISIBLE
            } else {
                selectedText = null
                startIndex = 0
                endIndex = 0
                saveTextButton.visibility = View.GONE
            }
        }

        message2_view.observeSelectedText { textView, s, start, end ->

            if(textView.hasSelection()) {
                selectedText = s
                startIndex = start
                endIndex = end
                paragraph = 1
                saveTextButton.visibility = View.VISIBLE
            } else {
                selectedText = null
                startIndex = 0
                endIndex = 0
                saveTextButton.visibility = View.GONE
            }
        }


        saveTextButton.setOnClickListener OnClick@{

            val selectedText = selectedText ?: return@OnClick

            val startIndex = startIndex
            val endIndex = endIndex
            val paragraph = paragraph

            message_view.clearFocus()
            message2_view.clearFocus()
            saveTextButton.visibility = View.GONE

            if  (paragraph == 0)
                messageView.selectText(requireContext(), startIndex, endIndex)
            else
                message2View.selectText(requireContext(), startIndex, endIndex)

            val textClipping = chapterStore.saveTextClipping(selectedText,  startIndex, endIndex, episode, chapter, paragraph, currentScrollPosition, characterCode)

            if(textClipping != null) saveTextClipping(textClipping)

            Toast.makeText(requireContext(), R.string.clipping_saved, Toast.LENGTH_SHORT).show()
        }

        /* highlight saved clippings */
        val clippings = chapterStore.getClippings(episode)
        for (clipping in clippings) if(clipping.characterCode == characterCode) {

            if ( clipping.paragraph == 0 )
                messageView.selectText(requireContext(), clipping.indexStart, clipping.indexEnd)
            else
                message2View.selectText(requireContext(), clipping.indexStart, clipping.indexEnd)

        }




//        message_view.setOnTouchListener { v, event ->
//            when (event.action) {
//                MotionEvent.ACTION_DOWN -> {
//                }
//                MotionEvent.ACTION_UP -> v.performClick()
//                else -> {
//                }
//            }
//            false
//        }
//        message_view.setOnTouchListener { v, event ->
//
//            v.performClick()
//
//            val textView = v as TextView
//
//
//            if (event.action == android.view.MotionEvent.ACTION_UP && textView.hasSelection()) {
//
////                val text = textView.text.toString().substring(textView.selectionStart, textView.selectionEnd)
//
//                saveTextButton.visibility = View.VISIBLE
//
//            } else {
//                saveTextButton.visibility = View.GONE
//            }
//
//            true
//
//        }

        /* interstitial ad */
//        if(!chapter.purchased) {
//            val adRequest = AdRequest.Builder().build()
//            InterstitialAd.load(
//                requireActivity(),
//                "ca-app-pub-4084713068647778/7944023024",
//                adRequest,
//                object : InterstitialAdLoadCallback() {
//                    override fun onAdFailedToLoad(adError: LoadAdError) {
//                        mInterstitialAd = null
//                    }
//
//                    override fun onAdLoaded(interstitialAd: InterstitialAd) {
//                        mInterstitialAd = interstitialAd
//
//                        mInterstitialAd?.show(requireActivity())
//
//                    }
//                })
//        }


    }


    private var currentScrollPosition = 0
    private val onScrollChange =
        NestedScrollView.OnScrollChangeListener { v, scrollX, scrollY, oldScrollX, oldScrollY ->

            if ( resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE ) {
                saveTextButton.visibility = View.GONE
                message_view.clearFocus()
                message2_view.clearFocus()

                val bookmark = chapterStore.updateBookmarkPosition(scrollY)
                if(bookmark!=null) saveBookmark(bookmark)
                currentScrollPosition = scrollY
            }

            if (scrollY == (v?.getChildAt(0)?.measuredHeight?.minus((v.measuredHeight)))) {

                (v as LockableNestedScrollView)?.setScrollingEnabled(false)
                enablePager()

            }
        }

    private fun enablePager(){
//        Log.d("GGR", "enablePager")
        EventBus.getDefault().post(AllowDragEvent())

    }

    private fun disablePager(){
//        Log.d("GGR", "disablePager")
        EventBus.getDefault().post(LockDragEvent())

    }

    private fun saveTextClipping(textClipping: TextClipping){

        retrofit.create(RestApi::class.java).textClipping(textClipping)?.process { _, _ ->


        }

    }

    private val mainHandler = Handler(Looper.getMainLooper())
    private fun saveBookmark(bookmark: Bookmark){

        mainHandler.removeCallbacksAndMessages(null)
        mainHandler.postDelayed( {
            retrofit.create(RestApi::class.java).bookmark(bookmark)?.process { _, _ ->
            }



        }, 1000 )

    }

}
