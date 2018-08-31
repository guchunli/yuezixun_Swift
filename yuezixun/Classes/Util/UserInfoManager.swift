//
//  UserInfoManager.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

private let userInfoManager = UserInfoManager()
class UserInfoManager: NSObject {
    
    //单例
    class var sharedManager: UserInfoManager {
        return userInfoManager
    }
    
    func saveArchiverObject(object:WYUserModel) {
        
        //1.保存到user default中
        let userDefault = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: object as Any)
        userDefault.setValue(data, forKey: YZX_User_FileName)
        //同步数据
        userDefault.synchronize()
        
        //2.将account对象保存到本地文件
        //获取沙盒路径
//        let docPath=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let accountPath = docPath + YZX_User_FileName
//        print("路径："+accountPath);
//        //将object转换成二进制数据存到文件
//        NSKeyedArchiver.archiveRootObject(object, toFile:accountPath)
    }
    
    func loadUnarchiveWithKey() -> WYUserModel? {
        
//        //1.从user default中读取
        let userDefault = UserDefaults.standard
        guard let data = userDefault.value(forKey: YZX_User_FileName) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? WYUserModel
        
        
        //获取沙盒路径
//        let docPath=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let accountPath = docPath + YZX_User_FileName
//
//        if  FileManager.default.fileExists(atPath: accountPath){
//            let userModel =  NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as! WYUserModel
//            return userModel
//        }
//        return WYUserModel(dic: [:])
    }
    
    func isLogin() -> Bool {
        let userModel = loadUnarchiveWithKey()
        if let _ = userModel{
            return true
        }else{
            return false
        }
    }
    
    func getUser() -> WYUserModel {
        let userModel = loadUnarchiveWithKey()
        if let model = userModel{
            return model
        }else{
            return WYUserModel()
        }
    }
    
    func getUidStr() -> String {
        if isLogin() {
            let userModel = getUser()
            if let userid = userModel.uid {
                return "\(userid)"
            }else{
                return "\(YZX_Default_UserID)"
            }
        }else{
            return "\(YZX_Default_UserID)"
        }
    }
    
    func loginInServerWithCode(code:String,hudInView:UIView) {
        
        var paramsDic = [String:String]()
        let pInfo = ""
        if (code.count > 0) {
            //未登录
            paramsDic = [
                "fid":"1",
                "os":"iOS",
                "code":code,
                "openid":"",
                "unionid":"",
                "access_token":"",
                "refresh_token":"",
                "pInfo":pInfo,
            ];
        }else{
            
        }
        
        NetWorkRequest.sharedInstance.postRequest(UrlString:WY_Mine_Login, params:paramsDic, hudInView: hudInView, success: { (response) in
            
            if let errCode = (response["err_code"] as? NSString)?.intValue {
                if errCode == 200 {
                    
                    let dataDic = response["data"] as! [String : AnyObject]
                    let userModel = WYUserModel(dic: dataDic)
//                    let userModel = WYUserModel.mj_object(withKeyValues: dataDic)
                    UserInfoManager.sharedManager.saveArchiverObject(object: userModel)
                    self.loadAllAppConfigData()
                    
                }else{
                    hudInView.makeToast(response["return_msg"] as? String)
                }
            }

        }) { (error) in
            
        }

    }
    
    func loadAllAppConfigData() {
        
        let currVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? ""
        let paramsDic = [
            "fid":"1",
            "os":"iOS",
            "uid":UserInfoManager.sharedManager.getUidStr(),
            "version":currVersion,
            ]
        NetWorkRequest.sharedInstance.postRequest(UrlString:WY_Mine_AllApp, params:paramsDic, hudInView: nil, success: { (response) in
            
            if let errCode = (response["err_code"] as? NSString)?.intValue {
                if errCode == 200 {
                    
                    let dataDic = response["data"] as! [String : AnyObject]
                    UserDefaults.standard.set(dataDic, forKey: YZX_AllAppData)
                    
                    DispatchQueue.main.async {                    
                        let tabbarVC = WYBaseTabbarController()
                        let appDele = UIApplication.shared.delegate as! AppDelegate
                        appDele.window?.rootViewController = tabbarVC
                    }
                    
                }else{
//                    hudInView.makeToast(response["return_msg"] as? String)
                }
            }
            
        }) { (error) in
            
        }
    }
}
