package com.blkpos.osedax.fragment

import android.os.Bundle
import android.util.Log
import android.view.DragEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.annotation.StringRes
import com.blkpos.osedax.R
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.util.InputUtils
import kotlinx.android.synthetic.main.fragment_empty.*
import kotlinx.android.synthetic.main.fragment_login.*
import kotlinx.android.synthetic.main.fragment_read.*

class EmptyFragment : BaseFragment() {

    var second = false
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_empty, container, false)
    }
    companion object {

        const val ARGUMENT_SECOND = "ARGUMENT_SECOND"

        fun newInstance(second: Boolean = false): EmptyFragment {
            val f = EmptyFragment()

            val args = Bundle()

            args.putBoolean(ARGUMENT_SECOND, second)

            f.arguments = args
            return f
        }

    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (arguments != null) {
            this.second = requireArguments().getBoolean(ARGUMENT_SECOND)
        }

    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)


    }

    private fun setupUI(view: View){



        if (second) {
            mainLayout.setBackgroundColor(resources.getColor(android.R.color.white))
        }

    }


}
