import Foundation
import ObjectMapper
import Then

struct RecipeDiet: Codable {
    var id: Int
    var title: String
    var image: String
}

extension RecipeDiet {
    init() {
        self.init(
            id: 0,
            title: "",
            image: ""
        )
    }
}

extension RecipeDiet: Then, Hashable {
    
}

extension RecipeDiet: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
    }
}
