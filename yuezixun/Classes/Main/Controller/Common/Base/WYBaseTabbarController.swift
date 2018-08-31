//
//  WYBaseTabbarController.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYBaseTabbarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置状态栏样式
//        WYCommonTool.setStatusBarBackgroundColor(color: ThemeColor)

        tabBar.barTintColor = UIColor.white;
        self.delegate = self

        setTabBarVC()
    }
    
    func setTabBarVC() {
        
        let homeVC = WYHomeVC()
        homeVC.mediaType = .Art
        self.setTabBarChildController(vc: homeVC, title: "资讯", imageStr: "tabbar_home", selectImage: "tabbar_home_sel")
        
        let videoVC = WYHomeVC()
        videoVC.mediaType = .Video
        self.setTabBarChildController(vc: videoVC, title: "视频", imageStr: "tabbar_video", selectImage: "tabbar_video_sel")
        
        let allAppData = UserDefaults.standard.object(forKey: YZX_AllAppData) as! NSDictionary
        let showActive = allAppData["activeButton"] as? NSDictionary
        if let showDic = showActive {
            let isShow = showDic["is_show"] as? NSNumber
            if let showCenter = isShow {
                if showCenter.boolValue{
                    
                    let followVC = WYFollowVC()
                    self.setTabBarChildController(vc: followVC, title: "", imageStr: "", selectImage: "")
                    
                    let icon = showDic["icon"] as! String
                    setupCenterBtn(icon: icon)
                }
            }
        }

        let showapprentice = allAppData["showapprentice"] as? NSNumber
        if let showWeb = showapprentice {
            if showWeb.boolValue {
                let followVC = WYFollowVC()
                followVC.showTabbar = true
                self.setTabBarChildController(vc: followVC, title: "收徒", imageStr: "tabbar_follow", selectImage: "tabbar_follow_sel")
            }
        }
        
        let mineVC = WYMineVC()
        self.setTabBarChildController(vc: mineVC, title: "我的", imageStr: "tabbar_mine", selectImage: "tabbar_mine_sel")
    }
    
    func setupCenterBtn(icon: String) {
        let btnW: CGFloat = 50.0,btnH: CGFloat = 50.0
        let centerBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH-btnW)*0.5, y: TabbarH-btnH-10.0, width: btnW, height: btnH))
        do {
            let imgData = try? Data(contentsOf: URL(string: icon)!)
            centerBtn.setImage(UIImage.init(data: imgData!), for: .normal)
        } catch  {
            
        }
        
//        centerBtn.addTarget(self, action: #selector(pressCenter), for: .touchUpInside)
        tabBar .addSubview(centerBtn)
    }
    
    func setTabBarChildController(vc:UIViewController,title:String,imageStr:String,selectImage:String) {
        
        let nav = WYBaseNavController(rootViewController: vc)
        nav.title = title
        if imageStr.hasPrefix("http") {
            
            let imgData = try? Data(contentsOf: URL(string: imageStr)!)
            nav.tabBarItem.image = UIImage.init(data: imgData!)
            
            let selImgData = try? Data(contentsOf: URL(string: selectImage)!)
            nav.tabBarItem.image = UIImage.init(data: selImgData!)
        }else{
            nav.tabBarItem.image = UIImage.init(named: imageStr)?.withRenderingMode(.alwaysOriginal)
            nav.tabBarItem.selectedImage = UIImage.init(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        }
        nav.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.init(hexString: "#8C93A0") ?? UIColor.black], for: .normal)
        nav.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.init(hexString: "#DF4543") ?? UIColor.black], for: .selected)
        
        addChildViewController(nav)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let nav = viewController as! WYBaseNavController
        if nav.title?.count == 0 {
            pressCenter()
            return false
        }
        return true
    }
    
    @objc func pressCenter() {
        
        let allAppData = UserDefaults.standard.object(forKey: YZX_AllAppData) as! NSDictionary
        let showActive = allAppData["activeButton"] as? NSDictionary
        if let showDic = showActive {
            let url = showDic["url"] as? String
            if let webUrl = url {
                
                let followVC = WYFollowVC()
                followVC.webUrl = webUrl
                let nav = WYBaseNavController(rootViewController: followVC)
                present(nav, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
