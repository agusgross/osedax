package com.blkpos.osedax.di

import com.blkpos.osedax.activity.ClippingsActivity
import com.blkpos.osedax.activity.MainActivity
import com.blkpos.osedax.fragment.BaseFragment
import com.blkpos.osedax.fragment.CharacterFragment
import com.blkpos.osedax.fragment.CharactersFragment
import com.blkpos.osedax.fragment.WelcomeFragment
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component(modules = [NetModule::class, UserModule::class, PersistenceModule::class])
interface ApplicationComponent {
    fun inject(fragment: BaseFragment)
    fun inject(fragment: WelcomeFragment)
    fun inject(activity: MainActivity)
    fun inject(fragment: CharactersFragment)
    fun inject(fragment: CharacterFragment)
}