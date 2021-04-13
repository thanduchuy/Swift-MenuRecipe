//
//  RealmService.swift
//  LookingMenuRX
//
//  Created by Huy Than Duc on 09/04/2021.
//

import Foundation
import RealmSwift
import RxSwift

enum ErrorRealm: Error {
    case wrongRead
    case wrongAdd
    case wrongDelete
}

struct RealmService {
    static let share = RealmService()
    
    func insertRecipeFavourite(recipe: Recipe) -> Completable {
        return Completable.create { completable in
            let realm = try! Realm()
            let recipeFavourite = RecipeFavourite()
            recipeFavourite.id = recipe.id
            recipeFavourite.image = recipe.image
            recipeFavourite.readyInMinutes = recipe.readyInMinutes
            recipeFavourite.title = recipe.title

            try! realm.write {
                realm.add(recipeFavourite)
                completable(.completed)
            }
            return Disposables.create()
        }
    }
    
    func fetchDataFavourite() -> Observable<[RecipeFavourite]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let results = realm.objects(RecipeFavourite.self)
                observer.onNext(Array(results))
                observer.onCompleted()
            } catch {
                observer.onError(ErrorRealm.wrongRead)
            }
            
            return Disposables.create()
        }
    }
    
    func checkRecipeFavourite(idRecipe: Int) -> Observable<Bool> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let results = realm.objects(RecipeFavourite.self)
                
                for element in results {
                    if element.id == idRecipe {
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
                
                observer.onNext(false)
                observer.onCompleted()
            } catch {
                observer.onError(ErrorRealm.wrongRead)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteRecipeFavourite(idRecipe: Int) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                
                for element in Array(realm.objects(RecipeFavourite.self)) {
                    if element.id == idRecipe {
                        try realm.write {
                            realm.delete(element)
                            completable(.completed)
                        }
                    }
                }
            } catch {
                completable(.error(ErrorRealm.wrongDelete))
            }
            return Disposables.create()
        }
    }
    
    func insertDiet(diet: Diet) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                
                try! realm.write {
                    realm.add(diet)
                    completable(.completed)
                }
            } catch {
                completable(.error(ErrorRealm.wrongAdd))
            }
            return Disposables.create()
        }
    }
    
    func deleteDiet(idDiet: Int) -> Completable {
        return Completable.create { completable in
            do {
                let realm = try Realm()
                let results = realm.objects(Diet.self)
                
                for element in Array(results) {
                    if element.id == idDiet {
                        try realm.write {
                            realm.delete(element)
                            completable(.completed)
                        }
                    }
                }
                
            } catch {
                completable(.error(ErrorRealm.wrongAdd))
            }
            return Disposables.create()
        }
    }
    
    func fetchDataDiet() -> Observable<[Diet]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let results = realm.objects(Diet.self)
                observer.onNext(Array(results))
                observer.onCompleted()
            } catch {
                observer.onError(ErrorRealm.wrongRead)
            }
            
            return Disposables.create()
        }
    }
}
