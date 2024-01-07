package com.blkpos.osedax.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.blkpos.osedax.R
import com.blkpos.osedax.event.DragEvent
import com.blkpos.osedax.event.ForwardSlidesvent
import com.blkpos.osedax.event.ReloadSlidesEvent
import com.blkpos.osedax.manager.PurchaseManager
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.LocaleHelper
import kotlinx.android.synthetic.main.fragment_purchase_chapter.*
import org.greenrobot.eventbus.EventBus

class PurchaseChapterFragment : BaseFragment() {

    var chapterId = 0
    var episodeId = 0

    companion object {

        private const val ARGUMENT_CHAPTER_ID = "ARGUMENT_CHAPTER_ID"
        private const val ARGUMENT_EPISODE_ID = "ARGUMENT_EPISODE_ID"

        fun newInstance(chapterId: Int, episodeId: Int): PurchaseChapterFragment {
            val f = PurchaseChapterFragment()

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
        return inflater.inflate(R.layout.fragment_purchase_chapter, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){


        skipButton.setOnClickListener(onSkipButtonClicked)
        purchaseButton.setOnClickListener(onPurchaseButtonClicked)


        GlideApp.with(requireContext()).load("${config.imagesUrl()}purchase_${episodeId}.webp").into(imageView)

    }

    private val onSkipButtonClicked: View.OnClickListener = View.OnClickListener {


        EventBus.getDefault().post(ForwardSlidesvent())


    }

    private val onPurchaseButtonClicked: View.OnClickListener = View.OnClickListener {

        enableUI(false)

        val chapter = chapterStore.chapter(chapterId)

        val purchaseManager = PurchaseManager(requireActivity()) {

            val userCall =
                retrofit.create(RestApi::class.java).purchase(
                    LocaleHelper.getLocale(),
                    chapter.sku
                )

            userCall!!.process { chapter, _ ->

                if (chapter != null) {

                    GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterOneOptionA}.webp").preload()
                    GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterOneOptionB}.webp").preload()

                    if  ( chapter.numberOfCharacters > 1) {
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterTwoOptionA}.webp").preload()
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterTwoOptionB}.webp").preload()

                    }

                    if  ( chapter.numberOfCharacters > 2) {
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterThreeOptionA}.webp").preload()
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterThreeOptionB}.webp").preload()

                    }

                    if  ( chapter.numberOfCharacters > 3) {
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterFourOptionA}.webp").preload()
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${chapter.characterFourOptionB}.webp").preload()

                    }

                    requireActivity().runOnUiThread {

                        chapterStore.addChapter(chapter)


                        EventBus.getDefault().post(ReloadSlidesEvent())

                    }
                }



            }




        }

        purchaseManager.purchase("chapter01")

    }

    private fun enableUI(enable: Boolean){

        purchaseButton.visibility = if (enable) View.VISIBLE else View.GONE
        progressBar.visibility = if (enable) View.GONE else View.VISIBLE

    }
}