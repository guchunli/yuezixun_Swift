//
//  WYMineVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYMineVC: WYBaseViewController {
    
    private let cellID = "WYMineCell"
    private let colNum:CGFloat = 3.0
    private var itemW:CGFloat = 0.0
    
    var menu:[WYMineModel]?
//    var nameLab: UILabel?
//    var IDLab: UILabel?
    var moneyLab: UILabel!
    var numLab: UILabel!
    
    private lazy var mainScrollView: UIScrollView = {
        var scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_VIEW_HEIGHT))
        scrollView.backgroundColor = BackGray
        scrollView.es.addPullToRefresh {
            self.loadData()
        }
        return scrollView
    }()
    
    private lazy var adView: UIView = {
        var adView = UIView.init(frame: view.bounds)
        
        return adView
    }()
    
    private lazy var topView: UIView = {
        var topView = UIView(frame: .zero)
        
        //head
        let headView = UIView.init()
        headView.backgroundColor = ThemeColor
        topView.addSubview(headView)
        
        let headImgView = UIImageView()
        headView.addSubview(headImgView)
        
        let nameLab = UILabel.createCenterLabel(color: UIColor.white, fontSize: 13)
        headView.addSubview(nameLab)
        
        let IDLab = UILabel.createCenterLabel(color: UIColor.white, fontSize: 11)
        IDLab.backgroundColor = UIColor(hexString: "#B53541")
        IDLab.layer.borderColor = UIColor(hexString: "#FC6B80")?.cgColor
        IDLab.layer.borderWidth = 1.0
        headView.addSubview(IDLab)
        
        //shadow
        let shadowView = UIView(frame: .zero)
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 5;
        shadowView.layer.shadowOpacity = 0.2;   //阴影透明度,默认为0则看不到阴影
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        topView.addSubview(shadowView)
        
        let moneyTitleLab = UILabel.createCenterLabel(color: TextColor, fontSize: 13)
        shadowView.addSubview(moneyTitleLab)
        
        let numTitleLab = UILabel.createCenterLabel(color: TextColor, fontSize: 13)
        shadowView.addSubview(numTitleLab)
        
        moneyLab = UILabel.createCenterLabel(color: ThemeColor, fontSize: 21)
        shadowView.addSubview(moneyLab)
        
        numLab = UILabel.createCenterLabel(color: ThemeColor, fontSize: 21)
        shadowView.addSubview(numLab)
        
        let line = UIView.createLineView(frame: CGRect.zero, color: LineColor)
        shadowView.addSubview(line)
        
        //ad
//        topView.addSubview(adView)
        
        ///value
        let user = UserInfoManager.sharedManager.getUser()
        let urlStr = user.headimgurl
        let imgData = try? Data(contentsOf: URL(string: urlStr!)!)
        if let data = imgData {
            headImgView.image = UIImage.init(data: data)
        }else {
            headImgView.image = UIImage(named: "head_noLogin")
        }
        nameLab.text = user.nickname ?? "游客"
        let inviteCode = user.invite_code ?? "xxxxxx"
        IDLab.text = "邀请码：" + inviteCode
        moneyTitleLab.text = "今日收益"
        numTitleLab.text = "当前余额"
        
        ///frame
        let imgH:CGFloat = 65
        headImgView.layer.cornerRadius = imgH*0.5
        headImgView.layer.masksToBounds = true
        headImgView.frame = CGRect(x: (SCREEN_WIDTH-imgH)*0.5, y: 10, width: imgH, height: imgH)
        nameLab.frame = CGRect(x: 0, y: headImgView.frame.maxY, width: SCREEN_WIDTH, height: 30)
        let idH:CGFloat = 16
        let idW = ((IDLab.text?.widthForText(fontSize: 11))!+10)
        IDLab.layer.cornerRadius = idH*0.5
        IDLab.layer.masksToBounds = true
        IDLab.frame = CGRect(x: (SCREEN_WIDTH-idW)*0.5, y: nameLab.frame.maxY, width: idW, height: idH)
        headView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: IDLab.frame.maxY+20)
        
        let shadowX:CGFloat = 13;
        let shadowW:CGFloat = (SCREEN_WIDTH-2*shadowX);
        let shadowH:CGFloat = 80;
        shadowView.frame = CGRect(x: shadowX , y: headView.frame.maxY+10, width: shadowW, height: shadowH)
        let labW:CGFloat = shadowW/2.0;
        let labY:CGFloat = 15;
        let labH:CGFloat = 25;
        moneyTitleLab.frame = CGRect(x: 0, y: labY, width: labW, height: labH)
        moneyLab.frame = CGRect(x: 0, y: labY+labH, width: labW, height: labH)
        numTitleLab.frame = CGRect(x: labW, y: labY, width: labW, height: labH)
        numLab.frame = CGRect(x: labW, y: labY+labH, width: labW, height: labH)
        let lineY:CGFloat = KSuitW(size: 20);
        
        line.frame = CGRect(x: (shadowW-1.0)*0.5, y: lineY, width: 1.0, height: shadowH-lineY*2)
        
