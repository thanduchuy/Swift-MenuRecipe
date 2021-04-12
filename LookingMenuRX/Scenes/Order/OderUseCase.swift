import Foundation
import RxSwift
import RxCocoa

protocol OrderUseCaseType {
    func addOrder(order: Order) -> Observable<Void>
}

struct OrderUseCase: OrderUseCaseType {
    func addOrder(order: Order) -> Observable<Void> {
        let repository = OrderRepository()
        return repository.addOrder(order: order).andThen(Observable.just(()))
    }
}
