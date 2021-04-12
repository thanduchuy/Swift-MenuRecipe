//
//  FirebaseService.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 12/04/2021.
//
import FirebaseDatabase
import Foundation
import RxSwift

struct FirebaseService {
    static let share = FirebaseService()
    private let database = Database.database().reference()
    
    func addOrder(order: Order) -> Completable {
        return Completable.create { complete in
            let dictionary: [String: Any] = [
                "nameUser": order.nameUser,
                "imageFood": order.imageFood,
                "address": order.address,
                "phone": order.phone,
                "priceFood": order.priceFood,
                "titleFood": order.titleFood,
                "idDevice": order.idDevice,
                "total": order.total,
                "amount": order.amount,
                "status": order.status,
            ]
            var key = database.childByAutoId().key as? String ?? ""
            database.child("Order").child(key).setValue(dictionary)
            complete(.completed)
            
            return Disposables.create()
        }
    }
    
    func readOrder() -> Observable<[Order]> {
        return Observable.create { observer in
            database.child("Order").observeSingleEvent(of: .value) { snapshot in
                guard let values = snapshot.value as? [String: Any] else { return }
                
                var orders = [Order]()
                for (_, value) in values {
                    guard let order = value as? [String: Any] else { return }
                    let address = order["nameUser"] as? String ?? ""
                    let imageFood = order["imageFood"] as? String ?? ""
                    let phone = order["phone"] as? String ?? ""
                    let nameUser = order["nameUser"] as? String ?? ""
                    let status = order["status"] as? String ?? ""
                    let titleFood = order["titleFood"] as? String ?? ""
                    let amount = order["amount"] as? Int ?? 0
                    let priceFood = order["priceFood"] as? Int ?? 0
                    let total = order["total"] as? Int ?? 0
                    let idDevice = order["idDevice"] as? String ?? ""
                    
                    orders.append(Order(nameUser: nameUser,
                                        imageFood: imageFood,
                                        address: address,
                                        phone: phone,
                                        priceFood: priceFood,
                                        amount: amount,
                                        titleFood: titleFood,
                                        total: total,
                                        status: status,
                                        idDevice: idDevice))
                }
                observer.onNext(orders)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
