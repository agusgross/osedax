//
//  RestApi.swift
//  Naipes
//
//  Created by Gustavo Rago on 5/14/20.
//  Copyright © 2020 Gustavo Rago. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {

    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public enum Task {

    case requestPlain
    case requestParameters([String:Any])
    case requestJSONEncodable(Encodable)
    case multipartFormData(Data)

}

public protocol TargetType {

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

public struct MoyaDynamicTarget: Moya.TargetType {
    
    public let baseURL: URL
    public let target: TargetType

    public var path: String { return target.path }
    public var method: Moya.Method {
        
        switch target.method {
        case .get:
            return .get
        case .put:
            return .put
        case .post:
            return .post
        case .delete:
            return .delete
        default:
            return .get
            
        }
        
        
    }
    public var sampleData: Data { return target.sampleData }
    public var task: Moya.Task {
        
        switch target.task {
        case .requestPlain:
            return .requestPlain
        case .requestParameters(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .requestJSONEncodable(let encodable):
            return .requestJSONEncodable(encodable)
        case .multipartFormData(let data):
            return .uploadMultipart([MultipartFormData(provider: .data(data), name: "file", fileName: "image.png", mimeType: "image/png")])
        }

        
    }
    public var headers: [String : String]? { return target.headers }
}

public class MoyaDynamicProvider: MoyaProvider<MoyaDynamicTarget> {
    
    fileprivate let baseURL: URL
  
    public init(
        baseURL: URL,
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = { target in let defaultEndpoint = MoyaDynamicProvider.defaultEndpointMapping(for: target); return defaultEndpoint },
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.verbose, .successResponseBody, .errorResponseBody]))],
        trackInflights: Bool = false) {
        
        self.baseURL = baseURL
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)

    }
    
    public func request(_ target: TargetType, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        let dynamicTarget = MoyaDynamicTarget(baseURL: baseURL, target: target)
        return super.request(dynamicTarget, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}


public protocol MyCancellable {
    var isCancelled: Bool { get }
    func cancel()
}

internal class MyCancellableWrapper: MyCancellable {
    internal var innerCancellable: Cancellable

    var isCancelled: Bool { return innerCancellable.isCancelled }

    internal func cancel() {
        innerCancellable.cancel()
    }
    
    init(cancellable: Cancellable) {
        innerCancellable = cancellable
    }
}



internal class CancellableWrapper: Cancellable {
    internal var innerCancellable: Cancellable = SimpleCancellable()

    var isCancelled: Bool { return innerCancellable.isCancelled }

    internal func cancel() {
        innerCancellable.cancel()
    }
}

internal class SimpleCancellable: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}




enum UserAccountService {

    case user
    case register(user: User)
    case recover(email: String)
    case editProfile(user: User)
    case registerToken(token: DeviceToken)
    case unregisterToken(token: DeviceToken)
    case chapters(language: String, version: String)
    case initialize
    case characterSelect(characterSelect: CharacterSelect)
    case textClipping(textClipping: TextClipping)
    case bookmark(bookmark: Bookmark)
    case deleteTextClipping(clippingId: Int)
    case purchase(language: String, sku: String)
    case chaptersAfter(language: String, chapterId: Int, version: String)

}

// MARK: - TargetType Protocol Implementation
extension UserAccountService: TargetType {
    
    public var path: String {
        switch self {
            case .user:
                return "user/user.json"
            case .register:
                return "registration.json"
            case .recover:
                return "recover.json"
            case .editProfile:
                return "user/user.json"
            case .registerToken:
                return "user/register_token.json"
            case .unregisterToken:
                return "user/unregister_token.json"
            case .chapters:
                return "user/chapters.json"
            case .initialize:
                return "user/init.json"
            case .characterSelect:
                return "user/character_select.json"
            case .textClipping:
                return "user/text_clipping.json"
            case .bookmark:
                return "user/bookmark.json"
            case .deleteTextClipping:
                return "user/text_clipping_delete.json"
            case .purchase:
                return "user/purchase.json"
            case .chaptersAfter:
                return "user/chapters_after.json"

        }
    }
    
    public var method: HTTPMethod {
        switch self {
            case .user:
                return .get
            case .register:
                return .post
            case .recover:
                return .get
            case .editProfile:
                return .post
            case .registerToken:
                return .post
            case .unregisterToken:
                return .post
            case .chapters:
                return .get
            case .initialize:
                return .get
            case .characterSelect:
                return .post
            case .textClipping:
                return .post
            case .bookmark:
                return .post
            case .deleteTextClipping:
                return .delete
            case .purchase:
                return .get
            case .chaptersAfter:
                return .get

        }
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
            switch self {
            case .user:
                return .requestPlain
            case .register(let user):
                return .requestJSONEncodable(user)
            case .recover(let email):
                return .requestParameters(["email": email])
            case .editProfile(let user):
                return .requestJSONEncodable(user)
            case .registerToken(let token):
                return .requestJSONEncodable(token)
            case .unregisterToken(let token):
                return .requestJSONEncodable(token)
            case .chapters(let language, let version):
                return .requestParameters(["lang": language, "full": "true", "version": version])
            case .characterSelect(let characterSelect):
                return .requestJSONEncodable(characterSelect)
            case .initialize:
                return .requestPlain
            case .textClipping(let textClipping):
                return .requestJSONEncodable(textClipping)
            case .bookmark(let bookmark):
                return .requestJSONEncodable(bookmark)
            case .deleteTextClipping(let clippingId):
                return .requestParameters(["text_clipping_id" : clippingId])
            case .purchase(let language, let sku):
                return .requestParameters(["lang" : language, "sku": sku])
            case .chaptersAfter(let language, let chapterId, let version):
                return .requestParameters(["lang": language, "id": chapterId, "full": "true", "version": version])

            }

    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }




}
