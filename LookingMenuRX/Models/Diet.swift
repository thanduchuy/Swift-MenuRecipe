import Foundation
import ObjectMapper
import Then

struct Diet {
    var id: Int = 1
    var name: String
    var recipeSessions: [RecipeSession]
}

extension Diet {
    init() {
        self.init(id: 0,
                  name: "",
                  recipeSessions: [RecipeSession]()
        )
    }
}

extension Diet: Then, Hashable {
    
}

extension Diet: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        recipeSessions <- map["recipeSessions"]
    }
}
