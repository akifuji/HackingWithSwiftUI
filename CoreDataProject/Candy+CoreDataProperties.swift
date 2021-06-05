//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Akifumi Fujita on 2021/06/05.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    public var wrappedName: String {
        name ?? "Unknwon Candy"
    }
}

extension Candy : Identifiable {

}
