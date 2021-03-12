import Foundation
import ObjectMapper
import Then

struct Equipments {
    var equipment: [Detail]
}

extension Equipments {
    init() {
        self.init(equipment: [Detail]())
    }
}

extension Equipments: Then, Hashable {
    
}

extension Equipments: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        equipment <- map["equipment"]
    }
}
