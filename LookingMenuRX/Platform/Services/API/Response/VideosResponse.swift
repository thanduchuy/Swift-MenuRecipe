import Foundation
import ObjectMapper
import Then

struct Videos {
    var videos: [Video]
}

extension Videos {
    init() {
        self.init(videos: [Video]())
    }
}

extension Videos: Then, Hashable {
    
}

extension Videos: BaseModel {

    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        videos <- map["videos"]
    }
}
