import RxSwift
import RxCocoa
import MGArchitecture
import Foundation

struct OrderViewModel {
    let navigator: OrderNavigationType
    let useCase: OrderUseCaseType
    let recipe: Recipe
}

extension OrderViewModel: ViewModel {
    struct Input {
        let loadView: Driver<Void>
        let minusTrigger: Driver<Void>
        let plusTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let textFieldTrigger: Driver<(String, String, String)>
        let orderTrigger: Driver<Void>
    }
    
    struct Output {
        @Property var recipe = Recipe()
        @Property var amount = 1
        @Property var total = 0
        @Property var activeButton = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadView
            .map { recipe }
            .do {
                output.$total.accept($0.readyInMinutes)
            }
            .drive(output.$recipe)
            .disposed(by: disposeBag)
        
        input.backTrigger
            .do(onNext: navigator.goBackView)
            .drive()
            .disposed(by: disposeBag)
        
        input.minusTrigger
            .map { output.$amount.value > 1 ? output.$amount.value - 1 : output.$amount.value }
            .do {
                output.$total.accept($0 * recipe.readyInMinutes)
            }
            .drive(output.$amount)
            .disposed(by: disposeBag)
        
        input.plusTrigger
            .map { output.$amount.value < 999 ? output.$amount.value + 1 : output.$amount.value }
            .do {
                output.$total.accept($0 * recipe.readyInMinutes)
            }
            .drive(output.$amount)
            .disposed(by: disposeBag)
        
        input.textFieldTrigger
            .map {
                [$0.0, $0.1, $0.2].allSatisfy { !$0.isEmpty }
            }
            .drive(output.$activeButton)
            .disposed(by: disposeBag)
        
        input.orderTrigger
            .withLatestFrom(input.textFieldTrigger)
            .withLatestFrom(Driver.combineLatest(output.$amount.asDriver(), output.$total.asDriver())) { textField, total in
                Order(nameUser: textField.0,
                      imageFood: recipe.image,
                      address: textField.2,
                      phone: textField.1,
                      priceFood: recipe.readyInMinutes,
                      amount: total.0,
                      titleFood: recipe.title,
                      total: total.1,
                      status: "Unapproved",
                      idDevice: UIDevice.current.identifierForVendor!.uuidString)
            }
            .flatMapLatest {
                useCase.addOrder(order: $0)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest {
                navigator.showAlert()
                    .asDriverOnErrorJustComplete()
            }
            .do { _ in
                navigator.goBackView()
            }
            .drive()
            .disposed(by: disposeBag)
        
            
        
        return output
    }
}
