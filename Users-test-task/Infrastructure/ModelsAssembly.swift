//
//  ModelsAssembly.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import Dip

class ModelsAssembly {
    static func assembly() -> DependencyContainer {
        return DependencyContainer { container in
            unowned let container = container
            
            container.register(ComponentScope.singleton) {
                ManagerImp() as Manager
            }
            container.register(ComponentScope.singleton) {
                CloudnaryManager() as CloudnaryManager
            }
            container.register { try UsersModel(manager: container.resolve()) }
            container.register { try UserModel(manager: container.resolve()) }
        }
    }
}
