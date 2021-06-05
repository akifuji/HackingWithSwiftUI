//
//  CandyView.swift
//  CoreDataProject
//
//  Created by Akifumi Fujita on 2021/06/05.
//

import SwiftUI
import CoreData

struct CandyView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add") {
                let UK = Country(context: self.moc)
                UK.shortName = "UK"
                UK.fullName = "United Kingdom"
                
                let candy1 = Candy(context: self.moc)
                candy1.name = "Mars"
                candy1.origin = UK
               
                let candy2 = Candy(context: self.moc)
                candy2.name = "KitKat"
                candy2.origin = UK

                let candy3 = Candy(context: self.moc)
                candy3.name = "Twix"
                candy3.origin = UK

                let candy4 = Candy(context: self.moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: self.moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"

                do {
                    try self.moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct CandyView_Previews: PreviewProvider {
    static var previews: some View {
        CandyView()
    }
}
