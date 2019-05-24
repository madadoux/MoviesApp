
import Foundation
import ObjectMapper

struct Photo : Mappable {
	var id : String?
	var owner : String?
	var secret : String?
	var server : String?
	var farm : Int?
	var title : String?
	var ispublic : Int?
	var isfriend : Int?
	var isfamily : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id <- map["id"]
		owner <- map["owner"]
		secret <- map["secret"]
		server <- map["server"]
		farm <- map["farm"]
		title <- map["title"]
		ispublic <- map["ispublic"]
		isfriend <- map["isfriend"]
		isfamily <- map["isfamily"]
	}

}
