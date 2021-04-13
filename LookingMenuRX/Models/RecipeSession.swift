import Foundation
import ObjectMapper
import UIKit
import Then
import RealmSwift

class RecipeSession: Object {
    @objc dynamic var date = Date()
    dynamic var recipes = List<RealmRecipeDiet>()
}
