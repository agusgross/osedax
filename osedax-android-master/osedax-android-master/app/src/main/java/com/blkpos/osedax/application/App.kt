package com.blkpos.osedax.application

import android.app.Application
import com.blkpos.osedax.R
import com.blkpos.osedax.config.Config
import com.blkpos.osedax.di.*
import com.blkpos.osedax.store.MyMigration
import io.github.inflationx.calligraphy3.CalligraphyConfig
import io.github.inflationx.calligraphy3.CalligraphyInterceptor
import io.github.inflationx.viewpump.ViewPump
import io.realm.Realm
import io.realm.RealmConfiguration
import java.util.*


class App: Application () {

    companion object{
        const val PROPERTIES_FILE_NAME = "Config.properties"
        const val BASE_URL = "BaseUrl"
        const val BASE_URL_PICTURES = "ImagesUrl"
        const val CLIENT_ID = "ClientId"
        const val CLIENT_SECRET = "ClientSecret"
    }


    public lateinit var appComponent: ApplicationComponent

//    public lateinit var appComponent: ApplicationComponent

    override fun onCreate() {
        super.onCreate()

        ViewPump.init(
            ViewPump.builder()
                .addInterceptor(
                    CalligraphyInterceptor(
                        CalligraphyConfig.Builder()
                            .setDefaultFontPath("fonts/Helvetica65Medium_22443.ttf")
                            .setFontAttrId(R.attr.fontPath)
                            .build()
                    )
                )
                .build()
        )
        val baseProperties: Properties = Config(applicationContext).getProperties(PROPERTIES_FILE_NAME)

        appComponent = DaggerApplicationComponent
            .builder()
            .userModule(UserModule(this))
            .netModule(NetModule(this,baseProperties.getProperty(BASE_URL), baseProperties.getProperty(BASE_URL_PICTURES), baseProperties.getProperty(CLIENT_ID) , baseProperties.getProperty(CLIENT_SECRET)))
            .persistenceModule(PersistenceModule(this))
            .build()
    }


}