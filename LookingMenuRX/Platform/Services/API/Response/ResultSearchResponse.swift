import Foundation
import ObjectMapper
import Then

struct ResultSearch {
    var results: [Recipe]
    var totalResults: Int
}

extension ResultSearch {
    init() {
        self.init(
            results: [Recipe](),
            totalResults: 0
        )
    }
}

extension ResultSearch: Then, Hashable {
    
}

extension ResultSearch: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
        totalResults <- map["totalResults"]
    }
}

extension ResultSearch: Equatable {
    static func == (lhs: ResultSearch, rhs: ResultSearch) -> Bool {
        return lhs.totalResults == rhs.totalResults
            && lhs.results == rhs.results
    }
}
