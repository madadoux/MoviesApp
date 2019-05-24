
import Foundation
import ObjectMapper

struct Photos : Mappable {
	var page : Int?
	var pages : Int?
	var perpage : Int?
	var total : String?
	var photo : [Photo]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		page <- map["page"]
		pages <- map["pages"]
		perpage <- map["perpage"]
		total <- map["total"]
		photo <- map["photo"]
	}

}
