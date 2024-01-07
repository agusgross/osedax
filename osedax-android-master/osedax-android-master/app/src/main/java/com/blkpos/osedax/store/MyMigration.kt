package com.blkpos.osedax.store

import io.realm.DynamicRealm
import io.realm.RealmMigration

class MyMigration: RealmMigration {
    override fun migrate(realm: DynamicRealm, oldVersion: Long, newVersion: Long) {

        val schema = realm.schema

        var anOldVersion = oldVersion

        if(anOldVersion == 0L){

            if (schema.get("Chapter")?.fieldNames?.contains("characterFourOptionA") == false) {
                schema.get("Chapter")
                    ?.addField("characterFourOptionA", String::class.java)
                    ?.addField("characterFourOptionB", String::class.java)
                    ?.addField("characterFourName", String::class.java)

                schema.get("Episode")
                    ?.addField("isFourthCharacterPresent", Boolean::class.java)
            }

            if (schema.get("Chapter")?.fieldNames?.contains("characterFiveName") == false) {
                schema.get("Chapter")
                    ?.addField("characterFiveName", String::class.java)
            }

            anOldVersion++
        }

        if(anOldVersion == 1L){

            if (schema.get("Episode")?.fieldNames?.contains("textByCharacters") == false) {
                schema.get("Episode")
                    ?.addField("textByCharacters", String::class.java)
                    ?.addField("text2ByCharacters", String::class.java)

            }

        }


    }


}