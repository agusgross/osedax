package com.blkpos.osedax.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import com.blkpos.osedax.R
import com.blkpos.osedax.model.TextClipping

class ClippingsAdapter(
    val clippings: ArrayList<TextClipping>,
    val listener: ViewHolder.IViewHolderClicks,
    val context: Context
) :
    RecyclerView.Adapter<ClippingsAdapter.ViewHolder?>() {

    override fun onBindViewHolder(viewHolder: ViewHolder, i: Int) {

        viewHolder.bind(clippings[i], listener, context)


    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {


        return ViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.cell_clipping, parent, false))


    }

    override fun getItemCount(): Int {
        return clippings.size
    }

    class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private var clippingTitleTextView: TextView = itemView.findViewById(R.id.clippingTitleTextView)
        private var clippingTextView: TextView = itemView.findViewById(R.id.clippingTextView)
        private var deleteButton: ImageButton = itemView.findViewById(R.id.deleteButton)
        private var gotoTextButton: ImageButton = itemView.findViewById(R.id.gotoTexTButton)
        private var clipping:TextClipping? = null
        private var listener: IViewHolderClicks? = null
        fun bind(
            clipping: TextClipping,
            listener: IViewHolderClicks?,
            context: Context
        ) {
            this.clipping = clipping
            this.listener = listener

            clippingTitleTextView.text = "${clipping.chapter?.title}. ${clipping.episode?.episodeNumber} ${clipping.episode?.title}"
            clippingTextView.text = clipping.text
            deleteButton.isEnabled = true
            gotoTextButton.isEnabled = true

            deleteButton.setOnClickListener {
                deleteButton.isEnabled = false
                listener?.onDelete(clipping)

            }

            gotoTextButton.setOnClickListener {
                gotoTextButton.isEnabled = false
                listener?.onClick(clipping)

            }

            itemView.setOnClickListener{
                listener?.onClick(clipping)
            }

        }


        interface IViewHolderClicks {
            fun onClick(clipping: TextClipping?)
            fun onDelete(clipping: TextClipping?)
        }

    }

}