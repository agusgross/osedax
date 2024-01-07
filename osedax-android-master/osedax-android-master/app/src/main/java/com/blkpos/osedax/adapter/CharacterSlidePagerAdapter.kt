package com.blkpos.osedax.adapter

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.blkpos.osedax.fragment.CharacterFragment

class CharacterSlidePagerAdapter(fa: FragmentActivity, private val characters: ArrayList<String>): FragmentStateAdapter(fa) {

    override fun getItemCount(): Int {
//        return  characters.size
        return 1000

    }

    override fun createFragment(position: Int): Fragment {

        val currentPosition = if ( position % 2 == 0)  0 else 1
//        return CharacterFragment.newInstance(character = characters[position], position = position)
        return CharacterFragment.newInstance(character = characters[currentPosition], position = currentPosition)




    }

}