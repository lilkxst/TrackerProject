//
//  SceneDelegate.swift
//  TrackerProject
//
//  Created by Артём Костянко on 24.10.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.makeKeyAndVisible()
        if UserDefaults.standard.bool(forKey: "notFirstStart") {
            self.window?.rootViewController = TabBarController()
        } else {
            UserDefaults.standard.set(true, forKey: "notFirstStart")
            self.window?.rootViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
       
    }
}

