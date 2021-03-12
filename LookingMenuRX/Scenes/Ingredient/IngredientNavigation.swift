import Foundation
import RxSwift
import RxCocoa

protocol IngredientNavigationType {
    func goSearchView(query: String)
}

struct IngredientNavigation: IngredientNavigationType {
    unowned let navigationController: UINavigationController
    
    func goSearchView(query: String) {
        let viewController = SearchViewController.instantiate()
        let navigator = SearchViewNavigator(navigationController: navigationController)
        let useCase = SearchViewUseCase()
        let viewModel = SearchViewModel(usecase: useCase,
                                        navigator: navigator,
                                        keyWord: query,
                                        typeSearch: .searchIngredient)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
