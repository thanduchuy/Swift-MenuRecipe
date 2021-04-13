import Foundation
import RxSwift
import RxCocoa
import MGArchitecture
import NSObject_Rx
import Realm
import RealmSwift

struct DietViewModel {
    let usecase: DietUseCaseType
    let navigator: DietNavigatorType
}

extension DietViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let goAddDietTrigger: Driver<DietController>
        let tapDropdown: Driver<Void>
        let selectTrigger: Driver<IndexPath>
        let selectSession: Driver<Int>
        let selectDateTrigger: Driver<Date>
        let notification: Driver<Int>
        let deleteTrigger: Driver<IndexPath>
        let goDetailTrigger: Driver<Void>
        let notificationAdd: Driver<Notification>
    }
    
    struct Output {
        var diets = BehaviorRelay<[Diet]>(value: [Diet]())
        var selectDiet = BehaviorRelay<Diet>(value: Diet())
        var selectDateDiet = BehaviorRelay<[RealmRecipeDiet]>(value: [RealmRecipeDiet]())
        var selectSessionRecipe = BehaviorRelay<RealmRecipeDiet>(value: RealmRecipeDiet())
        var isDropDown = BehaviorRelay<Bool>(value: true)
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let selectIndexSession = BehaviorRelay<Int>(value: 0)
        let selectDateSession = BehaviorRelay<Date>(value: Date())
        
        input.loadTrigger
            .flatMapLatest { _ in
                usecase.getAllDiet().asDriverOnErrorJustComplete()
            }
            .do {
                output.selectDiet.accept($0.first ?? Diet())
                output.selectDateDiet.accept(Array($0.first?.recipeSessions.first?.recipes ?? List<RealmRecipeDiet>()))
            }
            .drive(output.diets)
            .disposed(by: disposeBag)
        
        input.goAddDietTrigger
            .do { navigator.goAddDietView(view: $0) }
            .drive()
            .disposed(by: disposeBag)
        
        input.tapDropdown
            .map { _ in
                !output.isDropDown.value
            }
            .drive(output.isDropDown)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectTrigger, items: output.diets.asDriver())
            .do {
                output.isDropDown.accept(true)
                output.selectDiet.accept($0)
                output.selectDateDiet.accept(usecase.getDietOnDate(recipeSession: Array(output.selectDiet.value.recipeSessions),
                                                                    date: selectDateSession.value))
                output.selectSessionRecipe.accept(output.selectDateDiet.value[selectIndexSession.value])
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.selectSession.asDriver()
            .do { selectIndexSession.accept($0) }
            .map {
                if $0 < output.selectDateDiet.value.count {
                    return output.selectDateDiet.value[$0]
                } else {
                    return RealmRecipeDiet()
                }
            }
            .drive ( output.selectSessionRecipe )
            .disposed(by: disposeBag)
        
        input.selectDateTrigger
            .do { selectDateSession.accept($0) }
            .map {
                usecase.getDietOnDate(recipeSession: Array(output.selectDiet.value.recipeSessions),
                                      date: $0)
            }
            .do {
                if $0.isEmpty {
                    navigator.showAlertError()
                    output.selectDateDiet.accept( Array(Array(output.selectDiet.value.recipeSessions).first?.recipes ?? List<RealmRecipeDiet>()))
                } else {
                    output.selectDateDiet.accept($0)
                }
                if selectIndexSession.value < output.selectDateDiet.value.count  {
                    output.selectSessionRecipe.accept(output.selectDateDiet.value[selectIndexSession.value])
                }
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.notification
            .flatMapLatest { _ in
                usecase.getAllDiet().asDriverOnErrorJustComplete()
            }
            .do {
                output.diets.accept($0)
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.deleteTrigger
            .withLatestFrom(output.diets.asDriver()) { $1[$0.row] }
            .do { (recipe) in
                output.diets.accept(output.diets.value.filter{ $0.id != recipe.id })
            }
            .flatMapLatest {
                usecase.deleteDiet(id: $0.id).asDriverOnErrorJustComplete()
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.goDetailTrigger
            .do { _ in
                let recipe = output.selectSessionRecipe.value
                navigator.goDetailView(recipe: Recipe (
                                        id: recipe.id,
                                        title: recipe.title,
                                        readyInMinutes: Int.random(in: 10...30),
                                        image: recipe.image))
            }
            .drive()
            .disposed(by: disposeBag)
        
        input.notificationAdd
            .flatMapLatest { _ in
                usecase.getAllDiet().asDriverOnErrorJustComplete()
            }
            .do {
                output.diets.accept($0)
            }
            .drive()
            .disposed(by: disposeBag)
        return output
    }
}
