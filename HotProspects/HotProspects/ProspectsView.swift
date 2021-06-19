//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Akifumi Fujita on 2021/06/18.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShoingScanner = false
    @State private var isShowingSortTypeActionSheet = false
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if filter == .none {
                            Image(systemName: "\(prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")")
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark contacted") {
                            prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShoingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }
                    Button(action: {
                        isShowingSortTypeActionSheet = true
                    }) {
                        Text("Sort")
                    }
                }
            }
            .sheet(isPresented: $isShoingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .actionSheet(isPresented: $isShowingSortTypeActionSheet) {
                ActionSheet(title: Text("Sort by..."), buttons: [
                    .default(Text("Name")) { prospects.change(.name) },
                    .default(Text("Date")) { prospects.change(.date) }
                ])
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        let sortedPeople = prospects.sorted()
        switch filter {
        case .none:
            return sortedPeople
        case .contacted:
            return sortedPeople.filter { $0.isContacted }
        case .uncontacted:
            return sortedPeople.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isShoingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
            
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

//struct ProspectsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProspectsView(filter: .none)
//    }
//}
