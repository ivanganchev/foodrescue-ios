//
//  SceneDelegate.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2023-12-23.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let jwtAuthenticator = JWTAuthentication()
    let authService = AuthenticationService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        authService.verifyToken(completion: { result in
            switch result {
            case .success(()):
                let dashboardViewController = TabBarController()
                self.setRootViewController(dashboardViewController, for: scene as! UIWindowScene)
            case .failure(_):
                self.logout()
            }
        })
        
        RealmMigrator.migrateRealm()
    }

    func logout() {
        Realm.reset()
        showLogin()
        jwtAuthenticator.deleteJWToken()
    }

    func showLogin() {
        let loginViewController = LogInViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        setRootViewController(loginViewController, for: windowScene)
    }

    private func setRootViewController(_ viewController: UIViewController, for windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

