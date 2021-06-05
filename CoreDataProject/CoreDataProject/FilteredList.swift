//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Akifumi Fujita on 2021/06/05.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    
    let content: (T) -> Content
    
    init(predicate: Predicate, filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor] = [], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:sortDescriptors, predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { result in
            content(result)
        }
    }
}

//struct FilteredList_Previews: PreviewProvider {
//    static var previews: some View {
//        FilteredList(filterKey: , filterValue: , content: )
//    }
//}
