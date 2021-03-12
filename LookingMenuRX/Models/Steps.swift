import Foundation
import ObjectMapper
import Then

struct Steps {
    var steps: [Step]
}

extension Steps {
    init() {
        self.init(steps: [Step]())
    }
}

extension Steps: Then, Hashable {
    
}

extension Steps: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        steps <- map["steps"]
    }
}
