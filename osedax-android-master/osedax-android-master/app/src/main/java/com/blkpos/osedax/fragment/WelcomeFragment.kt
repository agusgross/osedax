package com.blkpos.osedax.fragment

import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.fragment.findNavController
import com.blkpos.osedax.BuildConfig
import com.blkpos.osedax.R
import com.blkpos.osedax.activity.MainActivity
import com.blkpos.osedax.application.App
import com.blkpos.osedax.event.ReloadSlidesEvent
import com.blkpos.osedax.model.Chapter
import com.blkpos.osedax.model.User
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.store.UserStore
import com.blkpos.osedax.util.LocaleHelper
import io.realm.kotlin.where
import kotlinx.android.synthetic.main.fragment_welcome.*
import org.greenrobot.eventbus.EventBus
import org.jetbrains.anko.defaultSharedPreferences
import retrofit2.Retrofit
import java.util.*
import javax.inject.Inject

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class WelcomeFragment : BaseFragment() {

    override fun onCreate(savedInstanceState: Bundle?) {

        (activity?.applicationContext as App).appComponent.inject(this)

        super.onCreate(savedInstanceState)
    }


    override fun onCreateView(
            inflater: LayoutInflater, container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_welcome, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)

        checkUserLoggedIn()

    }

    private fun setupUI(view: View) {

        loginButton.setOnClickListener(onLoginButtonClicked)
        signUpButton.setOnClickListener(onSignUpButtonClicked)

    }

    private val onLoginButtonClicked: View.OnClickListener = View.OnClickListener {


        findNavController().navigate(R.id.action_WelcomeFragment_to_LoginFragment)


    }

    private val onSignUpButtonClicked: View.OnClickListener = View.OnClickListener {


        findNavController().navigate(R.id.action_WelcomeFragment_to_SignUpFragment)


    }

    private fun checkUserLoggedIn() {

//        userStore.removeAccessToken()

        if (userStore.isUserLoggedIn()) {

            val userCall = retrofit.create(RestApi::class.java).user()

            userCall!!.process { user, _ ->

                if (user != null) {

                    User.currentUser = user
                    fetchChapters()

                } else {
                    displayLoginOptions()
                }

            }

        } else {
            displayLoginOptions()
        }

    }

    private fun gotoHome(){

        requireActivity().runOnUiThread {
            startActivity(Intent(requireContext(), MainActivity::class.java))
            requireActivity().finish();
        }


    }

    private fun displayLoginOptions(){

        requireActivity().runOnUiThread {

            progressBar.visibility = View.GONE
            welcomeLayout.visibility = View.VISIBLE

        }

    }

    private fun fetchChapters(){



        requireActivity().runOnUiThread {

            val forceReload = chapterStore.shouldReset()

            if (chapterStore.chapters?.size == 0 || forceReload) { /* if there are no chapters locally, fetch from server */

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
                            if(forceReload) chapterStore.resetCharacterSelection()
                        }
                    }

                    gotoHome()

                }

            } else {

                getNewChapters()


            }
        }


    }

    private fun getNewChapters(){

        val firstChapterReloaded = activity?.defaultSharedPreferences?.getBoolean("firstChapterReloaded", false) ?: false
        val lastChapterId = if(!firstChapterReloaded) 0 else chapterStore.chapters.last().id

        val userCall =
            retrofit.create(RestApi::class.java).getChaptersAfter(
                LocaleHelper.getLocale(),
                lastChapterId,
                BuildConfig.VERSION_CODE
            )

        userCall!!.process { chapters, _ ->

            activity?.defaultSharedPreferences?.edit()?.putBoolean("firstChapterReloaded", true)?.commit()

            chapters?.forEach { chapter: Chapter ->

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

                    chapterStore.appendNewChapter(chapter)

                }

            }

            gotoHome()

        }


    }

}


