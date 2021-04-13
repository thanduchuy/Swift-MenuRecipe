import Foundation
import RxSwift

protocol FavouriteRepositoryType {
    func addFavouriteRecipe(recipe: Recipe) -> Completable
    func deleteFavouriteRecipe(idRecipe: Int) -> Completable
    func checkFavouriteRecipe(idRecipe: Int) -> Observable<Bool>
    func getAllFavouriteRecipe() -> Observable<[RecipeFavourite]>
}

struct FavouriteRepository: FavouriteRepositoryType {
    func addFavouriteRecipe(recipe: Recipe) -> Completable {
        RealmService.share.insertRecipeFavourite(recipe: recipe)
    }
    
    func deleteFavouriteRecipe(idRecipe: Int) -> Completable {
        RealmService.share.deleteRecipeFavourite(idRecipe: idRecipe)
    }
    
    func getAllFavouriteRecipe() -> Observable<[RecipeFavourite]> {
        RealmService.share.fetchDataFavourite()
    }
    
    func checkFavouriteRecipe(idRecipe: Int) -> Observable<Bool> {
        RealmService.share.checkRecipeFavourite(idRecipe: idRecipe)
    }
}
