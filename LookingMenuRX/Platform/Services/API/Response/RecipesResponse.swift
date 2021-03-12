import Foundation
import ObjectMapper
import Then

struct Recipes {
    var recipes: [Recipe]
}

extension Recipes {
    init() {
        self.init(recipes: [Recipe]())
    }
}

extension Recipes: Then, Hashable {
    
}

extension Recipes: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        recipes <- map["recipes"]
    }
}
