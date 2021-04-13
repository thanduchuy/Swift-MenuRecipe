import Foundation
import RxSwift
import RxCocoa

protocol FavouriteUseCaseType {
    func getAllRecipeFavourite() -> Observable<[Recipe]>
    func deleteRecipeFavourite(id: Int) -> Observable<Void>
}

struct FavouriteUseCase: FavouriteUseCaseType {
    let repository = FavouriteRepository()
    
    func getAllRecipeFavourite() -> Observable<[Recipe]> {
        return repository.getAllFavouriteRecipe().map { $0.map { favourite in
            var recipe = Recipe()
            recipe.id = favourite.id
            recipe.image = favourite.image
            recipe.title = favourite.title
            recipe.readyInMinutes = favourite.readyInMinutes
            return recipe
        }}
    }
    
    func deleteRecipeFavourite(id: Int) -> Observable<Void> {
        return repository.deleteFavouriteRecipe(idRecipe: id).andThen(.just(()))
    }
}
