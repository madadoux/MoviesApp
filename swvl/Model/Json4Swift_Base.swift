
import Foundation
import ObjectMapper

struct MoviesResponse : Mappable {
	var movies : [Movie]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		movies <- map["movies"]
	}

}
