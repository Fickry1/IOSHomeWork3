//
//  ArticleModel.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import Foundation
import ObjectMapper

class ArticleModel: Mappable {
    var id: Int?
    var title: String?
    var createdDate: String?
    var description: String?
    var image: String?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["ID"]
        title <- map["TITLE"]
        createdDate <- map["CREATED_DATE"]
        description <- map["DESCRIPTION"]
        image <- map["IMAGE"]
    }

}
