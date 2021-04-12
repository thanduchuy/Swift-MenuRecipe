//
//  Order.swift
//  LookingMenuRX
//
//  Created by than.duc.huy on 12/04/2021.
//

import Foundation

struct Order: Codable {
    let nameUser: String
    let imageFood: String
    let address: String
    let phone: String
    let priceFood: Int
    let amount: Int
    let titleFood: String
    let total: Int
    let status: String
    let idDevice: String
}
