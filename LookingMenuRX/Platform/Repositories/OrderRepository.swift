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
}

struct OrderRepository: OrderRepositoryType {
    func addOrder(order: Order) -> Completable {
        FirebaseService.share.addOrder(order: order)
    }
}
