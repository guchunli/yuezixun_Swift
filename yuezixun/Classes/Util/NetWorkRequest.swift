//
//  NetWorkRequest.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

/** 接口地址 **/
let BASE_URL                = "http://yzx_api.mmpei.cn/"
//微信平台获取token
//let WX_GetToken             = "https://api.weixin.qq.com/sns/userinfo"
//微信登录
let WY_Mine_Login           = "login"
//全局配置
let WY_Mine_AllApp          = "allApp"
//用户协议
let WY_Mine_Protocal        = "artDetail/index.html#/protocol"
//文章分类
let WY_Inform_ArtCate       = "artCate"
//文章列表
let WY_Inform_Art           = "art"
//文章详情
let WY_Inform_ArtDetail     = "artDetail"
//视频分类
let WY_Inform_VideoType     = "videoCate"
//视频列表
let WY_Inform_Video         = "video"
//视频详情
let WY_Inform_VideoDetail   = "videoDetail"
//获取分享信息
let WY_Inform_Share         = "share"
//上传分享结果
let WY_Inform_ShareResult   = "sharedone"
//个人中心首页
let WY_Mine_Home            = "center"
//签到领红包
let WY_Mine_SignIn          = "signIn"
//阅读奖励
let WY_Inform_ReadReward    = "reward"
//联系我们
let WY_Mine_ContactUs       = "connectUs"
//输入邀请码
let WY_Mine_InviteCode      = "goInvite"
//搜索页面
let WY_Home_SearchData      = "search"
//搜索结果
let WY_Home_SearchResult    = "searchList"
//情况全部搜索数据
let WY_Home_CleanHistory    = "deleteSearch"
//情况单条搜索数据
let WY_Home_cleanSingleData = "deleteSearchSingle"

private let NetWorkRequestShareInstance = NetWorkRequest()

class NetWorkRequest{
    class var sharedInstance:NetWorkRequest {
        return NetWorkRequestShareInstance
    }
}

extension NetWorkRequest{
    //paramer mark===get请求
    func getRequest(UrlString:String,params:[String:Any]?,hudInView:UIView?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        
        let PathUrl = BASE_URL+UrlString
        baseRequest(method: .get, UrlString: PathUrl, params: params, success: success, failure: failure, hudInView: hudInView)
    }
    
    
    //paramer mark===post请求
    func postRequest(UrlString:String,params:[String:Any],hudInView:UIView?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        
        let PathUrl = BASE_URL+UrlString
        baseRequest(method: .post, UrlString: PathUrl, params: params, success: success, failure: failure, hudInView: hudInView)
    }
    
    func abs_getRequest(UrlString:String,params:[String:Any]?,hudInView:UIView?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()) {
        baseRequest(method: .get, UrlString: UrlString, params: params, success: success, failure: failure, hudInView: hudInView)
    }
    
    //paramer mark===post请求
    func abs_postRequest(UrlString:String,params:[String:Any],hudInView:UIView?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        
        baseRequest(method: .post, UrlString: UrlString, params: params, success: success, failure: failure, hudInView: hudInView)
    }
    
    func baseRequest(method:HTTPMethod,UrlString:String,params:[String:Any]?,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->(),hudInView:UIView?) {
        //开启等待动画
        if let hudView = hudInView{
            DispatchQueue.main.async {
                hudView.makeToastActivity(.center)
            }
        }
        Alamofire.request(UrlString, method: method, parameters: params).responseJSON { (response) in
            //隐藏等待动画
            if let hudView = hudInView{
                DispatchQueue.main.async {
                    hudView.hideToastActivity()
                }
            }
            switch response.result{
            case .success(let value):
                //当响应成功时，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                if let value = response.result.value as? [String:AnyObject]{
                    
                    success(value)
                }
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                failure(error)
            }
            
        }
    }
    
    //上传图片
    func upLoadImageRequest(UrlString:String,params:[String:String],data:[Data],name:[String],success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        let headers = ["content-type":"multipart/form-data"]
        let PathUrl = BASE_URL+UrlString
        Alamofire.upload(multipartFormData: { (multipartforData) in
            let flag = params["flag"]
            let userId = params["userId"]
            multipartforData.append((flag?.data(using: String.Encoding.utf8))!, withName: "flag")
            multipartforData.append((userId?.data(using: String.Encoding.utf8))!, withName: "userId")
            for i in 0..<data.count{
                multipartforData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
            }
            
        }, to: PathUrl,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value as? [String: AnyObject]{
                        success(value)
                        let json = JSON(value)
                        print(json)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                
            }
        }
        )
    }
}
