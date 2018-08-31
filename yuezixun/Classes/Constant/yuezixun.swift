//
//  yuezixun.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

/** 设备相关 **/
let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height
let StatusBarH: CGFloat = UIApplication.shared.statusBarFrame.size.height
let NavBarH: CGFloat = 44.0
let TabbarH: CGFloat = StatusBarH > 20 ? 83.0 : 49.0
let SystemTopH: CGFloat = (CGFloat(StatusBarH) + CGFloat(NavBarH))
let SCREEN_VIEW_HEIGHT: CGFloat = (SCREEN_HEIGHT - CGFloat(SystemTopH) - CGFloat(TabbarH))

let IS_IPHONE_X: Bool = (UIScreen.main.bounds.size.height == 812.0)
let BottomInset: CGFloat = (IS_IPHONE_X ? 34.0 : 0)

/** 适配 **/
let KScaleWidth: CGFloat = SCREEN_WIDTH/375.0
let KScaleHeight: CGFloat = SCREEN_HEIGHT/667.0
//比例宽度
func KSuitW(size:CGFloat) -> CGFloat {
    return (size*KScaleWidth)
}
//比例字体
func KFontSize(fontSize:CGFloat) -> CGFloat {
    return KSuitW(size: fontSize)
}
func BCFont(fontSize:CGFloat) -> UIFont {
    return UIFont.init(name: "DINMittelschrift", size: fontSize) ?? UIFont()
}
func KFont(fontSize:CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: KFontSize(fontSize: fontSize))
}


/** 颜色定义 **/
//=available(iOS 11.0, *)
let TitleColor = UIColor.init(hexString: "#333333")!
let TextColor = UIColor.init(hexString: "#666666")!
let TipColor = UIColor.init(hexString: "#999999")!

let BackGray = UIColor.init(hexString: "#f6f9fb")!
let LineColor = UIColor.init(hexString: "#efefef")!
let ThemeColor = UIColor.init(hexString: "#DA4453")!


enum WYChildVCMediaType : UInt {
    case Art = 1
    case Video
}


/** 常量 **/
let YZX_User_FileName         = "WYUser.plist"
let YZX_Default_UserID        = 10000083
let YZX_AllAppData            = "AllAppData"

/** 账号相关 **/
//微信APPID
let WX_AppID                = "wx335b02bc0fb2301f"
let WX_AppSecret            = "5d43b7a36eb0dfd7e7da935171de88e4"

