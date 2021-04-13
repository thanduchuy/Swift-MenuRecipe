import Foundation
import RxSwift
import RxCocoa

protocol HomeNavigatorType {
    func toRecipeDetail(recipe: Recipe)
    func toSearchView(query: String)
    func toOrderPlaces()
}

struct HomeNavigator: HomeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toRecipeDetail(recipe: Recipe) {
        let viewController = DetailRecipeController.instantiate()
        let useCase = DetailRecipeUseCase()
        let navigator = DetailRecipeNavigator(navigationController: navigationController)
        let viewModel = DetailRecipeViewModel(navigator: navigator, usecase: useCase, recipe: recipe)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toSearchView(query: String) {
        let viewController = SearchViewController.instantiate()
        let navigator = SearchViewNavigator(navigationController: navigationController)
        let useCase = SearchViewUseCase()
        let viewModel = SearchViewModel(usecase: useCase,
                                        navigator: navigator,
                                        keyWord: query,
                                        typeSearch: .searchName)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toOrderPlaces() {
        let viewController = OrderPlacedViewController.instantiate()
        let useCase = OrderPlaceUseCase()
        let viewModel = OrderPlacedViewModel(useCase: useCase)
        
        viewController.bindViewModel(to: viewModel)
        navigationController.present(viewController, animated: true, completion: nil)
    }
}
