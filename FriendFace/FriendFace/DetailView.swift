//
//  DetailView.swift
//  FriendFace
//
//  Created by Akifumi Fujita on 2021/06/06.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var observedUsers: ObservableUsers
    let user: User
    
    var body: some View {
        VStack {
            Text(user.name)
                .font(.title)
            VStack(alignment: .leading, spacing: 4.5) {
                Text("age: \(user.age)")
                Text("company: \(user.company)")
                Text("email: \(user.email)")
                Text("address: \(user.address)")
                Text("\(user.about)")
                HStack {
                    ForEach(user.tags, id: \.self) {
                        Text($0)
                    }
                }
            }
            .padding(.horizontal)
            Divider()
            Text("Friends")
            List(user.friends) { friend in
                NavigationLink(destination: DetailView(observedUsers: observedUsers, user: queryUser(id: friend.id))) {
                    Text(queryUser(id: friend.id).name)
                }
            }
            Spacer()
        }
    }
    
    private func queryUser(id: String) -> User {
        if let foundUser = observedUsers.users.first(where: { $0.id == id }) {
            return foundUser
        } else {
            fatalError("User not found")
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        let friend = Friend(id: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0", name: "Hawkins Patel")
//        let friend2 = Friend(id: "0c395a95-57e2-4d53-b4f6-9b9e46a32cf6", name: "Jewel Sexton")
//        let friend3 = Friend(id: "be5918a3-8dc2-4f77-947c-7d02f69a58fe", name: "Berger Robertson")
//        let friend4 = Friend(id: "f2f86852-8f2d-46d3-9de5-5bed1af9e4d6", name: "Hess Ford")
//        let user = User(id: "50a48fa3-2c0f-4397-ac50-64da464f9954", isActive: false, name: "Alford Rodriguez", age: 21, company: "Imkan", email: "alfordrodriguez@imkan.com", address: "907 Nelson Street, Cotopaxi, South Dakota, 5913", about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.\r\n", registered: formatter.date(from: "2015-11-10T01:47:18-00:00")!, tags: ["cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim", "tempor"], friends: [friend, friend2, friend3, friend4])
//        return DetailView(observedUsers: ObservableUsers(), user: user)
//    }
//}
