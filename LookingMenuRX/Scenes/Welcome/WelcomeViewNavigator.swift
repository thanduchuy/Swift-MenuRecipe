import Foundation
import UIKit
import Reusable

protocol WelcomeViewNavigatorType {
    func toMainView()
}

struct WelcomeViewNavigator: WelcomeViewNavigatorType {
    unowned let window: UIWindow
    
    func toMainView() {
        let viewController = MainViewController.instantiate()
        let mainViewModel = MainViewModel(navigation: UINavigationController())
        viewController.bindViewModel(to: mainViewModel)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
