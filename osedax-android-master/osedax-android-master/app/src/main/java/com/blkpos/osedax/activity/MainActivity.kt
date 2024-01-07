package com.blkpos.osedax.activity

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.res.ResourcesCompat
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout.DrawerListener
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.blkpos.osedax.R
import com.blkpos.osedax.application.App
import com.blkpos.osedax.event.EpisodeLoadedEvent
import com.blkpos.osedax.event.ReloadBookmarkEvent
import com.blkpos.osedax.extension.currentNavigationFragment
import com.blkpos.osedax.iface.BackableFragment
import com.blkpos.osedax.store.ChapterStore
import com.google.android.gms.ads.MobileAds
import com.google.android.material.navigation.NavigationView
import io.github.inflationx.viewpump.ViewPumpContextWrapper
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.fragment_read.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import javax.inject.Inject


class MainActivity : AppCompatActivity() {

    @Inject
    lateinit var chapterStore: ChapterStore

    private var isHomeAsUp = false

//    private var episodesLayout: LinearLayout? = null
    private var chapterTitles = ArrayList<RelativeLayout>()
    private var episodeTitles = ArrayList<Button>()

    private lateinit var appBarConfiguration: AppBarConfiguration

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        (applicationContext as App).appComponent.inject(this)

        supportActionBar?.setTitle("")
        supportActionBar?.setDisplayHomeAsUpEnabled(false)

//        supportActionBar?.setHomeButtonEnabled(false)


        val navController = findNavController(R.id.nav_host_fragment)

        appBarConfiguration = AppBarConfiguration(navController.graph, drawerLayout)
//
        setupActionBarWithNavController(navController, appBarConfiguration)
//
            findViewById<NavigationView>(R.id.nav_view)
                .setupWithNavController(navController)

//        val drawerToggle = ActionBarDrawerToggle(this, drawerLayout, null,  R.drawable.asl_drawer)
//        val drawerToggle = ActionBarDrawerToggle(this, drawerLayout, R.string.nav_app_bar_open_drawer_description, R.string.navigation_drawer_close)
//
//
//        drawerToggle.isDrawerIndicatorEnabled = true;
//        drawerLayout.addDrawerListener(drawerToggle)
//        supportActionBar?.setDisplayHomeAsUpEnabled(true)
//        supportActionBar?.setHomeButtonEnabled(true)
//        drawerToggle.syncState()
        drawerLayout.setScrimColor(ResourcesCompat.getColor(resources, android.R.color.transparent, null))
        drawerLayout.drawerElevation = 0.0f

        drawerLayout.addDrawerListener(object : DrawerListener {
            override fun onDrawerSlide(drawerView: View, v: Float) {}
            override fun onDrawerOpened(drawerView: View) {
                if ( drawerLayout.isDrawerOpen(GravityCompat.START) ) {
                    drawerToggleButton.isChecked = true
                    motionLayout.progress = 0.0f
                    motionLayout.transitionToEnd()
                }
                if ( drawerLayout.isDrawerOpen(GravityCompat.END) ) {
                    drawerEndToggleButton.isChecked = true
                    rightMotionLayout.progress = 0.0f
                    rightMotionLayout.transitionToEnd()
                }

            }
            override fun onDrawerClosed(drawerView: View) {
                if ( !drawerLayout.isDrawerOpen(GravityCompat.START)) {
                    drawerToggleButton.isChecked = false
                    motionLayout.progress = 1.0f
                    motionLayout.transitionToStart()
                }
                if ( !drawerLayout.isDrawerOpen(GravityCompat.END)) {
                    drawerEndToggleButton.isChecked = false
                    rightMotionLayout.progress = 1.0f
                    rightMotionLayout.transitionToStart()
                }

            }
            override fun onDrawerStateChanged(i: Int) {}
        })

//        for( i in 0 until toolbar.childCount){
//
//            if ( toolbar.getChildAt(i) is ImageButton ){
//
//                var imageButton = toolbar.getChildAt(i) as ImageButton
//
//                if ( imageButton?.drawable is DrawerArrowDrawable ) {
//                    imageButton.setImageDrawable(getDrawable(R.drawable.asl_drawer))
//                }
//
//            }
//
//
//
//        }



//        drawerToggle.drawerArrowDrawable = getDrawable(R.drawable.asl_drawer)
//        drawerToggle.toolbarNavigationClickListener

        toolbar.navigationIcon = null

//        supportActionBar?.setHomeAsUpIndicator(R.drawable.ic_drawer_closed)

//        toolbar.setNavigationOnClickListener {
//            when {
//                drawerLayout.isDrawerOpen(GravityCompat.START) -> {
//                    drawerLayout.closeDrawer(GravityCompat.START)
//                }
//                isHomeAsUp -> {
//                    onBackPressed()
//                }
//                else -> {
//                    drawerLayout.openDrawer(GravityCompat.START)
//                }
//            }
//        }

