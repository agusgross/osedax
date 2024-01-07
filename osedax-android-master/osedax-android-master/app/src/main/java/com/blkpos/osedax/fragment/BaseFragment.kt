package com.blkpos.osedax.fragment

import android.os.Bundle
import androidx.fragment.app.Fragment
import com.blkpos.osedax.application.App
import com.blkpos.osedax.config.Config
import com.blkpos.osedax.store.ChapterStore
import com.blkpos.osedax.store.UserStore
import io.realm.Realm
import retrofit2.Retrofit
import javax.inject.Inject

open class BaseFragment : Fragment() {

    @Inject
    lateinit var retrofit: Retrofit

    @Inject
    lateinit var config: Config

    @Inject
    lateinit var userStore: UserStore

    @Inject
    lateinit var realm: Realm

    @Inject
    lateinit var chapterStore: ChapterStore

    override fun onCreate(savedInstanceState: Bundle?) {

        (activity?.applicationContext as App).appComponent.inject(this)

        super.onCreate(savedInstanceState)
    }


}
