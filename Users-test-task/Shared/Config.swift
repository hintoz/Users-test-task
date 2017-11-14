//
//  Config.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation

class Config {
    
    struct server {
        static let base = "https://bb-test-server.herokuapp.com/"
    }
    
    struct cloudinary {
        static let name = "dxtfghs7s"
        static let apiKey = "458832329159475"
        static let apiSecret = "cx1bQd6wymKGydikJNoGzCi7uHY"
        static let base = "cloudinary://\(apiKey):\(apiSecret)@\(name)"
    }
}
