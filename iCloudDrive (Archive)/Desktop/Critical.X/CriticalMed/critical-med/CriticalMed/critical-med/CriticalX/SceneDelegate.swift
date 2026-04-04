import UIKit
import SwiftUI
import FirebaseCore
import FirebaseAuth
// import Siren

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    /// Shared theme manager for the app - persists user's theme preference
    static let themeManager = ThemeManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // iCloud Key-Value: pull synced settings into UserDefaults before any managers init
        ICloudSettingsSync.shared.bootstrap()
        // Sync content from Supabase (medications, drips) on launch
        ContentSyncService.shared.syncIfNeeded()

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        // Show splash screen first, wrapped with theme support
        let rootView = ThemedRootView {
            SplashScreen()
        }
        let hostingController = UIHostingController(rootView: rootView)
        
        window.rootViewController = hostingController
        self.window = window
        window.makeKeyAndVisible()
        
        // Ensure Firebase is initialized
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Let SplashScreen handle its own timing and navigation
        // Don't override it from here
    }

    func navigateAfterSplash() {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.3

        // Check Firebase authentication instead of UserDefaults
        let isUserAuthenticated = Auth.auth().currentUser != nil

        // Wrap with theme support
        let rootView = ThemedRootView {
            if isUserAuthenticated {
                AppTabContainer()
            } else {
                SignupView()
            }
        }

        let hostingController = UIHostingController(rootView: rootView)
        // Dark mode: use dark canvas (matches Clinical Pharmacology list) so no black shows
        if SceneDelegate.themeManager.preferredColorScheme == .dark {
            let darkCanvas = UIColor(red: 15/255, green: 18/255, blue: 25/255, alpha: 1)
            window?.backgroundColor = darkCanvas
            hostingController.view.backgroundColor = darkCanvas
        } else {
            window?.backgroundColor = UIColor.systemBackground
            hostingController.view.backgroundColor = UIColor.systemBackground
        }
        window?.layer.add(transition, forKey: kCATransition)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {
        ContentSyncService.shared.syncIfNeeded()
    }
    func sceneDidEnterBackground(_ scene: UIScene) {}

    func showTabBarController() {
        let rootView = ThemedRootView {
            AppTabContainer()
        }
        let hosting = UIHostingController(rootView: rootView)
        if SceneDelegate.themeManager.preferredColorScheme == .dark {
            let darkCanvas = UIColor(red: 15/255, green: 18/255, blue: 25/255, alpha: 1)
            window?.backgroundColor = darkCanvas
            hosting.view.backgroundColor = darkCanvas
        } else {
            window?.backgroundColor = .systemBackground
            hosting.view.backgroundColor = .systemBackground
        }
        window?.rootViewController = hosting
        window?.makeKeyAndVisible()
    }
}

// MARK: - Themed Root View Wrapper
/// Wraps any view with theme support from ThemeManager and global patient context
/// Applies the user's preferred color scheme (Light/Dark/System)
struct ThemedRootView<Content: View>: View {
    @ObservedObject private var themeManager = SceneDelegate.themeManager
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .preferredColorScheme(themeManager.preferredColorScheme)
            .environmentObject(themeManager)
            .environmentObject(patientContext)
    }
}