//        adView.frame = CGRect(x: 0, y: 0, width: shadowView.frame.maxY, height: 0)
        
        topView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: shadowView.frame.maxY+10)
        
        return topView
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: itemW, height: itemW)
        
        var collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = LineColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WYMineCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    private class WYMineCell : UICollectionViewCell {
        
        var model: WYMineModel? {
            didSet {
                
                let urlStr = model?.image
                iconImgView.image = UIImage()
                if let _ = urlStr {
                    let url = URL(string: urlStr!)
                    if let url1 = url {
                        let imgData = try? Data(contentsOf: url1)
                        if let data = imgData {
                            iconImgView.image = UIImage.init(data: data)
                        }
                    }
                }
                titleLab.text = model?.title ?? ""
                detailLab.text = model?.text ?? ""
            }
        }
        private lazy var iconImgView : UIImageView = {
            var imgView = UIImageView()
            imgView.contentMode = .scaleAspectFit
            return imgView
        }()
        private lazy var titleLab : UILabel = {
            var lab = UILabel.createCenterLabel(color: TextColor, fontSize: 12)
            return lab
        }()
        private lazy var detailLab : UILabel = {
            var lab = UILabel.createCenterLabel(color: UIColor(hexString: "#FF4640")!, fontSize: 9)
            return lab
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .white
            
            contentView.addSubview(iconImgView)
            contentView.addSubview(titleLab)
            contentView.addSubview(detailLab)
            
            let labW = frame.size.width
            let labH = KSuitW(size:35);
            let detailH:CGFloat = 20;
            //    CGFloat imgX = (self.width-imgH)/2.0;
            //    CGFloat labY = (self.height-labH);
            //    CGFloat imgY = (labY-imgH-20)/2.0+20;
            let detailY = (frame.size.height-labH);
            titleLab.frame = CGRect(x: 0, y: frame.size.height-labH, width: labW, height: labH)
            
            let imgH = KSuitW(size: 27);
            iconImgView.frame = CGRect(x: (labW-imgH)*0.5, y: (detailY-imgH)*0.5, width: imgH, height: imgH)
            detailLab.frame = CGRect(x: 0, y: iconImgView.frame.maxY, width: labW, height: detailH)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的"
        navigationItem.rightBarButtonItem = UIBarButtonItem.createTitleBarButtonItem(title: "设置", target: self, action: #selector(settingClick))
        
        itemW = (SCREEN_WIDTH-colNum+1)/colNum

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func setup() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(topView)
        mainScrollView.addSubview(collectionView)
        collectionView.y = topView.frame.maxY
        mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: collectionView.frame.maxY)
    }
    
    @objc func settingClick() {
        let settingVC = WYSettingVC()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func loadData() {
        
        let paramsDic = [
            "fid":"1",
            "os":"iOS",
            "uid":UserInfoManager.sharedManager.getUidStr(),
        ];
        NetWorkRequest.sharedInstance.postRequest(UrlString:WY_Mine_Home, params:paramsDic, hudInView: view, success: { (response) in
            
            self.mainScrollView.es.stopPullToRefresh(ignoreDate: true)
            if let errCode = (response["err_code"] as? NSString)?.intValue {
                if errCode == 200 {
                    
                    let data = response["data"] as! NSDictionary
                    DispatchQueue.main.async {
                        self.updateViews(data:data)
                    }
                    
                }else{
                    self.view.makeToast(response["return_msg"] as? String)
                }
            }
            
        }) { (error) in
            self.mainScrollView.es.stopPullToRefresh(ignoreDate: true)
        }
    }
    
    func updateViews(data:NSDictionary) {
        
        moneyLab.text = data["income_money"] as? String ?? ""
        numLab.text = data["remain_money"] as? String ?? ""
        
//        adView.height = 0
        let menuData = data["menu"] as! [NSDictionary]
        menu?.removeAll()
        menu = [WYMineModel].deserialize(from: menuData)! as? [WYMineModel]
        let colNumInt: Int = Int(colNum)
        let itemNum: Int = menu!.count
        let rowNum: Int = itemNum % colNumInt == 0 ? itemNum/colNumInt : itemNum/colNumInt+1
        let allShouldNum:Int = rowNum*colNumInt
        
        for _ in 0..<allShouldNum-itemNum{
            menu?.append(WYMineModel())
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        collectionView.height = itemW * CGFloat(rowNum)
//        collectionView.height = collectionView.contentSize.height
        
        mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: collectionView.frame.maxY)
    }
}

extension WYMineVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WYMineCell
        if indexPath.row<(menu?.count)! {
            cell.model = menu?[indexPath.row]
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
