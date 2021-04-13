import RxSwift
import RxCocoa
import MGArchitecture
import NSObject_Rx
import Foundation
import RealmSwift

protocol DietUseCaseType {
    func getAllDiet() -> Observable<[Diet]>
    func getDietOnDate(recipeSession: [RecipeSession],date: Date ) -> [RealmRecipeDiet]
    func deleteDiet(id: Int) -> Observable<Void>
}

struct DietUseCase: DietUseCaseType {
    let repository = DietRepository()
    
    func deleteDiet(id: Int) -> Observable<Void> {
        return repository.deleteDiet(idDiet: id).andThen(.just(()))
    }
    
    func getAllDiet() -> Observable<[Diet]> {
        return repository.getAllDiet()
    }
    
    func getDietOnDate(recipeSession: [RecipeSession], date: Date) -> [RealmRecipeDiet] {
        var result = [RealmRecipeDiet]()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale.current
        let dateSession = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        
        recipeSession.forEach {
            if formatter.string(from: $0.date) == formatter.string(from: dateSession) {
                result = Array($0.recipes)
            }
        }
        
        return result
    }
}