        drawerToggleButton.buttonTintList = null
        drawerEndToggleButton.buttonTintList = null

        drawerToggleButton.setOnClickListener{

            if ( drawerLayout.isDrawerOpen(GravityCompat.START))
                drawerLayout.closeDrawer(GravityCompat.START, false)
            else {
                drawerLayout.openDrawer(GravityCompat.START, false)
                if ( drawerLayout.isDrawerOpen(GravityCompat.END)) drawerLayout.closeDrawer(GravityCompat.END, false)
            }
        }

        drawerEndToggleButton.setOnClickListener{

            if ( drawerLayout.isDrawerOpen(GravityCompat.END))
                drawerLayout.closeDrawer(GravityCompat.END, false)
            else {
                drawerLayout.openDrawer(GravityCompat.END, false)
                if ( drawerLayout.isDrawerOpen(GravityCompat.START)) drawerLayout.closeDrawer(GravityCompat.START, false)

            }
        }

        setupUI()

        MobileAds.initialize(
            this
        ) { }


    }

    private fun setupUI() {


        displayChaptersMenu()

        accountButton.setOnClickListener {

            val intent = Intent(this, ProfileActivity::class.java)
            startActivity(intent)

            drawerLayout.closeDrawer(GravityCompat.END)


        }

        clippingsButton.setOnClickListener {

            val intent = Intent(this, ClippingsActivity::class.java)

            startActivityForResult(intent, ClippingsActivity.REQUEST_CODE_CLIPPING)

            drawerLayout.closeDrawer(GravityCompat.END)


        }

        purchasesButton.setOnClickListener {
            val intent = Intent(this, PurchasesActivity::class.java)
            startActivity(intent)

            drawerLayout.closeDrawer(GravityCompat.END)
        }

        charactersButton.setOnClickListener OnClick@{

            drawerLayout.closeDrawer(GravityCompat.END)

            val chapter = chapterStore.bookmark?.chapter ?: return@OnClick
            val episode = chapterStore.bookmark?.episode ?: return@OnClick

            if ( chapter.characterOneName.isNotEmpty() && episode.isFirstCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterOneName)
            }

            if ( chapter.characterTwoName.isNotEmpty() && episode.isSecondCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterTwoName)
            }

            if ( chapter.characterThreeName.isNotEmpty() && episode.isThirdCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterThreeName)
            }

            if ( chapter.characterFourName.isNotEmpty() && episode.isFourthCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterFourName)
            }

            if ( chapter.characterFiveName.isNotEmpty() && episode.isFifthCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterFiveName)
            }

            if ( chapter.characterSixName.isNotEmpty() && episode.isSixthCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterSixName)
            }
            if ( chapter.characterSevenName.isNotEmpty() && episode.isSeventhCharacterPresent ) {
                chapterStore.removeCharacterSelection(chapter.characterSevenName)
            }

            EventBus.getDefault().post(ReloadBookmarkEvent(chapter.id, episode.id))



        }


    }

    fun chapterButtonClicked(view: View) {

        val button = view as Button

        for (i in 1..4) {
            val id = resources.getIdentifier("chapter_1_$i", "id", packageName)
            (findViewById<View>(id) as Button).setTextColor(ResourcesCompat.getColor(resources, android.R.color.white, null))
        }

        button.setTextColor(ResourcesCompat.getColor(resources, R.color.colorAccent, null))


    }


    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment)
        return navController.navigateUp(appBarConfiguration)
                || super.onSupportNavigateUp()
    }


    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
