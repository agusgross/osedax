package com.blkpos.osedax.di

import android.content.Context
import android.util.Log
import com.blkpos.osedax.store.ChapterStore
import com.blkpos.osedax.store.MyMigration
import dagger.Module
import dagger.Provides
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.exceptions.RealmMigrationNeededException
import javax.inject.Singleton

@Module
class PersistenceModule(var context: Context) {
    @Provides
    @Singleton
    fun providesRealm(): Realm {

        /* Realm Database */
        Realm.init(context)
//        val config = RealmConfiguration.Builder()
//            .schemaVersion(2) // Must be bumped when the schema changes
//            .migration(MyMigration()) // Migration to run instead of throwing an exception
//            .build()

        val config = RealmConfiguration.Builder()
            .schemaVersion(2)
            .deleteRealmIfMigrationNeeded()
            .build()

        val realm = try {
            Realm.getInstance(config)
        } catch(e: RealmMigrationNeededException) {
            Realm.deleteRealm(config)
            Realm.getInstance(config)
        }
        Log.d("GGR", "Path to realm file: " + realm.path)
        return realm
    }

    @Provides
    @Singleton
    fun providesChapterStore(realm: Realm): ChapterStore {
        return ChapterStore(realm)
    }

}
