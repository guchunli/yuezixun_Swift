//
//  UIBarButtonItem+Category.swift
//  yuezixun
//
//  Created by gcl on 2018/8/27.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    class func createImageBarButtonItem(imageName: String,target: AnyObject?,action: Selector) -> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        //自动调整大小，和图片大小相同，不用设frame
        btn.sizeToFit()
        btn .addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
    class func createTitleBarButtonItem(title: String,target: AnyObject?,action: Selector) -> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //自动调整大小
        btn.sizeToFit()
        btn .addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}
