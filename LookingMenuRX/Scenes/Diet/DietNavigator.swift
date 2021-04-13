import Foundation
import UIKit

protocol DietNavigatorType {
    func goAddDietView(view: DietController)
    func goDetailView(recipe: Recipe)
    func showAlertError()
}

struct DietNavigator: DietNavigatorType {
    unowned let navigationController: UINavigationController
    
    func goAddDietView(view: DietController) {
        let viewController = AddDietViewController.instantiate()
        let useCase = AddDietUseCase()
        let navigator = AddDietNavigator(navigationController: navigationController)
        let viewModel = AddDietViewModel(navigator: navigator,
                                         usecase: useCase)
        
        viewController.delegateHandleDiet = view
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goDetailView(recipe: Recipe) {
        let viewController = DetailRecipeController.instantiate()
        let useCase = DetailRecipeUseCase()
        let navigator = DetailRecipeNavigator(navigationController: navigationController)
        let viewModel = DetailRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAlertError() {
        navigationController.showAlert(
            title: "Alert",
            message: "Quantity saved within 7 days",
            style: .alert)
    }
}
