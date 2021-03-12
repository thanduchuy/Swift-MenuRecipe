import Foundation
import RxSwift
import RxCocoa

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let isNewUser =  UserDefaults.standard.bool(forKey: KeyUserDefaults.keyCheckNewUser)
        if isNewUser {
            let navigation = UINavigationController()
            let viewController = MainViewController.instantiate()
            let viewModel = MainViewModel(navigation: navigation)
            viewController.bindViewModel(to: viewModel)
            navigation.viewControllers = [viewController]
            window.rootViewController = navigation
        } else {
            let viewController = WelcomeViewController.instantiate()
            let navigator = WelcomeViewNavigator(window: window)
            let viewModel = WelcomeViewModel(navigator: navigator)
            viewController.bindViewModel(to: viewModel)
            window.rootViewController = viewController
        }
        window.makeKeyAndVisible()
    }
}
