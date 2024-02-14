//
//  SceneDelegate.swift
//  RecipeSearch
//
//  Created by user on 28.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = CustomTabBarController()
        let animationView = UIView()
        animationView.backgroundColor = .basic
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        launchAnimataion(animationView: animationView, for: window, tabBarFrame: tabBarController.tabBar.frame)
    }

    private func launchAnimataion(animationView: UIView, for window: UIWindow, tabBarFrame: CGRect) {
         window.addSubview(animationView)
         animationView.frame = window.bounds
         let positionOnX: CGFloat = 15
         let positionOnY: CGFloat = 14
         let width = (tabBarFrame.width) - positionOnX * 2
         let height: CGFloat = 77
         let frame =  CGRect(x: positionOnX, y: ((tabBarFrame.minY) - positionOnY) , width: width, height: height)
         
         let movingAnimation =  {
             UIViewPropertyAnimator(duration:0.5, curve: .easeOut) {
                 animationView.frame =  frame
                 animationView.layer.cornerRadius = height / 2
             }
         }()
        
        let disappearingAnimator = {
             UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) { animationView.layer.opacity = 0 }
         }()
        
         movingAnimation.addCompletion {_ in disappearingAnimator.startAnimation() }
         disappearingAnimator.addCompletion {  _ in animationView.removeFromSuperview() }
         movingAnimation.startAnimation()
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

