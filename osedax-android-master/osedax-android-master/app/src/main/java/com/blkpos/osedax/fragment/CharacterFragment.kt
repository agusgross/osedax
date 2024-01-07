package com.blkpos.osedax.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.blkpos.osedax.R
import com.blkpos.osedax.application.App
import com.blkpos.osedax.config.Config
import com.blkpos.osedax.module.GlideApp
import com.bumptech.glide.load.engine.DiskCacheStrategy
import kotlinx.android.synthetic.main.fragment_character.*
import javax.inject.Inject

class CharacterFragment : Fragment() {

    @Inject
    lateinit var config: Config

    var character = "character_1_f"
    var position = 0

    companion object {

        private const val ARGUMENT_CHARACTER = "ARGUMENT_CHARACTER"

        fun newInstance(character: String, position: Int): CharacterFragment {
            val f = CharacterFragment()

            val args = Bundle()

            args.putString(ARGUMENT_CHARACTER, character)
            args.putInt("DDD", position)

            f.arguments = args
            return f
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (arguments != null) {
            this.character = requireArguments().getString(CharacterFragment.ARGUMENT_CHARACTER) ?: this.character
            this.position = requireArguments().getInt("DDD")
        }

        (activity?.applicationContext as App).appComponent.inject(this)
    }


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_character, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        GlideApp.with(requireContext()).load(config.imagesUrl() + character + ".webp").diskCacheStrategy(
            DiskCacheStrategy.DATA).into(imageView)
//        imageView.setImageDrawable(ResourcesCompat.getDrawable(resources, requireContext().resources.getIdentifier(character, "drawable", requireContext().packageName),null))
//        positionTextView.text = position.toString()



    }



}
