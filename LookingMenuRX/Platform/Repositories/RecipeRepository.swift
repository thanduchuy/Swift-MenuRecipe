import Foundation
import RxSwift

protocol RecipeRepositoryType {
    func getRandomRecipe(input: RandomRecipeRequest) -> Observable<[Recipe]>
    func getInfomationRecipe(input: InformationRecipeRequest) -> Observable<Information>
    func getIngredientRecipe(input: DetailIngredientRequest) -> Observable<[Detail]>
    func getEquipmentRecipe(input: DetailEquipmentRequest) -> Observable<[Detail]>
    func getRecipeNutrient(input: RecipesNutrientRequest) -> Observable<[RecipeDiet]>
}

struct RecipeRepository: RecipeRepositoryType {
    
    private let api: APIService = APIService.share
    
    func getRandomRecipe(input: RandomRecipeRequest) -> Observable<[Recipe]> {
        return api.request(input: input).map { (response: Recipes) -> [Recipe] in
            return response.recipes
        }
    }
    
    func getInfomationRecipe(input: InformationRecipeRequest) -> Observable<Information> {
        return api.request(input: input)
    }
    
    func getIngredientRecipe(input: DetailIngredientRequest) -> Observable<[Detail]> {
        return api.request(input: input).map { (response: Ingredients) -> [Detail] in
            return response.ingredients
        }
    }
    
    func getEquipmentRecipe(input: DetailEquipmentRequest) -> Observable<[Detail]> {
        return api.request(input: input).map { (response: Equipments) -> [Detail] in
            return response.equipment
        }
    }
    
    func getRecipeNutrient(input: RecipesNutrientRequest) -> Observable<[RecipeDiet]> {
        return api.requestArray(input: input)
    }
}
