

import Foundation
import ObjectMapper

struct Movie : Mappable {
	var title : String?
	var year : Int?
	var cast : [String]?
	var genres : [String]?
	var rating : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		title <- map["title"]
		year <- map["year"]
		cast <- map["cast"]
		genres <- map["genres"]
		rating <- map["rating"]
	}

}
