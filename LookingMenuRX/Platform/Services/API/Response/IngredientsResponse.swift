import Foundation
import ObjectMapper
import Then

struct Ingredients {
    var ingredients: [Detail]
}

extension Ingredients {
    init() {
        self.init(ingredients: [Detail]())
    }
}

extension Ingredients: Then, Hashable {
    
}

extension Ingredients: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        ingredients <- map["ingredients"]
    }
}
