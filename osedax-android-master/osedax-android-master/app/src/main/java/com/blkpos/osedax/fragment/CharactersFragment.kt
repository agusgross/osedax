package com.blkpos.osedax.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.motion.widget.MotionLayout
import androidx.fragment.app.Fragment
import androidx.viewpager2.widget.ViewPager2
import com.blkpos.osedax.R
import com.blkpos.osedax.adapter.CharacterSlidePagerAdapter
import com.blkpos.osedax.application.App
import com.blkpos.osedax.event.EpisodeLoadedEvent
import com.blkpos.osedax.event.ReloadBookmarkEvent
import com.blkpos.osedax.model.CharacterSelect
import com.blkpos.osedax.network.RestApi
import com.blkpos.osedax.store.ChapterStore
import kotlinx.android.synthetic.main.fragment_characters.*
import kotlinx.android.synthetic.main.fragment_read.viewPager
import org.greenrobot.eventbus.EventBus
import retrofit2.Retrofit
import javax.inject.Inject

class CharactersFragment : Fragment() {

    var pagerAdapter: CharacterSlidePagerAdapter? = null

    var characterSet = 0
    var displayOnly = false
    var chapterId = 0
    var episodeId = 0

    @Inject
    lateinit var chapterStore: ChapterStore

    @Inject
    lateinit var retrofit: Retrofit

//    private var mInterstitialAd: InterstitialAd? = null

    companion object {

        private const val ARGUMENT_CHAPTER_ID = "ARGUMENT_CHAPTER_ID"
        private const val ARGUMENT_EPISODE_ID = "ARGUMENT_EPISODE_ID"
        private const val ARGUMENT_CHARACTER_SET = "ARGUMENT_CHARACTER_SET"
        private const val ARGUMENT_DISPLAY_ONLY = "ARGUMENT_DISPLAY_ONLY"

        fun newInstance(chapterId: Int, episodeId: Int, set: Int, displayOnly: Boolean = false): CharactersFragment {
            val f = CharactersFragment()

            val args = Bundle()

            args.putInt(ARGUMENT_CHAPTER_ID, chapterId)
            args.putInt(ARGUMENT_EPISODE_ID, episodeId)
            args.putInt(ARGUMENT_CHARACTER_SET, set)
            args.putBoolean(ARGUMENT_DISPLAY_ONLY, displayOnly)

            f.arguments = args
            return f
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (arguments != null) {
            this.chapterId = requireArguments().getInt(CharactersFragment.ARGUMENT_CHAPTER_ID)
            this.episodeId = requireArguments().getInt(CharactersFragment.ARGUMENT_EPISODE_ID)
            this.characterSet = requireArguments().getInt(CharactersFragment.ARGUMENT_CHARACTER_SET) ?: this.characterSet
            this.displayOnly = requireArguments().getBoolean(CharactersFragment.ARGUMENT_DISPLAY_ONLY) ?: false
        }

        (activity?.applicationContext as App).appComponent.inject(this)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_characters, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setupUI(view)
    }

    private fun setupUI(view: View){

        val currentChapter = chapterStore.chapter(chapterId)
        val currentEpisode = chapterStore.episode(chapterId, episodeId)

        // broadcast episode navigation (for main menu selection)
        EventBus.getDefault().post(EpisodeLoadedEvent(chapterId, episodeId))


        val characters1 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterOneOptionA)
                add(currentChapter.characterOneOptionB)
            }
        }

        val characters2 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterTwoOptionA)
                add(currentChapter.characterTwoOptionB)
            }
        }

        val characters3 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterThreeOptionA)
                add(currentChapter.characterThreeOptionB)
            }
        }

        val characters4 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterFourOptionA)
                add(currentChapter.characterFourOptionB)
            }
        }

        val characters5 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterFiveOptionA)
                add(currentChapter.characterFiveOptionB)
            }
        }

        val characters6 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterSixOptionA)
                add(currentChapter.characterSixOptionB)
            }
        }

        val characters7 = object: ArrayList<String>(){
            init {
                add(currentChapter.characterSevenOptionA)
                add(currentChapter.characterSevenOptionB)
            }
        }

        var characters = when (characterSet ){
            6 -> characters7
            5 -> characters6
            4 -> characters5
            3 -> characters4
            2 -> characters3
            1 -> characters2
            else -> characters1
        }

        when (characterSet){
            6 -> characterTextView.text = currentChapter.characterSevenName
            5 -> characterTextView.text = currentChapter.characterSixName
            4 -> characterTextView.text = currentChapter.characterFiveName
            3 -> characterTextView.text = currentChapter.characterFourName
            2 -> characterTextView.text = currentChapter.characterThreeName
            1 -> characterTextView.text = currentChapter.characterTwoName
            else -> characterTextView.text = currentChapter.characterOneName
        }

        if (characterSet > 0){
            backButton.visibility = View.VISIBLE
        }

        currentCharacterSelect = chapterStore.characterSelection(characterTextView?.text.toString())


        if(!displayOnly && currentCharacterSelect == null) {

            currentCharacterSelect = CharacterSelect( characterTextView?.text.toString(),  0)
            characterSelect = currentCharacterSelect
            saveCharacterSelect(characterSelect!!)
            chapterStore.saveCharacterSelection(characterSelect!!)
        }


        pagerAdapter = CharacterSlidePagerAdapter(requireActivity(), characters)
        viewPager?.adapter = pagerAdapter
        viewPager.isUserInputEnabled = false
        viewPager.registerOnPageChangeCallback(onPageChangeCallback)
        viewPager.isUserInputEnabled = true


            if ( viewPager != null ) viewPager.setCurrentItem(500, false)



        leftButton.setOnClickListener {

            var nextItem = viewPager.currentItem-1

            if ( nextItem < 0)
                nextItem = (pagerAdapter?.itemCount ?: 0 )-1

            viewPager.currentItem = nextItem


        }

        rightButton.setOnClickListener {

            var nextItem = viewPager.currentItem+1
            if ( nextItem > (pagerAdapter?.itemCount ?: 0) -1 )
                nextItem = 0

            viewPager.currentItem = nextItem


        }

        backButton.setOnClickListener {

            when(characterSet){
                6 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterSixName)
                    chapterStore.removeCharacterSelection(currentChapter.characterSevenName)
                }
                5 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterFiveName)
                    chapterStore.removeCharacterSelection(currentChapter.characterSixName)
                }
                4 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterFourName)
                    chapterStore.removeCharacterSelection(currentChapter.characterFiveName)
                }
                3 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterThreeName)
                    chapterStore.removeCharacterSelection(currentChapter.characterFourName)
                }
                2 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterTwoName)
                    chapterStore.removeCharacterSelection(currentChapter.characterThreeName)
                }
                1 -> {
                    chapterStore.removeCharacterSelection(currentChapter.characterOneName)
                    chapterStore.removeCharacterSelection(currentChapter.characterTwoName)
                }
                else -> {}
            }

            EventBus.getDefault().post(ReloadBookmarkEvent(currentChapter.id, currentEpisode.id))


        }

        selectCharacterButton.setOnClickListener {
            currentCharacterSelect = characterSelect
            saveCharacterSelect(characterSelect!!)
            chapterStore.saveCharacterSelection(characterSelect!!)

            setCharacterSelectButtonState(true)



        }

        Handler(Looper.getMainLooper()).postDelayed({

            val al = view.findViewById<MotionLayout>(R.id.arrowLayout)

            al.progress = 0f
            al.transitionToEnd()


        }, 2000)



        arrowLayout.setTransitionListener(object : MotionLayout.TransitionListener {
            override fun onTransitionTrigger(
                p0: MotionLayout?,
                p1: Int,
                p2: Boolean,
                p3: Float
            ) {

            }

            override fun onTransitionStarted(p0: MotionLayout?, p1: Int, p2: Int) {

            }

            override fun onTransitionChange(p0: MotionLayout?, p1: Int, p2: Int, p3: Float) {

            }

            override fun onTransitionCompleted(p0: MotionLayout?, p1: Int) {
                arrowLayout.progress = 0f
                arrowLayout.transitionToEnd()
            }


        })

        /* interstitial ad */
