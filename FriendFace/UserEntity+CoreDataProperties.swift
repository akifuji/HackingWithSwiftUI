//
//  UserEntity+CoreDataProperties.swift
//  FriendFace
//
//  Created by Akifumi Fujita on 2021/06/07.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var friends: [String]?
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: [String]?

    public var wrappedId: String {
        id ?? ""
    }
    public var wrappedAbout: String {
        about ?? ""
    }
    public var wrappedAddress: String {
        address ?? ""
    }
    public var wrappedCompany: String {
        company ?? ""
    }
    public var wrappedEmail: String {
        email ?? ""
    }
    public var wrappedFriends: [String] {
        friends ?? []
    }
    public var wrappedName: String {
        name ?? ""
    }
    public var wrappedRegistered: Date {
        registered ?? Date()
    }
    public var wrappedTags: [String] {
        tags ?? []
    }
}

extension UserEntity : Identifiable {

}
