//
//  UILabel+Category.swift
//  yuezixun
//
//  Created by gcl on 2018/8/27.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

extension UILabel{
    
    /// 快速创建一个UILabel
    class func createLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }
    
    class func createCenterLabel(color: UIColor, fontSize: CGFloat) -> UILabel
    {
        let label = UILabel.createLabel(color: color, fontSize: fontSize)
        label.textAlignment = .center
        return label
    }
}

extension UIView{
    
    /// 快速创建一个UILabel
    class func createLineView(frame: CGRect,color: UIColor) -> UIView
    {
        let line = UIView(frame: frame)
        line.backgroundColor = color
        return line
    }
}
