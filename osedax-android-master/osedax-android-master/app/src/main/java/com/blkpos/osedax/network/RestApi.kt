package com.blkpos.osedax.network

import com.blkpos.osedax.model.*
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.*

interface RestApi {
    @POST("oauth/v2/token")
    @FormUrlEncoded
    @Headers("Cache-Control: no-cache")
    fun login(
        @Field("grant_type") grantType: String?,
        @Field("client_id") clientId: String?,
        @Field("client_secret") clientSecret: String?,
        @Field("username") username: String?,
        @Field("password") password: String?
    ): Simple<OauthResponse?>?
//
    @POST("oauth/v2/token")
    @FormUrlEncoded
    @Headers("Cache-Control: no-cache")
    fun refresh(
        @Field("grant_type") grantType: String?,
        @Field("client_id") clientId: String?,
        @Field("client_secret") clientSecret: String?,
        @Field("refresh_token") refreshToken: String?
    ): Call<OauthResponse?>?
//
    @GET("oauth/v2/token")
    @Headers("Cache-Control: no-cache")
    fun facebookLogin(
        @Query("grant_type") grantType: String?,
        @Query("client_id") clientId: String?,
        @Query("client_secret") clientSecret: String?,
        @Query("facebook_access_token") facebookAccessToken: String?
    ): Simple<OauthResponse?>?

    @GET("api/user/user.json")
    fun user(): Simple<User?>?

    @POST("api/registration.json")
    fun register(@Body user: User?): Simple<RestResponse?>?

    @POST("api/user/user.json")
    fun editProfile(@Body user: User?): Simple<RestResponse?>?

    @GET("api/recover.json")
    fun recover(@Query("email") email: String): Simple<RestResponse?>?

    @GET("api/user/chapters.json")
    fun chapters(@Query("lang") language: String, @Query("version") version: Int, @Query("full") full: String = "true"): Simple<ArrayList<Chapter>?>?

    @GET("api/user/init.json")
    fun init(): Simple<InitResponse>?

    @POST("api/user/purchase.json")
    fun purchase(@Query("lang") language: String, @Query("sku") sku: String): Simple<Chapter?>?

    @POST("api/user/text_clipping.json")
    fun textClipping(@Body textClipping: TextClipping): Simple<RestResponse?>?

    @DELETE("api/user/text_clipping_delete.json")
    fun deleteTextClipping(@Query("text_clipping_id") textClippingId: Int): Simple<RestResponse?>?

    @POST("api/user/character_select.json")
    fun characterSelect(@Body characterSelect: CharacterSelect): Simple<RestResponse?>?

    @POST("api/user/bookmark.json")
    fun bookmark(@Body bookmark: Bookmark): Simple<RestResponse?>?

    @GET("api/user/chapters_after.json")
    fun getChaptersAfter(@Query("lang") language: String, @Query("id") chapterId: Int, @Query("version") version: Int, @Query("full") full: String = "true"): Simple<ArrayList<Chapter>>

}