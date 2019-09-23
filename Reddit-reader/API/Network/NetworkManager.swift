//
//  NetworkManager.swift
//  Reddit-reader
//
//  Created by Madhu on 19/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

enum NewsFeed {
    case fetchFeed
    case fetchAccessToken
    case grandType
    
    func getPath() -> String {
        switch self {
        case .fetchFeed:
            return "https://oauth.reddit.com/r/swift/hot.json"
        case .fetchAccessToken:
            return "https://www.reddit.com/api/v1/access_token"
        case .grandType:
            return "https://oauth.reddit.com/grants/installed_client"
        }
    }
}

let kAccessTokenKey = "access_token"

class NetworkManager: NSObject {

    //MARK: Singleton instance
    static let sharedInstance = NetworkManager()
    
    
    
    //MARK: fetch news feed
    func getFeed(completion:@escaping (_ results:Feeds)->(), failure:@escaping (_ error:Error?)->()) {
        
        if let accessToken = KeychainWrapper.standard.string(forKey: kAccessTokenKey){ // retrieve accesstoken
            
            Alamofire.request(NewsFeed.fetchFeed.getPath(), method: .get , headers: ["Authorization": "Bearer \(accessToken)"]).responseData{ response in
                
                do {
                    if (response.response?.statusCode == 401){ //unauthorized
                        self.getAccessToken(completion: { auth in
                            if let token = auth.access_token{
                                // store accesstoken
                                KeychainWrapper.standard.set(token, forKey: kAccessTokenKey)
                                self.getFeed(completion: { feeds in
                                    completion(feeds)
                                }, failure: { error in
                                    failure(error)
                                })
                            }
                        }, failure: { error in
                            failure(error)
                        })
                    }
                    else{
                        let feeds = try JSONDecoder().decode(Feeds.self, from: response.value!)
                        completion(feeds)
                    }
                    
                } catch {
                    failure(error)
                }
            }
        }
        else{ // fetch accesstoken
            
            self.getAccessToken(completion: { auth in
                if let token = auth.access_token{
                    KeychainWrapper.standard.set(token, forKey: kAccessTokenKey)
                    self.getFeed(completion: { feeds in
                        completion(feeds)
                    }, failure: { error in
                        failure(error)
                    })
                }
            }, failure: { error in
                failure(error)
            })
            
        }
    }
    
    //MARK: Fetch Access token
    
    func getAccessToken(completion:@escaping (_ results:Auth)->(), failure:@escaping (_ error:Error?)->()){
        
        let params = ["grant_type": NewsFeed.grandType.getPath(),
                      "device_id": UUID().uuidString]
        Alamofire.request(NewsFeed.fetchAccessToken.getPath(), method: HTTPMethod.post, parameters: params, headers: self.getHeaders()).responseData { response in
            do {
                let authValue = try JSONDecoder().decode(Auth.self, from: response.value!)
                completion(authValue)
            } catch {
                failure(error)
            }
        }
        
    }
    
    //MARK: Helper Methods
    private func getHeaders() -> [String: String] {
        let userName = "HOpNGkHkZQ7Faw"
        let password = ""
        guard let loginData = "\(userName):\(password)".data(using: String.Encoding.utf8) else {
            return ["":""]
        }
        return ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Basic \(loginData.base64EncodedString())"]
    }
    
    
}
