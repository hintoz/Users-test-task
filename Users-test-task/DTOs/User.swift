//
//  User.swift
//  Users-test-task
//
//  Created by Евгений Дац on 13.11.2017.
//  Copyright © 2017 Evgeny Dats. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable {
    
    private struct SerializationKeys {
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let email = "email"
        static let avatarUrl = "avatar_url"
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
        static let url = "url"
    }
    
    public var id: Int?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var avatarUrl: String?
    public var createdAt: String?
    public var updatedAt: String?
    public var url: String?
    
    public required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    public func mapping(map: Map) {
        id <- map[SerializationKeys.id]
        firstName <- map[SerializationKeys.firstName]
        lastName <- map[SerializationKeys.lastName]
        email <- map[SerializationKeys.email]
        avatarUrl <- map[SerializationKeys.avatarUrl]
        createdAt <- map[SerializationKeys.createdAt]
        updatedAt <- map[SerializationKeys.updatedAt]
        url <- map[SerializationKeys.url]
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = firstName { dictionary[SerializationKeys.firstName] = value }
        if let value = lastName { dictionary[SerializationKeys.lastName] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = avatarUrl { dictionary[SerializationKeys.avatarUrl] = value }
        return dictionary
    }
}
