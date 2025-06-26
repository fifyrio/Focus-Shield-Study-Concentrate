import SwiftUI

struct AppSelectionView: View {
    @StateObject private var viewModel = ShieldViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var showingAddCustomApp = false
    @State private var selectedCategory: AppCategory = .all
    
    private let predefinedApps = [
        PredefinedApp(name: "Instagram", icon: "📷", category: .social, colors: [Color.pink, Color.red]),
        PredefinedApp(name: "YouTube", icon: "▶️", category: .entertainment, colors: [Color.red, Color.orange]),
        PredefinedApp(name: "TikTok", icon: "🎵", category: .social, colors: [Color.black, Color.purple]),
        PredefinedApp(name: "Facebook", icon: "👤", category: .social, colors: [Color.blue, Color.indigo]),
        PredefinedApp(name: "Twitter/X", icon: "🐦", category: .social, colors: [Color.blue, Color.cyan]),
        PredefinedApp(name: "Snapchat", icon: "👻", category: .social, colors: [Color.yellow, Color.orange]),
        PredefinedApp(name: "Reddit", icon: "📱", category: .social, colors: [Color.orange, Color.red]),
        PredefinedApp(name: "Netflix", icon: "🎬", category: .entertainment, colors: [Color.red, Color.black]),
        PredefinedApp(name: "Disney+", icon: "🏰", category: .entertainment, colors: [Color.blue, Color.purple]),
        PredefinedApp(name: "Spotify", icon: "🎧", category: .entertainment, colors: [Color.green, Color.black]),
        PredefinedApp(name: "Apple Music", icon: "🎶", category: .entertainment, colors: [Color.red, Color.pink]),
        PredefinedApp(name: "WhatsApp", icon: "💬", category: .communication, colors: [Color.green, Color.mint]),
        PredefinedApp(name: "Telegram", icon: "✈️", category: .communication, colors: [Color.blue, Color.cyan]),
        PredefinedApp(name: "Discord", icon: "🎮", category: .communication, colors: [Color.indigo, Color.purple]),
        PredefinedApp(name: "Twitch", icon: "🟣", category: .entertainment, colors: [Color.purple, Color.indigo]),
        PredefinedApp(name: "Amazon", icon: "📦", category: .shopping, colors: [Color.orange, Color.yellow]),
        PredefinedApp(name: "eBay", icon: "🛒", category: .shopping, colors: [Color.blue, Color.red]),
        PredefinedApp(name: "News", icon: "📰", category: .news, colors: [Color.blue, Color.gray])
    ]
    
    private var filteredApps: [PredefinedApp] {
        let categoryFiltered = selectedCategory == .all ? predefinedApps : predefinedApps.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                searchSection
                categorySection
                appListSection
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.96, blue: 0.97),
                        Color(red: 0.94, green: 0.94, blue: 0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Manage Apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCustomApp = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCustomApp) {
            AddCustomAppView { appItem in
                viewModel.apps.append(appItem)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Choose Apps to Block")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Select the apps you want to block during focus sessions")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var searchSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search apps...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AppCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }
    
    private var appListSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredApps, id: \.name) { app in
                    AppSelectionRow(
                        app: app,
                        isBlocked: isAppBlocked(app),
                        onToggle: {
                            toggleApp(app)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func isAppBlocked(_ predefinedApp: PredefinedApp) -> Bool {
        viewModel.apps.contains { $0.name == predefinedApp.name }
    }
    
    private func toggleApp(_ predefinedApp: PredefinedApp) {
        if let existingIndex = viewModel.apps.firstIndex(where: { $0.name == predefinedApp.name }) {
            viewModel.apps.remove(at: existingIndex)
        } else {
            let appItem = AppItem(
                name: predefinedApp.name,
                icon: predefinedApp.icon,
                color: predefinedApp.colors.first ?? .blue,
                blocked: true
            )
            viewModel.apps.append(appItem)
        }
    }
}

private enum AppCategory: String, CaseIterable {
    case all = "All"
    case social = "Social"
    case entertainment = "Entertainment"
    case communication = "Communication"
    case shopping = "Shopping"
    case news = "News"
    case games = "Games"
    
    var icon: String {
        switch self {
        case .all: return "apps.iphone"
        case .social: return "person.2"
        case .entertainment: return "play.circle"
        case .communication: return "message"
        case .shopping: return "cart"
        case .news: return "newspaper"
        case .games: return "gamecontroller"
        }
    }
}

private struct PredefinedApp {
    let name: String
    let icon: String
    let category: AppCategory
    let colors: [Color]
}

private struct CategoryButton: View {
    let category: AppCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct AppSelectionRow: View {
    let app: PredefinedApp
    let isBlocked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: app.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: app.colors.first?.opacity(0.3) ?? .clear, radius: 4, x: 0, y: 2)
                
                Text(app.icon)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(app.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.1))
                    )
            }
            
            Spacer()
            
            Button {
                onToggle()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isBlocked ? "checkmark" : "plus")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(isBlocked ? "Added" : "Add")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isBlocked ? Color.green : Color.blue)
                )
                .foregroundColor(.white)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        )
    }
}

private struct AddCustomAppView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appName = ""
    @State private var selectedIcon = "📱"
    @State private var selectedColor = Color.blue
    
    let onSave: (AppItem) -> Void
    
    private let availableIcons = ["📱", "💻", "🎮", "🎵", "📺", "🛒", "💼", "📚", "🏃‍♂️", "🎨"]
    private let availableColors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .cyan, .yellow]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Name")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    TextField("Enter app name", text: $appName)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Icon")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Text(icon)
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Color.gray.opacity(0.1))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Color")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                        ForEach(availableColors, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 3)
                                            .opacity(selectedColor == color ? 1 : 0)
                                    )
                                    .scaleEffect(selectedColor == color ? 1.2 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .animation(.spring(response: 0.3), value: selectedColor)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Add Custom App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let appItem = AppItem(
                            name: appName,
                            icon: selectedIcon,
                            color: selectedColor,
                            blocked: true
                        )
                        onSave(appItem)
                        dismiss()
                    }
                    .disabled(appName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AppSelectionView()
}