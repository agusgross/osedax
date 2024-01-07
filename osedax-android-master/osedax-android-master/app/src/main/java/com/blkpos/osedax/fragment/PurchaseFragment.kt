package com.blkpos.osedax.fragment

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.blkpos.osedax.R
import com.blkpos.osedax.activity.MainActivity
import com.blkpos.osedax.event.ReloadSlidesEvent
import com.blkpos.osedax.manager.PurchaseManager
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.LocaleHelper
import kotlinx.android.synthetic.main.fragment_purchase.*
import org.greenrobot.eventbus.EventBus

class PurchaseFragment : BaseFragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_purchase, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        skipButton.setOnClickListener(onSkipButtonClicked)
        purchaseButton.setOnClickListener(onPurchaseButtonClicked)

    }

    private val onSkipButtonClicked: View.OnClickListener = View.OnClickListener {


        gotoMainActivity()


    }

    private val onPurchaseButtonClicked: View.OnClickListener = View.OnClickListener {

        enableUI(false)

        val purchaseManager = PurchaseManager(requireActivity()) {

            val userCall =
                retrofit.create(RestApi::class.java).purchase(
                    LocaleHelper.getLocale(),
                    "chapter01"
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

                        gotoMainActivity()

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

    private fun gotoMainActivity(){

        requireActivity().runOnUiThread {
            startActivity(Intent(requireContext(), MainActivity::class.java))
            requireActivity().finish();
        }

    }


}
