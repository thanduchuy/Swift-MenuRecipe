//
//  RealmRecipeDiet.swift
//  LookingMenuRX
//
//  Created by Huy Than Duc on 10/04/2021.
//

import Foundation
import RealmSwift

class RealmRecipeDiet: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
}
