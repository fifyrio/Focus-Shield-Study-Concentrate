import SwiftUI
import Foundation

@MainActor
public class RouterPath: ObservableObject {
    @Published public var path: [RouterDestination] = []
    
    public init() {}
    
    public func navigate(to: RouterDestination) {
      path.append(to)
    }

    public func pop() {
        path.removeLast()
    }

    public func popToRoot() {
        path.removeAll()
    }
}

public enum RouterDestination: Hashable, Equatable {
    // Timer and Focus
    case timerView
    
    // Flashcard System
    case flashcardSession(deck: Deck)
    case deckEdit(deck: Deck?)
    case flashcardEdit(deck: Deck, flashcard: Flashcard?)
    
    // App Management
    case appSelection
    case setupInstructions(appName: String)
    
    // Information Views
    case helpView
    case privacyView
    case termsView
    case upgradeView
    case socialLinksView
    
    public static func == (lhs: RouterDestination, rhs: RouterDestination) -> Bool {
        switch (lhs, rhs) {
        case (.timerView, .timerView):
            return true
        case (.flashcardSession(let lhsDeck), .flashcardSession(let rhsDeck)):
            return lhsDeck.id == rhsDeck.id
        case (.deckEdit(let lhsDeck), .deckEdit(let rhsDeck)):
            return lhsDeck?.id == rhsDeck?.id
        case (.flashcardEdit(let lhsDeck, let lhsCard), .flashcardEdit(let rhsDeck, let rhsCard)):
            return lhsDeck.id == rhsDeck.id && lhsCard?.id == rhsCard?.id
        case (.appSelection, .appSelection):
            return true
        case (.setupInstructions(let lhsName), .setupInstructions(let rhsName)):
            return lhsName == rhsName
        case (.helpView, .helpView):
            return true
        case (.privacyView, .privacyView):
            return true
        case (.termsView, .termsView):
            return true
        case (.upgradeView, .upgradeView):
            return true
        case (.socialLinksView, .socialLinksView):
            return true
        default:
            return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .timerView:
            hasher.combine("timerView")
        case .flashcardSession(let deck):
            hasher.combine("flashcardSession")
            hasher.combine(deck.id)
        case .deckEdit(let deck):
            hasher.combine("deckEdit")
            hasher.combine(deck?.id)
        case .flashcardEdit(let deck, let flashcard):
            hasher.combine("flashcardEdit")
            hasher.combine(deck.id)
            hasher.combine(flashcard?.id)
        case .appSelection:
            hasher.combine("appSelection")
        case .setupInstructions(let appName):
            hasher.combine("setupInstructions")
            hasher.combine(appName)
        case .helpView:
            hasher.combine("helpView")
        case .privacyView:
            hasher.combine("privacyView")
        case .termsView:
            hasher.combine("termsView")
        case .upgradeView:
            hasher.combine("upgradeView")
        case .socialLinksView:
            hasher.combine("socialLinksView")
        }
    }
}

@MainActor
extension View {
    /*
     Register the components' router here
     */
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case .timerView:
                TimerView()
                
            case .flashcardSession(let deck):
                FlashcardSessionView(deck: deck)
                
            case .deckEdit(let deck):
                DeckEditView(deck: deck)
                
            case .flashcardEdit(let deck, let flashcard):
                FlashcardEditView(flashcard: flashcard, onSave: nil)
                
            case .appSelection:
                AppSelectionView()
                
            case .setupInstructions(let appName):
                SetupInstructionsView(appName: appName)
                
            case .helpView:
                HelpView()
                
            case .privacyView:
                PrivacyView()
                
            case .termsView:
                TermsView()
                
            case .upgradeView:
                UpgradeView()
                
            case .socialLinksView:
                SocialLinksView()
            }
        }
    }
}