//        if(!currentChapter.purchased && characterSet == 0 && currentCharacterSelect == null){
//            val adRequest = AdRequest.Builder().build()
//            InterstitialAd.load(
//                requireActivity(),
//                "ca-app-pub-4084713068647778/7944023024",
//                adRequest,
//                object : InterstitialAdLoadCallback() {
//                    override fun onAdFailedToLoad(adError: LoadAdError) {
//                        mInterstitialAd = null
//                    }
//
//                    override fun onAdLoaded(interstitialAd: InterstitialAd) {
//                        mInterstitialAd = interstitialAd
//
//                        mInterstitialAd?.show(requireActivity())
//
//                    }
//                })
//        }


    }

    var currentCharacterSelect: CharacterSelect? = null
    var characterSelect: CharacterSelect? = null
    private val onPageChangeCallback: ViewPager2.OnPageChangeCallback = object: ViewPager2.OnPageChangeCallback() {


        override fun onPageSelected(position: Int) {
            super.onPageSelected(position)

            requireActivity().runOnUiThread {
                if(!displayOnly) {

                    characterSelect = CharacterSelect(characterTextView.text.toString(), if (position % 2 == 0) 0 else 1)

//                    saveCharacterSelect(characterSelect)
//                    chapterStore.saveCharacterSelection(characterSelect)

                    setCharacterSelectButtonState(currentCharacterSelect?.option == characterSelect?.option)

                }
            }

        }

    }

    private fun saveCharacterSelect(characterSelect: CharacterSelect){
        retrofit.create(RestApi::class.java).characterSelect(characterSelect)?.process { _, _ ->  }
    }

    private fun setCharacterSelectButtonState(active: Boolean){
//        val dr = ResourcesCompat.getDrawable(resources, if(active) R.drawable.ic_check_on else R.drawable.ic_check, null)

//        val wdr = DrawableCompat.wrap(dr!!)
//        DrawableCompat.setTint(wdr, ResourcesCompat.getColor(resources, if(active) android.R.color.black else android.R.color.darker_gray, null))

//        dr?.setColorFilter(ResourcesCompat.getColor(resources, if(active) android.R.color.black else android.R.color.darker_gray, null), PorterDuff.Mode.SRC_ATOP)
//        selectCharacterButton.setCompoundDrawables(dr, null, null, null)
        selectCharacterButton.setCompoundDrawablesWithIntrinsicBounds(if(active) R.drawable.ic_check_on else R.drawable.ic_check_off, 0, 0, 0)

    }


}
