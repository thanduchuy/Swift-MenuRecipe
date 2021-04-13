import RxSwift
import RxCocoa
import MGArchitecture
import Foundation

struct OrderPlacedViewModel {
    let useCase: OrderPlaceUseCaseType
}

extension OrderPlacedViewModel: ViewModel {
    struct Input {
        let loadView: Driver<Void>
    }
    
    struct Output {
        @Property var loading = true
        @Property var orderPlaces = [Order]()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.loadView
            .flatMapLatest {
                useCase
                    .featchData()
                    .asDriverOnErrorJustComplete()
            }
            .do { _ in
                output.$loading.accept(false)
            }
            .drive(output.$orderPlaces)
            .disposed(by: disposeBag)
        
        return output
    }
}
