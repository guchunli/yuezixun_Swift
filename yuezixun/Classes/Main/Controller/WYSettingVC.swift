//
//  WYSettingVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/30.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYSettingVC: WYBaseViewController {
    
    private let cellID = "WYSettingCell"
    var titleArr: [[String]]?
    lazy var tableView: UITableView = {
        
        var tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        //group时，frame不能设置为CGRectZero,否则顶部有多余高度
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        titleArr = [["清除缓存","检查更新"],["隐私协议","联系我们"],["退出登录"]]
        
        view.addSubview(tableView)
    }

}

extension WYSettingVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr:[String] = titleArr?[section] ?? []
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == titleArr!.count-1 {
            
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
            let logoutLab = UILabel(frame: cell.bounds)
            logoutLab.textColor = ThemeColor
            logoutLab.textAlignment = .center
            logoutLab.text = titleArr![indexPath.section][indexPath.row]
            cell.contentView.addSubview(logoutLab)
            return cell
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textColor = UIColor(hexString: "#444444")!
            
        }
        let arr = titleArr![indexPath.section]
        if indexPath.row != arr.count-1 {
            let line = UIView.createLineView(frame: CGRect(x: 15, y: 43, width: SCREEN_WIDTH-30, height: 1), color: LineColor)
            cell?.contentView.addSubview(line)
        }
        cell?.textLabel?.text = arr[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == titleArr!.count-1 {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            cleanCache()
        }else if indexPath.section == 0 && indexPath.row == 1 {
            checkUpdate()
        }else if indexPath.section == 1 && indexPath.row == 0 {
            privateProtocal()
        }else if indexPath.section == 1 && indexPath.row == 1 {
            contactUs()
        }else if indexPath.section == 2 && indexPath.row == 0 {
            logout()
        }
    }
    
    private func cleanCache() {
        
    }
    
    private func checkUpdate() {
        
        
    }
    private func privateProtocal() {
        let followVC = WYFollowVC()
        followVC.webUrl = BASE_URL + WY_Mine_Protocal
        navigationController?.pushViewController(followVC, animated: true)
    }
    private func contactUs() {
        
        
        
    }
    private func logout() {
        
        let alertC = UIAlertController(title: "提示", message: "确定退出登录吗", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alertC.addAction(cancelAction)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
            DispatchQueue.main.async {
                let newfeatureVC = WYNewFeatureVC()
                let appDele = UIApplication.shared.delegate as! AppDelegate
                appDele.window?.rootViewController = newfeatureVC
            }
        }
        alertC.addAction(sureAction)
        present(alertC, animated: true, completion: nil)
        
    }
}
