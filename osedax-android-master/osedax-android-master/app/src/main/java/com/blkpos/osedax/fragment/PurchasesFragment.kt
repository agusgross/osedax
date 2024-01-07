package com.blkpos.osedax.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import com.blkpos.osedax.BuildConfig
import com.blkpos.osedax.R
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.LocaleHelper
import kotlinx.android.synthetic.main.fragment_purchases.*
import java.util.*

class PurchasesFragment : BaseFragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_purchases, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        restorePurchasesButton.setOnClickListener( purchasesButtonClicked )

    }

    private val purchasesButtonClicked = View.OnClickListener {

        fetchChapters()

    }

    private fun fetchChapters(){

        enableUI(false)

        val forceReload = false

        requireActivity().runOnUiThread {
            val userCall =
                retrofit.create(RestApi::class.java).chapters(LocaleHelper.getLocale(), BuildConfig.VERSION_CODE)

            userCall!!.process { chapters, _ ->

                if (chapters != null) {

//                        doAsync {

                    chapters.forEach {

                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterOneOptionA}.webp").preload()
                        GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterOneOptionB}.webp").preload()

                        if  ( it.numberOfCharacters > 1) {
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterTwoOptionA}.webp").preload()
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterTwoOptionB}.webp").preload()

                        }

                        if  ( it.numberOfCharacters > 2) {
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterThreeOptionA}.webp").preload()
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterThreeOptionB}.webp").preload()

                        }

                        if  ( it.numberOfCharacters > 3) {
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterFourOptionA}.webp").preload()
                            GlideApp.with(requireContext()).load("${config.imagesUrl()}${it.characterFourOptionB}.webp").preload()

                        }

                    }


//                        }

                    requireActivity().runOnUiThread {
                        chapterStore.chapters = chapters
                    }
                }

                requireActivity().runOnUiThread {
                    enableUI()
                    Toast.makeText(requireContext(), getString(R.string.purchases_restored), Toast.LENGTH_SHORT).show()
                }


            }

        }


    }

    private fun enableUI(enable: Boolean = true) {

        restorePurchasesButton.visibility = if(enable) View.VISIBLE  else View.GONE
        progressBar.visibility = if(enable) View.GONE  else View.VISIBLE


    }


}