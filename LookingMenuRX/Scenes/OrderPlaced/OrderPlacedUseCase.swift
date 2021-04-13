//
//  OrderPlacedUseCase.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 13/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol OrderPlaceUseCaseType {
    func featchData() -> Observable<[Order]>
}

struct OrderPlaceUseCase: OrderPlaceUseCaseType {
    func featchData() -> Observable<[Order]> {
        let repository = OrderRepository()
        return repository.getOrder()
    }
}
