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
}

struct OrderNavigation: OrderNavigationType {
    unowned let navigationController: UINavigationController
    
    func goBackView() {
        navigationController.popViewController(animated: true)
    }
}
