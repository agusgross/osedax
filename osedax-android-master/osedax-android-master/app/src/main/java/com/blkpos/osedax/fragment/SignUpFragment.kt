package com.blkpos.osedax.fragment

import android.content.Context
import android.content.Intent
import android.graphics.Typeface
import android.net.Uri
import android.os.Bundle
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.method.PasswordTransformationMethod
import android.text.style.ClickableSpan
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.Toast
import androidx.core.content.res.ResourcesCompat
import androidx.navigation.fragment.findNavController
import com.blkpos.osedax.BuildConfig
import com.blkpos.osedax.R
import com.blkpos.osedax.activity.MainActivity
import com.blkpos.osedax.activity.ProfileActivity
import com.blkpos.osedax.model.RestResponse
import com.blkpos.osedax.model.User
import com.blkpos.osedax.module.GlideApp
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.DialogHelper
import com.blkpos.osedax.util.InputUtils
import com.blkpos.osedax.util.LocaleHelper
import kotlinx.android.synthetic.main.fragment_login.passwordEditText
import kotlinx.android.synthetic.main.fragment_login.progressBar
import kotlinx.android.synthetic.main.fragment_login.revealPasswordButton
import kotlinx.android.synthetic.main.fragment_signup.*
import kotlinx.android.synthetic.main.layout_loading.*

class SignUpFragment : BaseFragment() {

