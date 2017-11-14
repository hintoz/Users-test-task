//
//  RequestFactory.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import Alamofire

class RequestFactory {
    let baseAPIURL: String
    
    init() {
        baseAPIURL = Config.server.base
    }
    
    func receiveUsersListRequest() -> DataRequest {
        let requestUrl = baseAPIURL + "users.json"
        return Alamofire.request(requestUrl, method: .get)
    }
    
    func sendAddNewUserRequest(_ user: User) -> DataRequest {
        let parameters = user.dictionaryRepresentation()
        let requestUrl = baseAPIURL + "users.json"
        return Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
    }
    
    func sendEditUserRequest(_ user: User) -> DataRequest {
        let parameters = user.dictionaryRepresentation()
        let requestUrl = baseAPIURL + "users/\(user.id!).json"
        return Alamofire.request(requestUrl, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
    }
}
