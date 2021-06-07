//
//  ContentView.swift
//  FriendFace
//
//  Created by Akifumi Fujita on 2021/06/06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: []) var userEntities: FetchedResults<UserEntity>
    @ObservedObject var observedUsers = ObservableUsers()

    var body: some View {
        NavigationView {
            List(observedUsers.users) { user in
                NavigationLink(destination: DetailView(observedUsers: observedUsers, user: user)) {
                    Image(systemName: "circle.fill")
                        .foregroundColor(user.isActive ? .green : .red)
                    Text(user.name)
                        .font(.headline)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationTitle("FriendFace")
            .onAppear(perform: setUsers)
        }
    }
    
    private func setUsers() {
        guard userEntities.count > 0 else {
            print("Hi")
            fetchUsers()
            return
        }
        observedUsers.users = userEntities.map { User(userEntiry: $0) }
    }
    
    private func fetchUsers() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            decoder.dateDecodingStrategy = .formatted(formatter)
            if let decodeOrder = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    observedUsers.users = decodeOrder
                }
            } else {
                print("Decode failed")
            }
        }.resume()
    }
    
    private func save() {
        for user in observedUsers.users {
            let newUser = UserEntity(context: self.moc)
            newUser.id = user.id
            newUser.name = user.name
            newUser.company = user.company
            newUser.email = user.email
            newUser.address = user.address
            newUser.isActive = user.isActive
            newUser.age = Int16(user.age)
            newUser.tags = user.tags
            newUser.friends = user.friends.map { $0.id }
            try? self.moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
