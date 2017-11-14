//
//  UserModel.swift
//  Users-test-task
//
//  Created by Евгений Дац on 14.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import NotificationBannerSwift

class UserModel {
    var user: User!
    let networkingService: UsersNetworkingService
    let manager: Manager
    
    init(manager: Manager) {
        networkingService = UsersNetworkingService(requestFactory: manager.requestFactory)
        self.manager = manager
        self.user = manager.user
    }
    
    func editUser() {
        networkingService.sendEditUser(user) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if let user = response {
                let banner = NotificationBanner(title: "Выполнено", subtitle: "\"\(user.firstName!) \(user.lastName!)\" сохранен.", style: .success)
                banner.duration = 1
                banner.show(queuePosition: .front)
                strongSelf.manager.delegate?.needUpdateData()
                strongSelf.manager.user = user
            } else {
                let banner = NotificationBanner(title: "Ошибка", subtitle: "\(error?.localizedDescription ?? "unknown")", style: .danger)
                banner.show(queuePosition: .front)
            }
        }
    }
    
    func addNewUser() {
        networkingService.sendAddNewUser(user) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if let user = response {
                let banner = NotificationBanner(title: "Выполнено", subtitle: "\"\(user.firstName!) \(user.lastName!)\" добавлен.", style: .success)
                banner.duration = 1
                banner.show(queuePosition: .front)
                strongSelf.manager.delegate?.needUpdateData()
            } else {
                let banner = NotificationBanner(title: "Ошибка", subtitle: "\(error?.localizedDescription ?? "unknown")", style: .danger)
                banner.show(queuePosition: .front)
            }
        }
    }
}
