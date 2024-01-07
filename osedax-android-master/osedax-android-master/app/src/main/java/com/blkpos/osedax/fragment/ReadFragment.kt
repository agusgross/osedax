package com.blkpos.osedax.fragment

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.motion.widget.MotionLayout
import androidx.viewpager2.widget.ViewPager2
import com.blkpos.osedax.R
import com.blkpos.osedax.activity.ClippingsActivity
import com.blkpos.osedax.adapter.ReadSlidePagerAdapter
import com.blkpos.osedax.event.*
import com.blkpos.osedax.iface.BackableFragment
import com.blkpos.osedax.model.Bookmark
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.MobileAds
import com.google.android.gms.ads.RequestConfiguration
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import kotlinx.android.synthetic.main.fragment_read.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode


class ReadFragment : BaseFragment(), BackableFragment {

    var adapter: ReadSlidePagerAdapter? = null
    private var mInterstitialAd: InterstitialAd? = null

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_read, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        setPagerAdapter()

        viewPager.isUserInputEnabled = true
        viewPager.registerOnPageChangeCallback(onPageChangeCallback)

        viewPager.setPageTransformer { page, position ->


            val parallaxView = page.findViewById<MotionLayout>(R.id.parallaxView)

            if ( parallaxView != null ){

                when {
                    position < -1 -> page.alpha = 1f
                    position <= 0 -> {
                        parallaxView.translationY = position * (page.width / 3)
                        parallaxView.alpha = 1f+position*3f

                    }
                    else -> page.alpha = 1f
                }

            }

        }

    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: AllowDragEvent?) {

        viewPager.isUserInputEnabled = true

    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: LockDragEvent?) {

        viewPager.isUserInputEnabled = false

    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: DisplayAdEvent?) {

        shouldDisplayAd()

    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: ReloadSlidesEvent?) {

        requireActivity().runOnUiThread {

            setPagerAdapter()

        }


    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: ForwardSlidesvent?) {

        requireActivity().runOnUiThread {

            setPagerAdapter(adapter?.secondSlide)

        }


    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: ReloadBookmarkEvent?) {

        val chapterId = event?.chapterId ?: return
        val episodeId = event.episodeId

        requireActivity().runOnUiThread {


            setPagerAdapter(stepForCharactersOrRead(ReadSlidePagerAdapter.Step.StepIntro(chapterId, episodeId)))

            viewPager.isUserInputEnabled = true

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


    private val onPageChangeCallback: ViewPager2.OnPageChangeCallback = object: ViewPager2.OnPageChangeCallback() {

        var lastPosition = 0
        override fun onPageScrolled(
            position: Int,
            positionOffset: Float,
            positionOffsetPixels: Int
        ) {
            super.onPageScrolled(position, positionOffset, positionOffsetPixels)

            EventBus.getDefault().post(DragEvent())

            if ( position > lastPosition ) {


                lastPosition = 0

                Handler(Looper.getMainLooper()).postDelayed({

                    setPagerAdapter()

                    if ((viewPager.adapter as? ReadSlidePagerAdapter)?.firstSlide is ReadSlidePagerAdapter.Step.StepRead)
                        viewPager.isUserInputEnabled = false


                }, 100)


            } else {

                lastPosition = position

            }
        }


    }


    private fun setPagerAdapter(slide: ReadSlidePagerAdapter.Step? = null) {

        val firstSlide = slide ?: slideAfter(adapter?.firstSlide)

        if (firstSlide != null){

            adapter = ReadSlidePagerAdapter(firstSlide, requireActivity())

            adapter?.secondSlide = slideAfter(firstSlide)

            adapter?.notifyDataSetChanged()
            viewPager?.adapter = adapter
            viewPager.setCurrentItem(0, false)

//            shouldDisplayAd()
        }

    }

    private fun slideAfter(slide: ReadSlidePagerAdapter.Step?): ReadSlidePagerAdapter.Step?{

        return when(slide) {
            null -> slideFromBookmark() ?: stepForCharactersOrRead(slide)
            is ReadSlidePagerAdapter.Step.StepCharacterSelect -> stepForCharactersOrRead(slide)
            is ReadSlidePagerAdapter.Step.StepIntro -> ReadSlidePagerAdapter.Step.StepRead(slide.chapterId,slide.episodeId)
            is ReadSlidePagerAdapter.Step.StepRead -> {
                if (chapterStore.chapter(slide.chapterId).purchased) stepForCharactersOrReadOrEnd(slide) else if(chaptersLeft(slide.chapterId, slide.episodeId)) ReadSlidePagerAdapter.Step.StepPurchase(slide.chapterId,slide.episodeId) else null
            }
            is ReadSlidePagerAdapter.Step.StepPurchase -> stepForCharactersOrReadOrEnd(slide)
        }

    }

    private fun stepForCharactersOrRead(step: ReadSlidePagerAdapter.Step?): ReadSlidePagerAdapter.Step {

        if ( stillHasCharactersToSelect(step))  {

                val nextCharacterSet = nextCharacterSet(step)

            return ReadSlidePagerAdapter.Step.StepCharacterSelect(chapterFromSlide(step),episodeFromSlide(step), nextCharacterSet ?: throw IllegalArgumentException())
        } else{

            if ( step is ReadSlidePagerAdapter.Step.StepCharacterSelect && step.chapterId == chapterStore.bookmark?.chapter?.id  && step.episodeId == chapterStore.bookmark?.episode?.id )
                return ReadSlidePagerAdapter.Step.StepRead(step.chapterId, step.episodeId)
            else
                return ReadSlidePagerAdapter.Step.StepIntro(chapterFromSlide(step),episodeFromSlide(step))
        }
    }

    private fun stepForCharactersOrReadOrEnd(slide: ReadSlidePagerAdapter.Step.StepPurchase): ReadSlidePagerAdapter.Step? {

        return if ( chaptersLeft(slide.chapterId, slide.episodeId))  stepForCharactersOrRead(slide) else null
    }

    private fun stepForCharactersOrReadOrEnd(slide: ReadSlidePagerAdapter.Step.StepRead): ReadSlidePagerAdapter.Step? {

        return if ( chaptersLeft(slide.chapterId, slide.episodeId))  stepForCharactersOrRead(slide) else null
    }

    private fun stillHasCharactersToSelect(step: ReadSlidePagerAdapter.Step?): Boolean{

        return nextCharacterSet(step) != null


    }

    private fun nextCharacterSet(step: ReadSlidePagerAdapter.Step?): Int? {
        return if ( step is ReadSlidePagerAdapter.Step.StepCharacterSelect){
            chapterStore.nextCharacterSet(step.characterSet, step.chapterId, step.episodeId)
        } else if ( step == null )
            chapterStore.nextCharacterSet(-1, null, null)
        else // coming from Read slide, check for characters in next chapter/episode
            chapterStore.nextCharacterSet(-1, chapterFromSlide(step), episodeFromSlide(step))


    }

    private fun chaptersLeft(chapterId: Int, episodeId: Int): Boolean{

//        return chapterStore.chapter(chapterId).purchased && chapterStore.episodeAfter(chapterId, episodeId) != null
        return chapterStore.episodeAfter(chapterId, episodeId) != null

    }

    private fun chapterFromSlide(slide: ReadSlidePagerAdapter.Step?): Int{

        return when ( slide ) {
            null -> chapterStore.firstChapterId() ?: throw IllegalArgumentException()
            is ReadSlidePagerAdapter.Step.StepCharacterSelect -> slide.chapterId
            is ReadSlidePagerAdapter.Step.StepRead -> {
                if (chapterStore.chapter(slide.chapterId).purchased) chapterStore.chapterAfter(slide.chapterId, slide.episodeId)!! else slide.chapterId
            }
            is ReadSlidePagerAdapter.Step.StepIntro -> slide.chapterId
            is ReadSlidePagerAdapter.Step.StepPurchase -> chapterStore.chapterAfter(slide.chapterId, slide.episodeId)!!
        }

    }

    private fun episodeFromSlide(slide: ReadSlidePagerAdapter.Step?): Int{

        return when ( slide ) {
            null ->  return chapterStore.firstEpisodeId() ?: throw IllegalArgumentException()
            is ReadSlidePagerAdapter.Step.StepCharacterSelect -> slide.episodeId
            is ReadSlidePagerAdapter.Step.StepRead -> {
                if (chapterStore.chapter(slide.chapterId).purchased) chapterStore.episodeAfter(slide.chapterId, slide.episodeId)!! else slide.episodeId

            }
            is ReadSlidePagerAdapter.Step.StepIntro -> slide.episodeId
            is ReadSlidePagerAdapter.Step.StepPurchase -> chapterStore.episodeAfter(slide.chapterId, slide.episodeId)!!
        }

    }


    private fun slideFromBookmark(): ReadSlidePagerAdapter.Step? {

        val bookmark = chapterStore.bookmark

        try {
            if (bookmark != null && bookmark.isValid) {
                val chapterId = bookmark.chapter?.id
                val episodeId = bookmark.episode?.id
                if (chapterId != null && episodeId != null) return ReadSlidePagerAdapter.Step.StepRead(
                    chapterId,
                    episodeId
                )
            }

            return null

        } catch(e: IllegalStateException) {
            return null
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        if (requestCode == ClippingsActivity.REQUEST_CODE_CLIPPING && resultCode == Activity.RESULT_OK && data != null) {


            val clipping = chapterStore.getClipping(data.getIntExtra("clippingId", 0))

            if ( clipping != null ) {

                val chapter = chapterStore.chapter(clipping.chapter!!.id)
                val episode = chapterStore.episode(clipping.chapter!!.id, clipping.episode!!.id)

                chapterStore.bookmark = Bookmark(chapter, episode, clipping.position, clipping.characterCode)

                requireActivity().runOnUiThread {

                    setPagerAdapter(slideAfter(null))


                }

            }


        }

        super.onActivityResult(requestCode, resultCode, data)

    }

    override fun onBackPressed() {

        val slide = adapter?.firstSlide

        if ( slide is ReadSlidePagerAdapter.Step.StepCharacterSelect ){
//            EventBus.getDefault().post(ReloadBookmarkEvent(slide.chapterId, slide.episodeId))
//            setPagerAdapter(ReadSlidePagerAdapter.Step.StepRead(slide.chapterId, slide.episodeId))
        } else if ( slide is ReadSlidePagerAdapter.Step.StepIntro) {
            val chapterId = chapterStore.chapterBefore(slide.chapterId, slide.episodeId)
            val episodeId = chapterStore.episodeBefore(slide.chapterId, slide.episodeId)
            if(chapterId != null && episodeId != null) setPagerAdapter(ReadSlidePagerAdapter.Step.StepIntro(chapterId, episodeId))

        } else if ( slide is ReadSlidePagerAdapter.Step.StepRead) {


            val chapterId = chapterStore.chapterBefore(slide.chapterId, slide.episodeId)
            val episodeId = chapterStore.episodeBefore(slide.chapterId, slide.episodeId)
            if(chapterId != null && episodeId != null) setPagerAdapter(ReadSlidePagerAdapter.Step.StepIntro(chapterId, episodeId))

        }

    }

    private fun shouldDisplayAd(){

        val currentSlide = adapter?.firstSlide ?: return

        when (currentSlide){

            is ReadSlidePagerAdapter.Step.StepIntro -> {

                val chapter =  chapterStore.chapter(currentSlide.chapterId)

                if(!chapter.purchased){
                    displayAd()
                    return
                }

            }
            is ReadSlidePagerAdapter.Step.StepCharacterSelect -> {

                val chapter =  chapterStore.chapter(currentSlide.chapterId)

                if(!chapter.purchased && currentSlide.characterSet == 0 && chapterStore.characterSelection(chapter.characterOneName) == null){
                    displayAd()
                    return
                }

            }

            is ReadSlidePagerAdapter.Step.StepRead -> {

                val chapter =  chapterStore.chapter(currentSlide.chapterId)

                if(!chapter.purchased){
                    displayAd()
                    return
                }

            }


        }
    }

    private fun displayAd(){

        /* interstitial ad */

        val configuration = RequestConfiguration.Builder()
            .setTestDeviceIds(listOf("4F22437182A28E3D2B95818EF32D9CB8")).build()
        MobileAds.setRequestConfiguration(configuration)
        val adRequest = AdRequest.Builder().build()

        InterstitialAd.load(
            requireActivity(),
            "ca-app-pub-4084713068647778/7944023024",
            adRequest,
            object : InterstitialAdLoadCallback() {
                override fun onAdFailedToLoad(adError: LoadAdError) {
                    mInterstitialAd = null
                }

                override fun onAdLoaded(interstitialAd: InterstitialAd) {
                    mInterstitialAd = interstitialAd

                    mInterstitialAd?.show(requireActivity())

                }
            })

        }



}
