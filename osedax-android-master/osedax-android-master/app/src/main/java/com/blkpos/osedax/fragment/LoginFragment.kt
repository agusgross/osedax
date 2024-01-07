package com.blkpos.osedax.fragment

import android.content.Intent
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.text.method.PasswordTransformationMethod
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.blkpos.osedax.BuildConfig
import com.blkpos.osedax.R
import com.blkpos.osedax.activity.MainActivity
import com.blkpos.osedax.model.User
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.InputUtils
import com.blkpos.osedax.util.LocaleHelper
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.SimpleTarget
import com.bumptech.glide.request.target.Target
import kotlinx.android.synthetic.main.fragment_login.*
import java.util.*

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class LoginFragment : BaseFragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_login, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        loginButton.setOnClickListener(onLoginButtonClicked)
        revealPasswordButton.setOnClickListener(onRevealPasswordButtonClicked)
        recoverPasswordButton.setOnClickListener(onRecoverPasswordButtonClicked)

        /* hide keyboard on view tap */
        InputUtils.setupTapOutside(baseLayout, requireActivity())

    }

    private var showingPassword = false
    private val onRevealPasswordButtonClicked: View.OnClickListener = View.OnClickListener {

        showingPassword = !showingPassword
        revealPasswordButton.setImageDrawable(resources.getDrawable(if (showingPassword) R.drawable.ic_hide else R.drawable.ic_reveal, null))

        passwordEditText.transformationMethod = if (showingPassword) null else PasswordTransformationMethod()
        passwordEditText.setSelection(passwordEditText.text.length);

    }

    private val onLoginButtonClicked: View.OnClickListener = View.OnClickListener {

        InputUtils.hideKeyboard(requireActivity())

        enableUI(false)

        val clientId = config.getProperties("Config.properties").getProperty("ClientId")
        val clientSecret = config.getProperties("Config.properties").getProperty("ClientSecret")

        retrofit.create(RestApi::class.java).login("password", clientId, clientSecret, emailEditText.text.toString(), passwordEditText.text.toString())?.process { oauthResponse, throwable ->

            requireActivity().runOnUiThread {

                if (oauthResponse != null && oauthResponse.error == null && oauthResponse.accessToken != null && oauthResponse.refreshToken != null) {

                    userStore.setAccessToken(
                        oauthResponse.accessToken,
                        oauthResponse.refreshToken,
                        oauthResponse.expiresIn
                    )

                    retrofit.create(RestApi::class.java).user()?.process { user, throwable ->

                        User.currentUser = user

                        fetchChapters()


                    }

                } else {


                    enableUI(true)
                    Toast.makeText(requireContext(), R.string.login_error, Toast.LENGTH_SHORT)
                        .show()

                }

            }

        }

    }

    private fun fetchChapters(){

        requireActivity().runOnUiThread {

            val forceReload = true //chapterStore.shouldReset()

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


                            retrofit.create(RestApi::class.java).init()?.process { initResponse, throwable ->

                                requireActivity().runOnUiThread {

                                    initResponse?.bookmarks?.forEach {

                                        val chapterId = it.chapter?.id
                                        val episodeId = it.episode?.id
                                        if (chapterId != null && episodeId != null) {
                                            it.chapter = chapterStore.chapter(chapterId)
                                            it.episode = chapterStore.episode(chapterId, episodeId)
                                        }

                                        chapterStore.bookmark = it


                                    }

                                    initResponse?.textClippings?.forEach {

                                        val chapterId = it.chapter?.id
                                        val episodeId = it.episode?.id
                                        if (chapterId != null && episodeId != null) {
                                            it.chapter = chapterStore.chapter(chapterId)
                                            it.episode = chapterStore.episode(chapterId, episodeId)
                                        }

                                        chapterStore.saveTextClipping(it)


                                    }

                                    initResponse?.characterSelects?.forEach {

                                        chapterStore.saveCharacterSelection(it)

                                    }

                                    gotoMainActivity()

                                }



                            }


                        }
                    }



                }

            } else {


                gotoMainActivity()


            }
        }


    }

    private val onRecoverPasswordButtonClicked: View.OnClickListener = View.OnClickListener {

        findNavController().navigate(R.id.action_LoginFragment_to_RecoverFragment)

    }

    private fun enableUI(enable: Boolean){

        recoverPasswordButton.isEnabled = enable
        loginButton.visibility = if (enable) View.VISIBLE else View.GONE
        progressBar.visibility = if (enable) View.GONE else View.VISIBLE

    }

    private fun gotoMainActivity(){

        requireActivity().runOnUiThread {
            startActivity(Intent(requireContext(), MainActivity::class.java))
            requireActivity().finish();
        }

    }


}
