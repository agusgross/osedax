package com.blkpos.osedax.activity

import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.blkpos.osedax.R
import com.blkpos.osedax.application.App
import io.github.inflationx.viewpump.ViewPumpContextWrapper
import kotlinx.android.synthetic.main.activity_main.*


class ClippingsActivity : AppCompatActivity() {

    companion object {
        val REQUEST_CODE_CLIPPING = 1
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_clippings)
        setSupportActionBar(toolbar)

        supportActionBar?.setTitle("")
        supportActionBar?.setDisplayHomeAsUpEnabled(false)

//        supportActionBar?.setHomeButtonEnabled(false)



    }



    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(ViewPumpContextWrapper.wrap(newBase!!));
    }

}
