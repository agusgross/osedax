//
//  UserManager.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Heimdallr

public struct UserManager {

    private let networkProvider: NetworkProvider
    private let heimdallr: Heimdallr
    
    public init(networkProvider: NetworkProvider, tokenProvider: Heimdallr){
        
        self.networkProvider = networkProvider
        self.heimdallr = tokenProvider
        
    }
    
//    public func getUser(done: @escaping  (User?, Error?) -> Void ){
//        
//        
//        networkProvider.request(target: UserAccountService.user, responseClass: User.self) { user, error in
//            
//            done(user, error)
//            
//            
//        }
//    }
    
    public func register(user: User, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.request(target: UserAccountService.register(user: user), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }
    
    public func recover(email: String, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.request(target: UserAccountService.recover(email: email), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }

    public func editProfile(user: User, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.editProfile(user: user), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }
    

    
    public func getUser(done: @escaping  (User?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.user, responseClass: User.self) { user, error in
            
            done(user, error)
            
            
        }
    }

//    public func upload(data: Data, completion: @escaping (UploadFileResponse?, Error?) -> Void ){
//        
//        networkProvider.upload(target: UserAccountService.upload(data: data), responseClass: UploadFileResponse.self) { uploadFileResponse, error in
//            
//            completion(uploadFileResponse, error)
//        }
//    }

    public func login(username: String, password: String, completion: @escaping (Error?) -> Void ){
        
        networkProvider.login(username: username, password: password, completion: completion) 
    }
    
    public func isUserLoggedIn() -> Bool {
        
        return heimdallr.hasAccessToken
        
        
        
    }
    
    func chapters(language: String, version: String , done: @escaping  ([Chapter]?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.chapters(language: language, version: version), responseClass: [Chapter].self) { chapters, error in
            
            done(chapters, error)
            
            
        }
    }
    
    func characterSelect(characterSelect: CharacterSelect , done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.characterSelect(characterSelect: characterSelect), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }


    func initialize( done: @escaping  (InitResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.initialize, responseClass: InitResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }
    
    func saveTextClipping(textClipping: TextClipping, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.textClipping(textClipping: textClipping), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }

    func saveBookmark(bookmark: Bookmark, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.bookmark(bookmark: bookmark), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }
    
    func deleteTextClipping(textClippingId: Int, done: @escaping  (RestResponse?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.deleteTextClipping(clippingId: textClippingId), responseClass: RestResponse.self) { response, error in
            
            done(response, error)
            
            
        }
    }
    
    func purchase(language: String, sku: String , done: @escaping  (Chapter?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.purchase(language: language, sku: sku), responseClass: Chapter.self) { response, error in
            
            done(response, error)
            
            
        }
    }

    func chaptersAfter(language: String, chapterId: Int, version: String , done: @escaping  ([Chapter]?, Error?) -> Void ){
        
        
        networkProvider.authRequest(target: UserAccountService.chaptersAfter(language: language, chapterId: chapterId, version: version), responseClass: [Chapter].self) { chapters, error in
            
            done(chapters, error)
            
            
        }
    }

//    func getHealthEntities(done: @escaping  ([HealthEntity]?, Error?) -> Void ){
//
//
//        networkProvider.request(target: UserAccountService.healthEntities, responseClass: [HealthEntity].self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//    func call(call: Call, done: @escaping  (RestResponse?, Error?) -> Void ) -> MyCancellable? {
//
//
//        return networkProvider.authRequest(target: UserAccountService.call(call: call), responseClass: RestResponse.self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//    func cancel(callId: Int, done: @escaping  (RestResponse?, Error?) -> Void ){
//
//
//        networkProvider.authRequest(target: UserAccountService.cancel(callId: callId), responseClass: RestResponse.self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//    func activeCall(done: @escaping  (CallResponse?, Error?) -> Void ) -> MyCancellable? {
//
//
//        return networkProvider.authRequest(target: UserAccountService.activeCall, responseClass: CallResponse.self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//    func subscribeToken(callId: Int, done: @escaping  (RestResponse?, Error?) -> Void ) -> MyCancellable? {
//
//
//        return networkProvider.authRequest(target: UserAccountService.subscribeToken(callId: callId), responseClass: RestResponse.self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//    func registerToken(token: DeviceToken, done: @escaping  (RestResponse?, Error?) -> Void ) -> MyCancellable? {
//
//
//        return networkProvider.authRequest(target: UserAccountService.registerToken(token: token), responseClass: RestResponse.self) { response, error in
//
//            done(response, error)
//
//
//        }
//    }
//
//
//
//    public func loginFacebook(accessToken: String, completion: @escaping (Error?) -> Void ){
//
//        networkProvider.loginFacebook(accessToken: accessToken) { error  in
//            completion(error)
//        }
//
//
//    }
    
    public func removeAccessToken() {
        heimdallr.clearAccessToken()
    }
    
}
