//
//  User.swift
//  FriendFace
//
//  Created by Akifumi Fujita on 2021/06/06.
//

import Foundation

class ObservableUsers: ObservableObject {
    @Published var users: [User] = []
}

struct User: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    init(userEntiry: UserEntity) {
        id = userEntiry.wrappedId
        isActive = userEntiry.isActive
        name = userEntiry.wrappedName
        age = Int(userEntiry.age)
        company = userEntiry.wrappedCompany
        email = userEntiry.wrappedEmail
        address = userEntiry.wrappedAddress
        about = userEntiry.wrappedAbout
        registered = userEntiry.wrappedRegistered
        tags = userEntiry.wrappedTags
        friends = userEntiry.wrappedFriends.map { Friend(id: $0, name: "") }
    }
}

struct Friend: Codable, Identifiable {
    let id: String
    let name: String
}
