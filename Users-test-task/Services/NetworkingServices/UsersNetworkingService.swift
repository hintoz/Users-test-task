//
//  UsersNetworkingService.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class UsersNetworkingService {
    var requestFactory: RequestFactory
    
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func receiveUsersList(completed: @escaping (_ responseObject: [User]?, _ error: Error?) -> ()) {
        requestFactory.receiveUsersListRequest()
            .responseArray { (response: DataResponse<[User]>) in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        completed(response.result.value, nil)
                    }
                    break
                case .failure(let error):
                    completed(nil, error)
                }
        }
    }
    
    func sendEditUser(_ user: User, completed: @escaping (_ responseObject: User?, _ error: Error?) -> ()) {
        requestFactory.sendEditUserRequest(user)
        .validate()
            .responseObject { (response: DataResponse<User>) in
                switch response.result {
                    case .success:
                    if response.response?.statusCode == 200 {
                    completed(response.result.value, nil)
                    }
                    break
                    case .failure(let error):
                    completed(nil, error)
                }
        }
    }
    
    func sendAddNewUser(_ user: User, completed: @escaping (_ responseObject: User?, _ error: Error?) -> ()) {
        requestFactory.sendAddNewUserRequest(user)
        .validate()
            .responseObject { (response: DataResponse<User>) in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 201 {
                        completed(response.result.value, nil)
                    }
                    break
                case .failure(let error):
                    completed(nil, error)
                }
        }
    }
}
