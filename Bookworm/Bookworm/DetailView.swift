//
//  DetailView.swift
//  Bookworm
//
//  Created by Akifumi Fujita on 2021/06/03.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let genre = book.genre, genre.isEmpty == false {
                        Image(genre)
                            .frame(maxWidth: geometry.size.width)
                    } else {
                        Color.black
                            .frame(maxWidth: geometry.size.width, maxHeight: 240)
                    }
                    Text(self.book.genre?.uppercased() ?? "Unknown genre")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                HStack {
                    Spacer()
                    Text("(\(formatDate(book.date ?? Date())))")
                }
                .padding()
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                deleteBook()
            }, secondaryButton: .cancel()
            )
        }
        .navigationTitle(Text(book.title ?? "Unknown title"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingDeleteAlert = false
                }) {
                    Image(systemName: "trash")
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    func deleteBook() {
        moc.delete(book)
        try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great boook; I really enjoyed it."
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
