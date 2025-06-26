import Foundation
import Combine

class AppBlockingService: ObservableObject {
    private let dataService: DataServiceProtocol
    private let appsKey = "blockedApps"
    
    @Published var apps: [AppItem] = []
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
        loadApps()
    }
    
    private func loadApps() {
        if let savedApps: [AppItem] = dataService.load([AppItem].self, forKey: appsKey) {
            self.apps = savedApps
        } else {
            setupDefaultApps()
        }
    }
    
    private func setupDefaultApps() {
        apps = [
            AppItem(name: "Instagram", icon: "📷", color: .purple, blocked: true),
            AppItem(name: "YouTube", icon: "▶️", color: .red, blocked: true),
            AppItem(name: "TikTok", icon: "🎵", color: .pink, blocked: true),
            AppItem(name: "Facebook", icon: "👤", color: .blue, blocked: true)
        ]
        saveApps()
    }
    
    private func saveApps() {
        dataService.save(apps, forKey: appsKey)
    }
    
    func toggleAppBlocking(for app: AppItem) {
        if let index = apps.firstIndex(where: { $0.id == app.id }) {
            apps[index].blocked.toggle()
            saveApps()
        }
    }
    
    func blockAllApps() {
        for index in apps.indices {
            apps[index].blocked = true
        }
        saveApps()
    }
    
    func unlockAllApps() {
        for index in apps.indices {
            apps[index].blocked = false
        }
        saveApps()
    }
    
    func getBlockedApps() -> [AppItem] {
        return apps.filter { $0.blocked }
    }
    
    func getUnblockedApps() -> [AppItem] {
        return apps.filter { !$0.blocked }
    }
}