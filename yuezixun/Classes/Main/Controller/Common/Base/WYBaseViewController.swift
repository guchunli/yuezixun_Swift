//
//  WYBaseViewController.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = BackGray
        
        if (navigationController?.viewControllers.count)!>1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem.createImageBarButtonItem(imageName: "back_white", target: self, action: #selector(backClick))
        }
    }
    
    @objc func backClick() {
        if navigationController?.viewControllers.count == 1 {
            navigationController?.dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
