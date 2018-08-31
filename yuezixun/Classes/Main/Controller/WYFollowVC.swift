//
//  WYFollowVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit
import WebKit

class WYFollowVC: WYBaseViewController {
    
    public var webUrl: String?
    public var showTabbar = false
    public var showNavbar = false
    
    private lazy var userContent = WKUserContentController.init()
    
    private lazy var webview: WKWebView = {
        
        let configuration = WKWebViewConfiguration.init()
        configuration.userContentController = self.userContent
        setupJSmethod()
        configuration.allowsInlineMediaPlayback = false
        
        var webview = WKWebView(frame: view.bounds, configuration: configuration)
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.sizeToFit()
        return webview
    }()
    
    func setupJSmethod() {
        userContent.add(self, name: "shareBase64Img")
        userContent.add(self, name: "jumpWeburl")
        userContent.add(self, name: "closeWeb")
        userContent.add(self, name: "copyText")
        userContent.add(self, name: "getShareData")
        userContent.add(self, name: "toShare")
        userContent.add(self, name: "clickLookAll")
        userContent.add(self, name: "lookAll")
        userContent.add(self, name: "apprenticeShare")
    }
    
    deinit {
        self.userContent.removeScriptMessageHandler(forName: "shareBase64Img")
        self.userContent.removeScriptMessageHandler(forName: "jumpWeburl")
        self.userContent.removeScriptMessageHandler(forName: "closeWeb")
        self.userContent.removeScriptMessageHandler(forName: "copyText")
        self.userContent.removeScriptMessageHandler(forName: "getShareData")
        self.userContent.removeScriptMessageHandler(forName: "toShare")
        self.userContent.removeScriptMessageHandler(forName: "clickLookAll")
        self.userContent.removeScriptMessageHandler(forName: "lookAll")
        self.userContent.removeScriptMessageHandler(forName: "apprenticeShare")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !showNavbar {
            navigationController?.navigationBar.isHidden = true
        }
        //设置状态栏样式
        WYCommonTool.setStatusBarBackgroundColor(color: ThemeColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !showNavbar {
            navigationController?.navigationBar.isHidden = false
        }
        //设置状态栏样式
        WYCommonTool.setStatusBarBackgroundColor(color: .clear)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showTabbar {
            title = "收徒"
            
            let allAppData = UserDefaults.standard.object(forKey: YZX_AllAppData) as! NSDictionary
            let domain: String = (allAppData["domain"] as? String) ?? BASE_URL
            webUrl = domain + "/artDetail/index.html#/apprentice?fid=1&os=iOS&uid=\(UserInfoManager.sharedManager.getUidStr())"
        }

        view.addSubview(webview)
        view.makeToastActivity(.center)
        
        if var urlStr = webUrl {
            
            let customAllowedSet = NSCharacterSet(charactersIn: "").inverted
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
            
            let url = URL(string: urlStr)
            let request = URLRequest(url: url!)
            webview.load(request)
        }
        
        
    }
}

extension WYFollowVC : WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideToastActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        view.hideToastActivity()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
            case "shareBase64Img":
                shareImage(body: message.body)
            case "jumpWeburl":
                shareImage(body: message.body)
            case "closeWeb":
                backClick()
            case "copyText":
                shareImage(body: message.body)
            case "getShareData":
                shareImage(body: message.body)
            case "toShare":
                shareImage(body: message.body)
            case "clickLookAll":
                shareImage(body: message.body)
            case "lookAll":
                shareImage(body: message.body)
            case "apprenticeShare":
                shareImage(body: message.body)
            default: return
        }
    }
    func shareImage(body: Any) {
        
    }
    
}
