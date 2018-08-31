//
//  WYNewFeatureVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYNewFeatureVC: UIViewController {
    
    private lazy var agreeView: UITextView = {
        var textView = UITextView()
        let attrText = "阅资讯用户协议"
        textView.text = " 我已阅读并同意遵守"+attrText
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.delegate = self

        var mattrStr = NSMutableAttributedString(string: textView.text)
        let range = textView.text.range(of: attrText)
        let nsrange = textView.text.nsRange(from: range!)

        let attrDic:[NSAttributedStringKey : Any] = [
            .link:URL.init(string: "yuezixun://")!,
            .underlineColor:UIColor(hexString: "#FFDB58")!,
            .underlineStyle:NSUnderlineStyle.styleSingle.rawValue,
//            .foregroundColor:UIColor(hexString: "#FFDB58")!,
        ]
        mattrStr.addAttributes(attrDic, range: nsrange)

        //linkTextAttributes
//        let linkAttr:[NSAttributedStringKey : Any] = [
//            .underlineColor:UIColor(hexString: "#FFDB58")!,
//            .underlineStyle:NSUnderlineStyle.styleSingle.rawValue,
//            .foregroundColor:UIColor(hexString: "#FFDB58")!,
//        ]
//        textView.linkTextAttributes = linkAttr
        
        mattrStr.removeAttribute(NSAttributedStringKey.foregroundColor, range: nsrange)
        mattrStr.addAttribute(.foregroundColor, value: UIColor(hexString: "#FFDB58")!, range: nsrange)
        
        //attachment
        let attachment = NSTextAttachment()
        attachment.image = UIImage.init(named: "wechat_mark")
        attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        var attachAttr = NSAttributedString(attachment: attachment)
        mattrStr.insert(attachAttr, at: 0)
        textView.attributedText = mattrStr
        
        textView.attributedText = mattrStr
        
        return textView
    }()
    
    private lazy var wxLoginBtn: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage.init(named: "wechat_login"), for: .normal)
        btn.setTitle("微信登录", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#1E9203"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17)
        btn.layer.masksToBounds = true;
        btn.layer.shadowOffset = CGSize(width:6, height:6);
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(wxLoginClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var noLoginBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("随便看看>>", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(noLoginClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func wxLoginClick() {
        
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "App"
        //第三方向微信终端发送一个SendAuthReq消息结构
        if !WXApi.send(req) {
            print("weixin sendreq failed")
        }
    }
    @objc func noLoginClick() {
        UserInfoManager.sharedManager.loadAllAppConfigData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    func setupSubviews() {
        
        let bgImgView = UIImageView(frame: view.bounds)
        let bgImgName = IS_IPHONE_X ? "wechat_bg_x" : "wechat_bg"
        bgImgView.image = UIImage(named: bgImgName)
        view.addSubview(bgImgView)
        
        view.addSubview(agreeView)
        view.addSubview(wxLoginBtn)
        view.addSubview(noLoginBtn)
        
        let agreeW = (agreeView.text.widthForText(fontSize: 11)+12)
        let agreeH:CGFloat = 30
        let agreeBottom:CGFloat = IS_IPHONE_X ? 100 : 50;
        agreeView.frame = CGRect(x: (SCREEN_WIDTH-agreeW)*0.5, y: SCREEN_HEIGHT-agreeBottom-agreeH, width: agreeW, height: agreeH)
        
        let wxBtnX = KSuitW(size:80)
        let wxBtnH:CGFloat = 44
        wxLoginBtn.layer.cornerRadius = wxBtnH/2.0;
        wxLoginBtn.frame = CGRect(x: wxBtnX, y: agreeView.frame.minY-wxBtnH, width: (SCREEN_WIDTH-2*wxBtnX), height: wxBtnH)
        let noBtnW:CGFloat = noLoginBtn.titleLabel!.text!.widthForText(fontSize: 15)
        let noBtnH:CGFloat = 50
        noLoginBtn.frame = CGRect(x: (SCREEN_WIDTH-noBtnW)*0.5, y: wxLoginBtn.frame.minY-noBtnH, width: noBtnW, height: noBtnH)
    }

}

extension WYNewFeatureVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme! == "yuezixun" {
            let followVC = WYFollowVC()
            followVC.webUrl = BASE_URL + WY_Mine_Protocal
            let nav = WYBaseNavController(rootViewController: followVC)
            present(nav, animated: true, completion: nil)
//            navigationController?.pushViewController(followVC, animated: true)
            return false
        }
        return true
    }
}
