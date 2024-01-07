package com.blkpos.osedax.adapter

import android.util.Log
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.blkpos.osedax.fragment.*
import com.blkpos.osedax.model.Chapter
import java.lang.IllegalArgumentException

class ReadSlidePagerAdapter(val firstSlide: Step, fa: FragmentActivity ): FragmentStateAdapter(fa) {

    var secondSlide: Step? = null

    sealed class Step {
        class StepIntro(val chapterId: Int, val episodeId: Int) : Step()
        class StepCharacterSelect(val chapterId: Int, val episodeId: Int, val characterSet: Int): Step()
        class StepRead(val chapterId: Int, val episodeId: Int): Step()
        class StepPurchase(val chapterId: Int, val episodeId: Int): Step()

    }

    override fun getItemCount(): Int {
        return  if( firstSlide is Step.StepRead && secondSlide == null) 1 else 2
    }

    override fun createFragment(position: Int): Fragment {

        return when (position){
            0 -> currentFragment(firstSlide)
            else -> nextFragment(secondSlide)
        }


    }

    private fun currentFragment(step: Step): Fragment{
        return when ( step ) {
            is Step.StepIntro -> IntroFragment.newInstance(step.chapterId, step.episodeId)
            is Step.StepCharacterSelect ->  CharactersFragment.newInstance(step.chapterId, step.episodeId, step.characterSet)
            is Step.StepRead -> TextFragment.newInstance(step.chapterId, step.episodeId)
            is Step.StepPurchase -> PurchaseChapterFragment.newInstance(step.chapterId, step.episodeId)

        }
    }

    private fun nextFragment(step: Step?): Fragment {


        return when (step){
            is Step.StepIntro -> IntroFragment.newInstance(step.chapterId,step.episodeId)
            is Step.StepCharacterSelect -> CharactersFragment.newInstance(step.chapterId, step.episodeId, step.characterSet, true)
            is Step.StepRead -> TextFragment.newInstance(step.chapterId, step.episodeId, true)
            is Step.StepPurchase -> PurchaseChapterFragment.newInstance(step.chapterId, step.episodeId)
            null -> throw IllegalArgumentException()
        }




    }


}