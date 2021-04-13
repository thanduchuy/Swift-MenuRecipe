//
//  RecipeFavourite.swift
//  LookingMenuRX
//
//  Created by Huy Than Duc on 09/04/2021.
//

import Foundation
import RealmSwift

class RecipeFavourite: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var readyInMinutes: Int = 0
    @objc dynamic var image: String = ""
}
