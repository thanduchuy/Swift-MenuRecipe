import Foundation
import ObjectMapper
import UIKit
import Then

struct RecipeSession {
    var date: Date
    var recipes: [RecipeDiet]
    
    init(date: Date, recipes: [RecipeDiet]) {
        self.date = date
        self.recipes = recipes
    }
}

extension RecipeSession {
    init() {
        self.init(date: Date(), recipes: [RecipeDiet]())
    }
}

extension RecipeSession: Then, Hashable {
    
}

extension RecipeSession: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        date <- (map["date"], DateFormatTransform())
        recipes <- map["recipes"]
    }
}

public class DateFormatTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Double

    var dateFormat = DateFormatter()

    convenience init(_ format: String) {
        self.init()
        self.dateFormat.dateFormat = format
    }

    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }

        if let timeStr = value as? String {
            return self.dateFormat.date(from: timeStr)
        }

        return nil
    }

    open func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        }
        return nil
    }
}
