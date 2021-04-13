//
//  OrderNavigation.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 12/04/2021.
//

import Foundation
import UIKit
import RxSwift

protocol OrderNavigationType {
    func goBackView()
    func showAlert() -> Observable<Bool>
}

struct OrderNavigation: OrderNavigationType {
    unowned let navigationController: UINavigationController
    
    func goBackView() {
        navigationController.popViewController(animated: true)
    }
    
    func showAlert() -> Observable<Bool> {
        navigationController.showAlertAgree(title: "Congratulations",
                                       message: "You have placed your order successfully",
                                       style: .alert)
    }
}
