import Foundation
import RxSwift

protocol DietRepositoryType {
    func addDiet(diet: Diet) -> Completable
    func deleteDiet(idDiet: Int) -> Completable
    func getAllDiet() -> Observable<[Diet]>
}

struct DietRepository: DietRepositoryType {
    
    func getAllDiet() -> Observable<[Diet]> {
        RealmService.share.fetchDataDiet()
    }
    
    func addDiet(diet: Diet) -> Completable {
        RealmService.share.insertDiet(diet: diet)
    }
    
    func deleteDiet(idDiet: Int) -> Completable {
        RealmService.share.deleteDiet(idDiet: idDiet)
    }
}
