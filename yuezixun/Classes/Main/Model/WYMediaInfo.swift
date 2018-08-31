//
//  WYMediaInfo.swift
//  yuezixun
//
//  Created by gcl on 2018/8/27.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit
import HandyJSON

class WYMediaInfo: HandyJSON {
    
    var artTypID: String?
    var artTypName: String?
    var artID: String?
    var createTime: NSNumber?
    var readCount: Int = 0
    var readPrice: String?
    var shareTitle: String?
    var artTitle: String?
    var newArtUrl: String?
    var artPic: [String]?
    var artPicNum: Int = 0
    var requestID: String?
    
    var isUpload: Bool = false
    
    var artClassify: String?
    
    //HandyJSON
    required init() {}
    
//    required init?(map: Map) {
//
//    }
//
//    // Mappable
//    func mapping(map: Map) {
//        artTypID    <- map["artTypID"]
//        artTypName         <- map["artTypName"]
//        artID      <- map["artID"]
//        createTime       <- map["createTime"]
//        readCount  <- map["readCount"]
//        readPrice  <- map["readPrice"]
//        shareTitle     <- map["shareTitle"]
//        artTitle    <- map["artTitle"]
//        newArtUrl  <- map["newArtUrl"]
//        artPic  <- map["artPic"]
//        artPicNum     <- map["artPicNum"]
//        requestID    <- map["requestID"]
//
//        artClassify    <- map["artClassify"]
//    }

}
