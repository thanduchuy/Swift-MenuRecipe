import Foundation
import ObjectMapper
import Then

struct ResultSearchByIngredients {
    var id: Int
    var title: String
    var image: String
    var likes: Int
}

extension ResultSearchByIngredients {
    init() {
        self.init(
            id: 0,
            title: "",
            image: "",
            likes: 0
        )
    }
}

extension ResultSearchByIngredients: Then, Hashable {
    
}

extension ResultSearchByIngredients: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        image <- map["image"]
        likes <- map["likes"]
    }
}
