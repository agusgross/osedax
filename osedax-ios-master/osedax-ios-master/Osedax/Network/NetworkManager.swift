//
//  NetworkManager.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Moya
import Heimdallr

public class NetworkProvider {

    private let baseURL: URL
    private let imagesUrl: URL
    private let provider: MoyaDynamicProvider
    private let imagesProvider: MoyaDynamicProvider
    private lazy var providerAuth: MoyaDynamicProvider? = {
        
        MoyaDynamicProvider(baseURL: self.baseURL, requestClosure: { [weak self] endpoint, done in
            
            guard let self = self else { return }
            
            let request = try! endpoint.urlRequest() // This is the request Moya generates
            
            self.heimdallr.authenticateRequest(request) { result in
                switch result {
                case .success(let signedRequest):
                    
                    done(.success(signedRequest))
                    
                case .failure(let error):
                    print("failure: \(error.localizedDescription)")
                    done(.failure(MoyaError.encodableMapping(error)))
                }
            }

        //}, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]  )
            
        } )
    }()
    
    private let heimdallr: Heimdallr
    
    public init(baseURL: URL, imagesUrl: URL, heimdallr: Heimdallr){
    
        self.baseURL = baseURL
        self.imagesUrl = imagesUrl
        self.provider = MoyaDynamicProvider(baseURL: self.baseURL)
        self.imagesProvider = MoyaDynamicProvider(baseURL: self.imagesUrl)
        self.heimdallr = heimdallr
         
        
        
    }
    
    @discardableResult public func request<D: Decodable>(target: TargetType, responseClass: D.Type, completion: @escaping ( D?, Error? ) -> Void ) -> MyCancellable? {
    
        
        return MyCancellableWrapper(cancellable: provider.request(target) { result in
            
            switch result {
            case let .success(response):
                
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        
                        completion(try filteredResponse.map(responseClass.self), nil)
                        
                    } catch let error {
                        completion(nil, error)
                    }
                        
            case let .failure(error):
                
                completion(nil, error)
                
                
            }
                    
        })
                
        
        
    }
    
    @discardableResult
    public func authRequest<D: Decodable>(target: TargetType, responseClass: D.Type, completion: @escaping ( D?, Error? ) -> Void ) -> MyCancellable? {
    
        
        guard let providerAuth = providerAuth else { return nil }
        
        return MyCancellableWrapper(cancellable: providerAuth.request(target) { result in
            
            switch result {
            case let .success(response):
                
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        
                        completion(try filteredResponse.map(responseClass.self), nil)
                        
                    } catch let error {
                        completion(nil, error)
                    }
                        
            case let .failure(error):
                
                completion(nil, error)
                
                
            }
                    
        })
                
        
        
    }
    
    @discardableResult
    public func upload<D: Decodable>(target: TargetType, responseClass: D.Type, completion: @escaping ( D?, Error? ) -> Void)  {
        let _ = imagesProvider.request(target) { result in
            switch result {
            case let .success(response):
                
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        
                        completion(try filteredResponse.map(responseClass.self), nil)
                        
                    } catch let error {
                        completion(nil, error)
                    }
                        
            case let .failure(error):
                
                completion(nil, error)
                
                
            }
        }
    }
    
    public func login(username: String, password: String, completion: @escaping ( Error? ) -> Void ){
        
        heimdallr.requestAccessToken(username: username , password: password) { [weak self] result in
            switch result {
            case .success:

                completion(nil)
                
            case .failure(let error):
                
                completion(error)
                
            }
        }
    }
    
    public func loginFacebook(accessToken: String, completion: @escaping ( Error? ) -> Void  ) {
        
        heimdallr.requestAccessToken(grantType: "https://api.naipesnegros.com/facebook_access_token", parameters: ["facebook_access_token": accessToken] ) { result in

            switch result {
            case .success:
                
                completion(nil)
                

                
            case .failure(let error):
                
                
                completion(error)
                

                
                
            }
            
        }

    }
    
    
}