//        return when (item.itemId) {
//            R.id.action_settings -> true
//            else -> super.onOptionsItemSelected(item)
//        }
        return super.onOptionsItemSelected(item)

    }

    private fun displayChaptersMenu(){

        var first = false
        val chapters = chapterStore.chapters
        for (chapter in chapters!!) {

            val layout = chapterTitle(chapter.title.toLowerCase())
            if(layout != null) chapterTitles.add(layout)
            layout?.tag = chapter.id
            chaptersMenuLayout.addView(layout)
            val episodesLayout = episodeMenu()
            episodesLayout?.tag = "em${chapter.id}"

            var i = 1
            for(episode in chapter.episodes ) {
                val episodeTitle = episodeTitle(".${i} ${episode.title.toLowerCase()}", chapter.id, episode.id)
                if(episodeTitle != null) episodeTitles.add(episodeTitle)
                episodesLayout?.addView(episodeTitle)
                i++
            }

            chaptersMenuLayout.addView(episodesLayout)

            layout?.setOnClickListener{
                val isOpen = episodesLayout?.visibility == View.VISIBLE
                episodesLayout?.visibility = if ( isOpen) View.GONE else View.VISIBLE
                layout.background = ResourcesCompat.getDrawable(resources, if(isOpen)  R.drawable.background_cell_menu_chapter_title_closed else R.drawable.background_cell_menu_chapter_title_open, null)
                val button = layout.findViewById<ImageButton>(R.id.openButton)
                val title = layout.findViewById<TextView>(R.id.titleTextView)
                title.setTextColor(ResourcesCompat.getColor(resources, if(isOpen) android.R.color.white else android.R.color.black, null))
                button.setImageDrawable(getDrawable(if(isOpen) R.drawable.ic_open_menu_light else R.drawable.ic_close_menu))
            }

            if ( ! first ) {
                first = true
            } else {
//                episodesLayout?.visibility = View.GONE
                layout?.findViewById<ImageButton>(R.id.openButton)?.setImageDrawable(getDrawable(R.drawable.ic_open_menu))

            }


        }

    }


    private fun chapterTitle(description: String): RelativeLayout? {


        val layout = LayoutInflater.from(this).inflate(R.layout.cell_menu_chapter_title, null)
        layout.findViewById<TextView>(R.id.titleTextView).text = description

        return layout.findViewById<RelativeLayout>(R.id.titleLayout)


    }


    private fun episodeMenu(): LinearLayout? {


        return LayoutInflater.from(this).inflate(R.layout.cell_menu_episode, null).findViewById<LinearLayout>(R.id.episodesLayout)


    }
    private fun episodeTitle(description: String, chapterId: Int, episodeId: Int): Button? {


        val layout = LayoutInflater.from(this).inflate(R.layout.cell_menu_episode_title, null)
        val button = layout.findViewById<Button>(R.id.episodeButton)
        button.text = description
        button.setOnClickListener(onEpisodeButtonClicked)
        button.tag = "${chapterId}|${episodeId}"
        return button


    }

    override fun attachBaseContext(newBase: Context?) {
        if (newBase != null)
            super.attachBaseContext(ViewPumpContextWrapper.wrap(newBase));
        else
            super.attachBaseContext(newBase);
    }

    private val onEpisodeButtonClicked = View.OnClickListener OnClick@{

        drawerLayout.closeDrawer(GravityCompat.START)

        val chapterInfo = it.tag.toString().split("|")
        val chapterId = chapterInfo[0].toInt()
        var episodeId = chapterInfo[1].toInt()

        val chapter = chapterStore.chapter(chapterId)

//        val purchased = chapter.purchased
//
//        if(!purchased)
//            episodeId = chapter.episodes.first()?.id ?: return@OnClick

        EventBus.getDefault().post(ReloadBookmarkEvent(chapterId, episodeId))


    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        super.onActivityResult(requestCode, resultCode, data)

        supportFragmentManager.primaryNavigationFragment?.childFragmentManager?.fragments?.forEach { fragment ->
            fragment.onActivityResult(requestCode, resultCode, data)
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: EpisodeLoadedEvent?) {

        chapterTitles.forEach{
            val isOpen = event?.chapterId != it.tag
            chaptersMenuLayout.findViewWithTag<LinearLayout>("em${it.tag}")?.visibility = if ( isOpen) View.GONE else View.VISIBLE
            it.background = ResourcesCompat.getDrawable(resources, if(isOpen)  R.drawable.background_cell_menu_chapter_title_closed else R.drawable.background_cell_menu_chapter_title_open, null)
            val button = it.findViewById<ImageButton>(R.id.openButton)
            val title = it.findViewById<TextView>(R.id.titleTextView)
            title.setTextColor(ResourcesCompat.getColor(resources, if(isOpen) android.R.color.white else android.R.color.black, null))
            button.setImageDrawable(getDrawable(if(isOpen) R.drawable.ic_open_menu_light else R.drawable.ic_close_menu))
        }

        episodeTitles.forEach {
            it.setTextColor(ResourcesCompat.getColor(resources, android.R.color.white, null))
        }

        chaptersMenuLayout.findViewWithTag<Button>("${event?.chapterId}|${event?.episodeId}")?.setTextColor(ResourcesCompat.getColor(resources, R.color.colorAccent, null))



    }

    override fun onStart() {
        super.onStart()
        EventBus.getDefault().register(this);
    }

    override fun onStop() {
        super.onStop()
        EventBus.getDefault().unregister(this);
    }

    override fun onBackPressed() {

        val currentFragment = supportFragmentManager.currentNavigationFragment
        if (currentFragment is BackableFragment) {
            currentFragment.onBackPressed()
        } else
            super.onBackPressed()


    }


}
