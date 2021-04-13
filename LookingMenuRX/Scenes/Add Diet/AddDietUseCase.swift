import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol AddDietUseCaseType {
    func calculatorCalor(height: String,
                         weight: String,
                         age: String,
                         genre: Bool,
                         activity: Activities) -> Double
    func getRecipeDiet(calor: Double) -> Observable<[RecipeDiet]>
    func createRecipeDietForSession(list: [RecipeDiet]) -> [RecipeSession]
    func getDietSessionMenu(list: inout [RecipeDiet]) -> [RecipeDiet]
    func addDiet(diet: Diet) -> Observable<Void>
}

struct AddDietUseCase: AddDietUseCaseType {
    let recipeRepository = RecipeRepository()
    let dietRepository = DietRepository()
    
    func getRecipeDiet(calor: Double) -> Observable<[RecipeDiet]> {
        let request = RecipesNutrientRequest(calor: calor)
        return recipeRepository.getRecipeNutrient(input: request)
    }
    
    func calculatorCalor(height: String,
                         weight: String,
                         age: String,
                         genre: Bool,
                         activity: Activities) -> Double {
        let calorByHeight = ConstantCalor.calorieHeight * Double((height as NSString).integerValue)
        let calorByWeight = ConstantCalor.calorieWeight * Double((weight as NSString).integerValue)
        let calorByAge = ConstantCalor.calorieAge * Int((age as NSString).integerValue)
        let calorByGenre = genre ? ConstantCalor.calorieFemale : ConstantCalor.calorieMale
        let calorPre = calorByHeight + calorByWeight - Double(calorByAge) + Double(calorByGenre)
        
        return calorPre * activity.activityValue
    }
    
    func createRecipeDietForSession(list: [RecipeDiet]) -> [RecipeSession] {
        var result = [RecipeSession]()
        var listRecipe = list
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        for element in 1..<8 {
            let nextDay = DateComponents(year: now.year, month: now.month, day: (now.day ?? 1) + element )
            guard let date = Calendar.current.date(from: nextDay) else { return result }
            let recipes = getDietSessionMenu(list: &listRecipe)
            let realmRecipe: [RealmRecipeDiet] = recipes.map {
                let recipe = RealmRecipeDiet()
                recipe.id = $0.id
                recipe.image = $0.image
                recipe.title = $0.title
                return recipe
            }
            
            let list = List<RealmRecipeDiet>()
            
            realmRecipe.forEach {
                list.append($0)
            }
            
            let recipeSession = RecipeSession()
            recipeSession.date = date
            recipeSession.recipes = list
            result.append(recipeSession)
        }
        return result
    }
    
    func getDietSessionMenu(list: inout [RecipeDiet]) -> [RecipeDiet] {
        var result = [RecipeDiet]()
        for _ in 0..<3 {
            let random = Int.random(in: 0..<list.count)
            result.append(list[random])
            list.remove(at: random)
        }
        return result
    }
    
    func addDiet(diet: Diet) -> Observable<Void> {
        return dietRepository.addDiet(diet: diet).andThen(.just(()))
    }
}
