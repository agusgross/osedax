package com.blkpos.osedax.di

import android.app.Application
import android.content.SharedPreferences
import androidx.preference.PreferenceManager
import com.blkpos.osedax.config.Config
import com.blkpos.osedax.network.SimpleCallAdapterFactory
import com.blkpos.osedax.network.TokenAuthenticator
import com.blkpos.osedax.store.UserStore
import com.google.gson.*
import dagger.Module
import dagger.Provides
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
class UserModule constructor(private val application: Application) {

    @Provides
    @Singleton
    fun provideUserStore(preferences: SharedPreferences): UserStore {

        return UserStore(preferences)
    }

    @Provides
    @Singleton
    fun provideConfig(): Config {

        return Config(application)
    }


}