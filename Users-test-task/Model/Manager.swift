//
//  Manager.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation

protocol Manager: class {
    weak var delegate: ManagerDelegate? { get set }
    var requestFactory: RequestFactory { get }
    var user: User! { get set }
}

protocol ManagerDelegate: class {
    func needUpdateData()
}

class ManagerImp: Manager {
    weak var delegate: ManagerDelegate?
    let requestFactory: RequestFactory
    var user: User!
    
    init() {
        requestFactory = RequestFactory()
    }
}
