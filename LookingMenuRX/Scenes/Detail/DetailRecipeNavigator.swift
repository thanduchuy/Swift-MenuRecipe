import Foundation
import UIKit
import Reusable

protocol DetailRecipeNavigatorType {
    func goDetailVideo(recipe: Recipe)
    func goDetailText(recipe: Recipe)
    func goBackView()
    func goOderView(recipe: Recipe)
}

struct DetailRecipeNavigator: DetailRecipeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goBackView() {
        navigationController.popViewController(animated: true)
    }
    
    func goDetailVideo(recipe: Recipe) {
        let viewController = VideoRecipeController.instantiate()
        let navigator = VideoRecipeNavigator(navigationController: navigationController)
        let useCase = VideoRecipeUseCase()
        let viewModel = VideoRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goDetailText(recipe: Recipe) {
        let viewController = TextRecipeController.instantiate()
        let navigator = TextRecipeNavigator(navigationController: navigationController)
        let useCase = TextRecipeUseCase()
        let viewModel = TextRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goOderView(recipe: Recipe) {
        let viewController = OrderViewController.instantiate()
        let navigator = OrderNavigation(navigationController: navigationController)
        let useCase = OrderUseCase()
        let viewModel = OrderViewModel(navigator: navigator, useCase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