    var user: User? = null
    var isProfile = false
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_signup, container, false)
    }


    override fun onAttach(context: Context) {
        super.onAttach(context)

        isProfile = requireActivity() is ProfileActivity
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)

        if(!isProfile)
            userStore.removeAccessToken()
        else {

            getUser()

        }
    }

    private fun setupUI(view: View){

        if(isProfile){

            titleTextView.text = getString(R.string.edit_your_profile_details)
            signUpButton.text = getString(R.string.save)

        }

        revealPasswordButton.setOnClickListener(onRevealPasswordButtonClicked)
        signUpButton.setOnClickListener(onSignUpButtonClicked)

        /* hide keyboard on view tap */
        InputUtils.setupTapOutside(baseLayout, requireActivity())

        /* terms */

        val terms = "${getString(R.string.by_signing_up_you_accept)} ${getString(R.string.terms_and_conditions)} ${getString(
            R.string.and_our
        )} ${getString(R.string.privacy_policy)}"

        val sBuilder = SpannableStringBuilder(terms)

        sBuilder.setSpan(
            onTermsClicked,
            terms.indexOf(getString(R.string.terms_and_conditions)),
            terms.indexOf(getString(R.string.terms_and_conditions)) + getString(R.string.terms_and_conditions).length,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        sBuilder.setSpan(
            onPrivacyPolicyClicked,
            terms.indexOf(getString(R.string.privacy_policy)),
            terms.indexOf(getString(R.string.privacy_policy)) + getString(R.string.privacy_policy).length,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )

        termsTextView.setText(sBuilder, TextView.BufferType.SPANNABLE)
        termsTextView.movementMethod = LinkMovementMethod.getInstance()

        /* support */

        val supportText = "${getString(R.string.support_text)} ${getString(R.string.contact_us)}"

        val sBuilder2  = SpannableStringBuilder(supportText)

        sBuilder2.setSpan(
            onSupportClicked,
            supportText.indexOf(getString(R.string.contact_us)),
            supportText.indexOf(getString(R.string.contact_us)) + getString(R.string.contact_us).length,
            Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        supportTextView.setText(sBuilder2, TextView.BufferType.SPANNABLE)
        supportTextView.movementMethod = LinkMovementMethod.getInstance()

    }

    private var showingPassword = false
    private val onRevealPasswordButtonClicked: View.OnClickListener = View.OnClickListener {

        showingPassword = !showingPassword
        revealPasswordButton.setImageDrawable(
            resources.getDrawable(
                if (showingPassword) R.drawable.ic_hide else R.drawable.ic_reveal,
                null
            )
        )

        passwordEditText.transformationMethod = if (showingPassword) null else PasswordTransformationMethod()
        passwordEditText.setSelection(passwordEditText.text.length);

    }

    private val onSignUpButtonClicked: View.OnClickListener = View.OnClickListener {

        InputUtils.hideKeyboard(requireActivity())

        enableUI(false)

//        nestedScrollView.post { nestedScrollView.fullScroll(View.FOCUS_DOWN) }

        if (user == null)
             user = User()

        user?.plainPassword = passwordEditText.text.toString()
        user?.firstName = firstNameEditText.text.toString()
//        user?.lastName = lastNameEditText.text.toString()
        user?.email = emailEditText.text.toString()
        user?.emailNotifications = emailNotificationsCheckbox.isChecked

        val call = retrofit.create(RestApi::class.java)
//        if ( user?.id == null )
        if(isProfile)
            call.editProfile(user)?.process(responseHandler)
        else
            call.register(user)?.process(responseHandler)
//        else
//            call.editProfile(user)?.process(responseHandler)

    }

    private fun enableUI(enable: Boolean){

        signUpButton.visibility = if (enable) View.VISIBLE else View.GONE
        progressBar.visibility = if (enable) View.GONE else View.VISIBLE

    }

    private val responseHandler: (RestResponse?, Throwable?) -> Unit = { restResponse, throwable ->

        if (restResponse != null){

            if ( restResponse.ok){

                if(isProfile){
                    requireActivity().finish()
                } else {

                    val clientId = config.getProperties("Config.properties").getProperty("ClientId")
                    val clientSecret =
                        config.getProperties("Config.properties").getProperty("ClientSecret")

                    if (userStore.isUserLoggedIn()) {

                        User.currentUser = user

                        //                    gotoHome()

                    } else {

                        retrofit.create(RestApi::class.java).login(
                            "password",
                            clientId,
                            clientSecret,
                            user?.email,
                            user?.plainPassword
                        )?.process { oauthResponse, throwable ->


                            if (oauthResponse != null && oauthResponse.error == null && oauthResponse.accessToken != null && oauthResponse.refreshToken != null) {

                                userStore.setAccessToken(
                                    oauthResponse.accessToken,
                                    oauthResponse.refreshToken,
                                    oauthResponse.expiresIn
                                )

                                retrofit.create(RestApi::class.java).user()
                                    ?.process { user, throwable ->

                                        User.currentUser = user

                                        fetchChapters()


                                    }

                            }

                        }
                    }

                }

            } else {

                val errors = restResponse.errors?.map {
                    it.message
                }?.fold("", { acc, s ->

                    acc + getString(
                        requireContext().resources.getIdentifier(
                            s,
                            "string",
                            requireContext().packageName
                        )
                    ) + "\n"

                })

                requireActivity().runOnUiThread {
                    DialogHelper.showDialog(
                        requireContext(),
                        R.string.sign_up,
                        "${getString(R.string.please_verify_the_following)}\n\n$errors",
                        R.string.ok,
                        {
                            enableUI(true)
                        }

                    )
                }
            }


        } else {

            enableUI(true)
            Toast.makeText(
                requireContext(),
                throwable?.localizedMessage.toString(),
                Toast.LENGTH_SHORT
            )
                .show()


        }


    }

    private fun fetchChapters(){

        requireActivity().runOnUiThread {

            val forceReload = true // chapterStore.shouldReset()

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

                    gotoMainActivity()

                }

            } else {


                gotoMainActivity()


            }
        }


    }

    private fun gotoMainActivity(){

        requireActivity().runOnUiThread {
//            startActivity(Intent(requireContext(), MainActivity::class.java))
//            requireActivity().finish();
            findNavController().navigate(R.id.action_SignUpFragment_to_PurchaseFragment)
        }

    }


    private fun getUser(){

        loadingLayout.visibility = View.VISIBLE

        retrofit.create(RestApi::class.java).user()?.process { user, throwable ->

            if(user != null ){

                this.user = user

                requireActivity().runOnUiThread {

                    firstNameEditText.setText(user.firstName)
//                    lastNameEditText.setText(user.lastName)
                    emailEditText.setText(user.email)
                    emailNotificationsCheckbox.isChecked = user.emailNotifications ?: false

                    loadingLayout.visibility = View.GONE

                }



            } else {

                requireActivity().finish()

            }

        }

    }

    var onTermsClicked: ClickableSpan = object : ClickableSpan() {
        override fun onClick(textView: View) {
            val sub = if( LocaleHelper.getLocale() == "es" ) "es" else "www";
            val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://${sub}.osedax.app/terms-conditions"))
            startActivity(browserIntent)
        }

        override fun updateDrawState(ds: TextPaint) {
            super.updateDrawState(ds)
            ds.color = ResourcesCompat.getColor(resources, R.color.colorAccent, null)
            ds.typeface = Typeface.DEFAULT_BOLD
            ds.isUnderlineText = false
        }
    }

    var onPrivacyPolicyClicked: ClickableSpan = object : ClickableSpan() {
        override fun onClick(textView: View) {
            val sub = if( LocaleHelper.getLocale() == "es" ) "es" else "www"
            val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://${sub}.osedax.app/privacy-policy"))
            startActivity(browserIntent)
        }

        override fun updateDrawState(ds: TextPaint) {
            super.updateDrawState(ds)
            ds.color = ResourcesCompat.getColor(resources, R.color.colorAccent, null)
            ds.typeface = Typeface.DEFAULT_BOLD
            ds.isUnderlineText = false
        }
    }

    var onSupportClicked: ClickableSpan = object : ClickableSpan() {
        override fun onClick(textView: View) {
            val intent = Intent(Intent.ACTION_SENDTO)
            intent.type = "text/plain";
            intent.putExtra(Intent.EXTRA_EMAIL, " info@osedax.app");
            startActivity(Intent.createChooser(intent, "Send Email"));

        }

        override fun updateDrawState(ds: TextPaint) {
            super.updateDrawState(ds)
            ds.color = ResourcesCompat.getColor(resources, android.R.color.white, null)
            ds.typeface = Typeface.DEFAULT
            ds.isUnderlineText = true
        }
    }


}