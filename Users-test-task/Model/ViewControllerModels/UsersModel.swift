//
//  UsersModel.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import NotificationBannerSwift

protocol UsersModelDelegate: class {
    func didUpdateUsers(model: UsersModel)
}

class UsersModel {
    var users = [User]()
    weak var delegate: UsersModelDelegate?
    let networkingService: UsersNetworkingService
    
    init(manager: Manager) {
        networkingService = UsersNetworkingService(requestFactory: manager.requestFactory)
    }
    
    func loadUsersList() {
        networkingService.receiveUsersList { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if let users = response {
                strongSelf.users = users
                strongSelf.delegate?.didUpdateUsers(model: strongSelf)
            } else {
                debugPrint("[!ERROR]: \(String(describing: error?.localizedDescription ?? "unknown"))")
                let banner = NotificationBanner(title: "Ошибка", subtitle: "\(error?.localizedDescription ?? "unknown")", style: .danger)
                banner.show(queuePosition: .front)
            }
        }
    }
}
