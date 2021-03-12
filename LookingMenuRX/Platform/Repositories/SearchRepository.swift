import Foundation
import RxSwift

protocol SearchRepositoryType {
    func searchVideoRecipe(input: SearchVideoRequest) -> Observable<Videos>
    func searchRecipeByName(input: SearchByNameRequest) -> Observable<[Recipe]>
    func searchRecipeByIngredient(
        input: SearchRecipesIngredientRequest) -> Observable<[Recipe]>
}

struct SearchRepository: SearchRepositoryType {
    
    private let api: APIService = APIService.share
    
    func searchVideoRecipe(input: SearchVideoRequest) -> Observable<Videos> {
        return api.request(input: input)
    }
    
    func searchRecipeByName(input: SearchByNameRequest) -> Observable<[Recipe]> {
        return api.request(input: input).map{ (response: ResultSearch) -> [Recipe] in
            response.results.map { (recipe) -> Recipe in
                var result = recipe
                result.image = String(format: UrlAPIRecipe.urlImageRecipe, result.image)
                return result
            }
        }
    }
    
    func searchRecipeByIngredient(input: SearchRecipesIngredientRequest) -> Observable<[Recipe]> {
        return api.requestArray(input: input).map{ (response: [ResultSearchByIngredients]) -> [Recipe] in
            return response.map {
                Recipe(id: $0.id,
                       title: $0.title,
                       readyInMinutes: $0.likes,
                       image: $0.image)
            }
        }
    }
}
