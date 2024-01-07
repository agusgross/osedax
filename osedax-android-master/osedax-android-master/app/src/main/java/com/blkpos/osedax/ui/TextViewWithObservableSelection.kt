package com.blkpos.osedax.ui

import android.content.Context
import android.graphics.Canvas
import android.util.AttributeSet
import android.view.ViewGroup
import android.widget.TextView
import java.util.*
import kotlin.collections.ArrayList


class TextViewWithObservableSelection @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
    defStyleRes: Int = 0
) : androidx.appcompat.widget.AppCompatTextView(
    context,
    attrs,
    defStyleAttr
) {


    //Hair space character that will fill the space among spaces.
    private val HAIR_SPACE = "\u200A"

    //Normal space character that will take place between words.
    private val NORMAL_SPACE = " "

    //TextView's width.
    private var viewWidth = 0

    //Justified sentences in TextView's text.
    private val sentences: ArrayList<String> = ArrayList()

    //Sentence being justified.
    private val currentSentence: ArrayList<String> = ArrayList()

    //Sentence filled with spaces.
    private val sentenceWithSpaces: ArrayList<String> = ArrayList()

    //String that will storage the text with the inserted spaces.
    private var justifiedText: String? = ""

    //Object that generates random numbers, this is part of the justification algorithm.
    private val random: Random = Random()

    private var startIndex: Int = 0
    private var endIndex: Int = 0
    private var selectedText: String = ""
        set(value) {
            if (field != value) {
                field = value
                observer?.invoke(this, value, startIndex, endIndex)
            }
        }

    private var observer: ((TextView, String, Int, Int) -> Unit)? = null
        set(value) {
            field = value
            field?.invoke(this, selectedText, startIndex, endIndex)
        }

    override fun onSelectionChanged(selStart: Int, selEnd: Int) {
        super.onSelectionChanged(selStart, selEnd)
        startIndex = minOf(selStart, selEnd)
        endIndex = maxOf(selStart, selEnd)
        selectedText = text.toString().substring(startIndex, endIndex)
    }

    fun observeSelectedText(observer: ((TextView, String, Int, Int) -> Unit)?) {
        this.observer = observer
    }

    override fun onDraw(canvas: Canvas?) {
        //This class won't repeat the process of justify text if it's already done.
        if (justifiedText != text.toString()) {
            val params = layoutParams
            val text = text.toString()
            viewWidth = measuredWidth - (paddingLeft + paddingRight)

            //This class won't justify the text if the TextView has wrap_content as width
            //and won't justify the text if the view width is 0
            //AND! won't justify the text if it's empty.
            if (params.width != ViewGroup.LayoutParams.WRAP_CONTENT && viewWidth > 0 && !text.isEmpty()) {
                justifiedText = getJustifiedText(text)
                if (justifiedText?.isEmpty() != true) {
                    setText(justifiedText)
                    sentences.clear()
                    currentSentence.clear()
                }
            } else {
                super.onDraw(canvas)
            }
        } else {
            super.onDraw(canvas)
        }
    }

    /**
     * Retrieves a String with appropriate spaces to justify the text in the TextView.
     *
     * @param text Text to be justified
     * @return Justified text
     */
    private fun getJustifiedText(text: String): String? {
        val words = text.split(NORMAL_SPACE.toRegex()).toTypedArray()
        for (word in words) {
            val containsNewLine = word.contains("\n") || word.contains("\r")
            if (fitsInSentence(word, currentSentence, true)) {
                addWord(word, containsNewLine)
            } else {
                sentences.add(fillSentenceWithSpaces(currentSentence))
                currentSentence.clear()
                addWord(word, containsNewLine)
            }
        }

        //Making sure we add the last sentence if needed.
        if (currentSentence.size > 0) {
            sentences.add(getSentenceFromList(currentSentence, true))
        }

        //Returns the justified text.
        return getSentenceFromList(sentences, false)
    }

    /**
     * Adds a word into sentence and starts a new one if "new line" is part of the string.
     *
     * @param word            Word to be added
     * @param containsNewLine Specifies if the string contains a new line
     */
    private fun addWord(word: String, containsNewLine: Boolean) {
        currentSentence.add(word)
        if (containsNewLine) {
            sentences.add(getSentenceFromListCheckingNewLines(currentSentence))
            currentSentence.clear()
        }
    }

    /**
     * Creates a string using the words in the list and adds spaces between words if required.
     *
     * @param strings   Strings to be merged into one
     * @param addSpaces Specifies if the method should add spaces between words.
     * @return Returns a sentence using the words in the list.
     */
    private fun getSentenceFromList(strings: List<String>, addSpaces: Boolean): String {
        val stringBuilder = StringBuilder()
        for (string in strings) {
            stringBuilder.append(string)
            if (addSpaces) {
                stringBuilder.append(NORMAL_SPACE)
            }
        }
        return stringBuilder.toString()
    }

    /**
     * Creates a string using the words in the list and adds spaces between words taking new lines
     * in consideration.
     *
     * @param strings Strings to be merged into one
     * @return Returns a sentence using the words in the list.
     */
    private fun getSentenceFromListCheckingNewLines(strings: List<String>): String {
        val stringBuilder = StringBuilder()
        for (string in strings) {
            stringBuilder.append(string)

            //We don't want to add a space next to the word if this one contains a new line character
            if (!string.contains("\n") && !string.contains("\r")) {
                stringBuilder.append(NORMAL_SPACE)
            }
        }
        return stringBuilder.toString()
    }

    /**
     * Fills sentence with appropriate amount of spaces.
     *
     * @param sentence Sentence we'll use to build the sentence with additional spaces
     * @return String with spaces.
     */
    private fun fillSentenceWithSpaces(sentence: List<String>): String {
        sentenceWithSpaces.clear()

        //We don't need to do this process if the sentence received is a single word.
        if (sentence.size > 1) {
            //We fill with normal spaces first, we can do this with confidence because "fitsInSentence"
            //already takes these spaces into account.
            for (word in sentence) {
                sentenceWithSpaces.add(word)
                sentenceWithSpaces.add(NORMAL_SPACE)
            }

            //Filling sentence with thin spaces.
            while (fitsInSentence(HAIR_SPACE, sentenceWithSpaces, false)) {
                //We remove 2 from the sentence size because we need to make sure we are not adding
                //spaces to the end of the line.
                sentenceWithSpaces.add(getRandomNumber(sentenceWithSpaces.size - 2), HAIR_SPACE)
            }
        }
        return getSentenceFromList(sentenceWithSpaces, false)
    }

    /**
     * Verifies if word to be added will fit into the sentence
     *
     * @param word      Word to be added
     * @param sentence  Sentence that will receive the new word
     * @param addSpaces Specifies weather we should add spaces to validation or not
     * @return True if word fits, false otherwise.
     */
    private fun fitsInSentence(word: String, sentence: List<String>, addSpaces: Boolean): Boolean {
        var stringSentence = getSentenceFromList(sentence, addSpaces)
        stringSentence += word
        val sentenceWidth = paint.measureText(stringSentence)
        return sentenceWidth < viewWidth
    }

    /**
     * Returns a random number, it's part of the algorithm... don't blame me.
     *
     * @param max Max number in range
     * @return Random number.
     */
    private fun getRandomNumber(max: Int): Int {
        //We add 1 to the result because we wanna prevent the logic from adding
        //spaces at the beginning of the sentence.
        return random.nextInt(max) + 1
    }
}