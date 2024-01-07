
package com.blkpos.osedax.fragment

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.blkpos.osedax.R
import com.blkpos.osedax.adapter.ClippingsAdapter
import com.blkpos.osedax.model.TextClipping
import com.blkpos.osedax.network.RestApi
import kotlinx.android.synthetic.main.fragment_clippings.*


class ClippingsFragment : BaseFragment() {

    var clippings = ArrayList<TextClipping>()
    lateinit var adapter: ClippingsAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_clippings, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        clippings.addAll(chapterStore.getClippings())

        recyclerView?.layoutManager = LinearLayoutManager(requireActivity())
        adapter = ClippingsAdapter(clippings, onClippingDeleted, requireContext())
        recyclerView?.adapter = adapter

        emptyStateTextView.visibility = if ( clippings.size == 0 )  View.VISIBLE else View.GONE

    }

    private val onClippingDeleted = object: ClippingsAdapter.ViewHolder.IViewHolderClicks {
        override fun onDelete(clipping: TextClipping?) {

            if(clipping != null ) {
                val clippingId = clipping.id

                retrofit.create(RestApi::class.java).deleteTextClipping(clippingId)?.process { _, _ ->  }

                clippings.remove(clipping)

                adapter.notifyDataSetChanged()

                chapterStore.deleteClipping(clipping.id)

                emptyStateTextView.visibility = if ( clippings.size == 0 )  View.VISIBLE else View.GONE

            }





        }

        override fun onClick(clipping: TextClipping?) {

            if(clipping != null) {
                val returnIntent = Intent()
                returnIntent.putExtra("clippingId",clipping.id);

                activity?.setResult(Activity.RESULT_OK, returnIntent)
                activity?.finish()

            }


        }


    }




}