//
//  OrderRepository.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 12/04/2021.
//
import RxSwift
import Foundation

protocol OrderRepositoryType {
    func addOrder(order: Order) -> Completable
    func getOrder() -> Observable<[Order]>
}

struct OrderRepository: OrderRepositoryType {
    func addOrder(order: Order) -> Completable {
        FirebaseService.share.addOrder(order: order)
    }
    
    func getOrder() -> Observable<[Order]> {
        return FirebaseService.share.readOrder()
    }
}
