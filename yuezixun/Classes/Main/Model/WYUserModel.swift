//
//  WYUserModel.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYUserModel: NSObject,NSCoding {
    
    //MARK:-属性
    //1.login
    var access_token:String?
    var refresh_token:String?
    var openid:String?
    var unionid:String?
    
    //2.wxinfo
    var uid:NSNumber?
    var nickname:String?
    var headimgurl:String?
    var user_show_money:NSNumber?
    var invite_code:String?
    
    //MARK:-自定义构造函数
    override init() {
        super.init()
    }
    public init(dic:[String:AnyObject])
    {
        super.init()

        access_token = dic["access_token"] as! String?
        refresh_token=dic["refresh_token"] as! String?
        openid = dic["openid"] as! String?
        unionid=dic["unionid"] as! String?
        uid = dic["uid"] as! NSNumber?
        nickname = dic["nickname"] as! String?
        headimgurl = dic["headimgurl"] as! String?
        user_show_money = dic["user_show_money"] as! NSNumber?
        invite_code = dic["invite_code"] as! String?


    }
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
    }
    
    
    //MARK: 解档 归档
    //解档的方法
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.refresh_token = aDecoder.decodeObject(forKey: "refresh_token") as? String
        self.openid = aDecoder.decodeObject(forKey: "openid") as? String
        self.unionid = aDecoder.decodeObject(forKey: "unionid") as? String
        self.uid = aDecoder.decodeObject(forKey: "uid") as? NSNumber
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        self.headimgurl = aDecoder.decodeObject(forKey: "headimgurl") as? String
        self.user_show_money = aDecoder.decodeObject(forKey: "user_show_money") as? NSNumber
        self.invite_code = aDecoder.decodeObject(forKey: "invite_code") as? String
    }
    
    //归档的方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(refresh_token, forKey: "refresh_token")
        aCoder.encode(openid, forKey: "openid")
        aCoder.encode(unionid, forKey: "unionid")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(headimgurl, forKey: "headimgurl")
        aCoder.encode(user_show_money, forKey: "user_show_money")
        aCoder.encode(invite_code, forKey: "invite_code")
    }
    
    
//    func copy(with zone: NSZone? = nil) -> Any {
//        
//        
//    }
    
    //描述类
    override var description: String {
        get{
            return "姓名：" + nickname!
        }
    }
}
