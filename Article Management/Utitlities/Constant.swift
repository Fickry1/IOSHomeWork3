//
//  Constant.swift
//  Article Management
//
//  Created by Sim Fickry on 12/13/16.
//  Copyright © 2016 HRD. All rights reserved.
//

import Foundation

class Constant {
    struct URL {
        static let URL_BASE = "http://120.136.24.174:1301/"
        static let ARTICLE = URL_BASE + "v1/api/articles?page=1&limit=15"
        static let UPLOAD_IMAGE = URL_BASE + "v1/api/uploadfile/single"
        static let headers = "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="
        static let contentType = "application/json; charset=utf-8"
    }
}
