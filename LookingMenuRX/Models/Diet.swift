import Foundation
import ObjectMapper
import Then
import RealmSwift

class Diet: Object {
    @objc dynamic var id: Int = 1
    @objc dynamic var name: String = ""
    dynamic var recipeSessions = List<RecipeSession>()
}
