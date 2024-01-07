package com.blkpos.osedax.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.annotation.StringRes
import com.blkpos.osedax.R
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.InputUtils
import kotlinx.android.synthetic.main.fragment_login.*

class RecoverFragment : BaseFragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_recover, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        recoverPasswordButton.setOnClickListener(onRecoverPasswordButtonClicked)
    }


    private val onRecoverPasswordButtonClicked: View.OnClickListener = View.OnClickListener {

        if (emailEditText.text.isNotEmpty()) {

            InputUtils.hideKeyboard(requireActivity())

            enableUI(false)

            retrofit.create(RestApi::class.java).recover(email = emailEditText.text.toString())?.process { response, throwable ->

                requireActivity().runOnUiThread {

                    @StringRes var id = 0

                    if (response?.ok == true) {

                        id = R.string.the_password_was_sent

                    } else {

                        id = R.string.email_not_found

                    }

                    Toast.makeText(requireContext(), id, Toast.LENGTH_SHORT)
                        .show()

                    enableUI(true)

                }

            }

        }
    }

    private fun enableUI(enable: Boolean){

        recoverPasswordButton.visibility = if (enable) View.VISIBLE else View.GONE
        progressBar.visibility = if (enable) View.GONE else View.VISIBLE

    }


}
