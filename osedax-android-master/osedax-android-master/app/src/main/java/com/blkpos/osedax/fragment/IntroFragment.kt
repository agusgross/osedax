package com.blkpos.osedax.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.motion.widget.MotionLayout
import com.blkpos.osedax.R
import com.blkpos.osedax.event.AllowDragEvent
import com.blkpos.osedax.event.DragEvent
import com.blkpos.osedax.event.EpisodeLoadedEvent
import com.blkpos.osedax.module.GlideApp
import kotlinx.android.synthetic.main.fragment_intro.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode


class IntroFragment : BaseFragment() {

    var chapterId = 0
    var episodeId = 0

//    private var mInterstitialAd: InterstitialAd? = null

    companion object {

        private const val ARGUMENT_CHAPTER_ID = "ARGUMENT_CHAPTER_ID"
        private const val ARGUMENT_EPISODE_ID = "ARGUMENT_EPISODE_ID"

        fun newInstance(chapterId: Int, episodeId: Int): IntroFragment {
            val f = IntroFragment()

            val args = Bundle()

            args.putInt(ARGUMENT_CHAPTER_ID, chapterId)
            args.putInt(ARGUMENT_EPISODE_ID, episodeId)

            f.arguments = args
            return f
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (arguments != null) {
            this.chapterId = requireArguments().getInt(ARGUMENT_CHAPTER_ID)
            this.episodeId = requireArguments().getInt(ARGUMENT_EPISODE_ID)
        }

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_intro, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: DragEvent?) {

        requireActivity().runOnUiThread {

            startText.visibility = View.INVISIBLE
            arrowLayout.visibility = View.INVISIBLE

        }
    }

    override fun onStart() {
        super.onStart()
        EventBus.getDefault().register(this);
    }

    override fun onStop() {
        super.onStop()
        EventBus.getDefault().unregister(this);
    }

    private fun setupUI(view: View){

        val chapter = chapterStore.chapter(chapterId)
        val numberOfCharacters = chapter.numberOfCharacters
        val episode = chapterStore.episode(chapterId, episodeId)

        // broadcast episode navigation (for main menu selection)
        EventBus.getDefault().post(EpisodeLoadedEvent(chapter.id, episode.id))

        chapterTitleTextView.text = "${chapterStore.getChapterTitle(chapterId)}. ${episode.episodeNumber}"
        titleTextView.text = chapterStore.getEpisodeTitle(chapterId, episodeId)


        var image = "intro_${episode.id}"
        if ( numberOfCharacters >= 1 && episode.isFirstCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterOneName)?.option}"
        }
        if ( numberOfCharacters >= 2 && episode.isSecondCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterTwoName)?.option}"
        }
        if ( numberOfCharacters >= 3 && episode.isThirdCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterThreeName)?.option}"
        }
        if ( numberOfCharacters >= 4 && episode.isFourthCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterFourName)?.option}"
        }

        if ( numberOfCharacters >= 5 && episode.isFifthCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterFiveName)?.option}"
        }

        if ( numberOfCharacters >= 6 && episode.isSixthCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterSixName)?.option}"
        }


        if ( numberOfCharacters >= 7 && episode.isSeventhCharacterPresent) {
            image += "_${chapterStore.characterSelection(chapter.characterSevenName)?.option}"
        }

        GlideApp.with(requireContext()).load("${config.imagesUrl()}${image}.webp").into(imageView)

        var transitionEnded = false
        Handler(Looper.getMainLooper()).postDelayed({

            if ( parallaxView != null) parallaxView.progress = 0.0f

            if ( parallaxView != null) parallaxView.setTransitionListener(
                object: MotionLayout.TransitionListener{
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

                        if (!transitionEnded){

                            EventBus.getDefault().post(AllowDragEvent())

                            // start arrow animation
                            arrowLayout.progress = 0f
                            arrowLayout.transitionToEnd()
                            transitionEnded = true
                        }
                    }

                }
            )

            if ( parallaxView != null) parallaxView.transitionToEnd()


            if( arrowLayout != null) arrowLayout.setTransitionListener(object: MotionLayout.TransitionListener {
                override fun onTransitionTrigger(
                    p0: MotionLayout?,
                    p1: Int,
                    p2: Boolean,
                    p3: Float
                ) {

                }

                override fun onTransitionStarted(p0: MotionLayout?, p1: Int, p2: Int) {

                }

                override fun onTransitionChange(p0: MotionLayout?, p1: Int, p2: Int, p3: Float) {

                }

                override fun onTransitionCompleted(p0: MotionLayout?, p1: Int) {
                    arrowLayout.progress = 0f
                    arrowLayout.transitionToEnd()
                }


            })



        }, 1000)

        /* interstitial ad */
//        if(!chapter.purchased){
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


}
