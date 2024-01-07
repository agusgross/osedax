package com.blkpos.osedax.di

import android.app.Application
import android.content.SharedPreferences
import androidx.navigation.Navigator
import androidx.preference.PreferenceManager
import com.blkpos.osedax.network.SimpleCallAdapterFactory
import com.blkpos.osedax.network.TokenAuthenticator
import dagger.Module
import dagger.Provides
import javax.inject.Singleton
import com.google.gson.*
import okhttp3.Cache
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Named

@Module
class NetModule constructor(private val application: Application, private val mBaseUrl: String, private val mBaseUrlPictures: String, private val clientId: String, private val clientSecret: String) {

    companion object {
        const val DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'O'"
    }

    @Provides
    @Singleton
    fun provideSharedPreferences(): SharedPreferences {

        return PreferenceManager.getDefaultSharedPreferences(application)
    }

    @Provides
    @Singleton
    fun provideGson(): Gson {
        val gsonBuilder: GsonBuilder = GsonBuilder()
            .setExclusionStrategies(object : ExclusionStrategy {
                override fun shouldSkipField(f: FieldAttributes): Boolean {
//                    return f.getAnnotation(Exclude::class.java) != null
                    return false
                }

                override fun shouldSkipClass(clazz: Class<*>?): Boolean {
                    return false
                }
            })
            .setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
            .setDateFormat(DATE_FORMAT)
            .excludeFieldsWithoutExposeAnnotation()
        return gsonBuilder.create()
    }
//    @Provides
//    @NetworkLibraryScope
//    fun provideOkHttpCache(application: Application): Cache {
//        val cacheSize = 10 * 1024 * 1024 // 10 MiB
//        return Cache(application.cacheDir, cacheSize.toLong())
//    }

    @Provides
    @Singleton
    fun provideOkHttpClient(preferences: SharedPreferences): OkHttpClient {

        val interceptor = HttpLoggingInterceptor()
        interceptor.level = HttpLoggingInterceptor.Level.BODY

        val client = OkHttpClient.Builder().addInterceptor(interceptor).authenticator(
            TokenAuthenticator(
                preferences,
                mBaseUrl,
                clientId,
                clientSecret
            )
        )

//        client.setCache(cache);


//
.build()

        return client


    }

    @Provides
    @Singleton
    fun provideRetrofit(gson: Gson, okHttpClient: OkHttpClient): Retrofit {

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(gson))
            .baseUrl(mBaseUrl)
            .addCallAdapterFactory(SimpleCallAdapterFactory.create())
            .client(okHttpClient)
            .build()

    }
    @Provides
    @Named("Pictures")
    @Singleton
    fun provideRetrofitPictures(gson: Gson, okHttpClient: OkHttpClient): Retrofit {

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create(gson))
            .baseUrl(mBaseUrlPictures)
            .addCallAdapterFactory(SimpleCallAdapterFactory.create())
            .client(okHttpClient)
            .build()

    }
}

@Retention(AnnotationRetention.RUNTIME)
@Target(AnnotationTarget.FIELD)
annotation class Exclude
