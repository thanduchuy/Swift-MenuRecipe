import Foundation
import ObjectMapper
import Then

struct Information {
    var readyInMinutes: Int
    var servings: Int
    var pricePerServing: Float
    var analyzedInstructions: [Steps]
}

extension Information {
    init() {
        self.init(
            readyInMinutes: 0,
            servings: 0,
            pricePerServing: 0.0,
            analyzedInstructions: [Steps]()
        )
    }
}

extension Information: Then, Hashable {
    
}

extension Information: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        readyInMinutes <- map["readyInMinutes"]
        servings <- map["servings"]
        pricePerServing <- map["pricePerServing"]
        analyzedInstructions <- map["analyzedInstructions"]
    }
}
