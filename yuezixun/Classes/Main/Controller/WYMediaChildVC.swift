//
//  WYMediaChildVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/27.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit
import ESPullToRefresh

class WYMediaChildVC: WYBaseViewController {
    private let cellID = "WYMediaChildCellID"
    
    public var mediaType:WYChildVCMediaType?
    public var typeId:String?
    var data = [WYMediaLayout]()
    var currentPage = 1
    lazy var tableView: UITableView = {
        
        var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_VIEW_HEIGHT-44), style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(WYMediaCell.self, forCellReuseIdentifier: cellID)
        
        tableView.es.addPullToRefresh {
            self.currentPage = 1
            self.data.removeAll()
            self.loadData()
        }
        
        tableView.es.addInfiniteScrolling {
            self.loadData()
        }
        
        return tableView
    }()
    
    class WYMediaCell: UITableViewCell {
        
        private lazy var imgView1: UIImageView = {
            var imgView = UIImageView()
            return imgView
        }()
        private lazy var imgView2: UIImageView = {
            var imgView = UIImageView()
            return imgView
        }()
        private lazy var imgView3: UIImageView = {
            var imgView = UIImageView()
            return imgView
        }()
        private lazy var titleLab: UILabel = {
            var lab = UILabel.createLabel(color: UIColor(hexString: "#222222")!, fontSize: 15)
            return lab
        }()
        private lazy var moneyLab: UILabel = {
            var lab = UILabel.createLabel(color: UIColor(hexString: "#222222")!, fontSize: 15)
            return lab
        }()
        
        private lazy var viewLab: UILabel = {
            var lab = UILabel.createLabel(color: UIColor(hexString: "#222222")!, fontSize: 15)
            return lab
        }()
        private lazy var shareLab: UILabel = {
            var lab = UILabel.createLabel(color: UIColor(hexString: "#222222")!, fontSize: 15)
            return lab
        }()
        
        var layout: WYMediaLayout? {
            didSet {
                imgView1.frame = layout?.imgViewF1 ?? CGRect.zero
                imgView2.frame = layout?.imgViewF2 ?? CGRect.zero
                imgView3.frame = layout?.imgViewF3 ?? CGRect.zero
                titleLab.frame = layout?.titleLabF ?? CGRect.zero
                moneyLab.frame = layout?.moneyLabF ?? CGRect.zero
                viewLab.frame = layout?.viewLabF ?? CGRect.zero
                shareLab.frame = layout?.shareLabF ?? CGRect.zero
                
                let picArr = layout?.mediaModel?.artPic
                if let artPic = picArr {
                    let imgUrl1 = artPic[0]
                    let imgData1 = try? Data(contentsOf: URL(string: imgUrl1)!)
                    if let data = imgData1 {
                        imgView1.image = UIImage.init(data: data)
                    }
                    if artPic.count == 3 {
                        
                        let imgUrl2 = artPic[1]
                        let imgData2 = try? Data(contentsOf: URL(string: imgUrl2)!)
                        if let data = imgData2 {
                            imgView2.image = UIImage.init(data: data)
                        }
                        
                        let imgUrl3 = artPic[2]
                        let imgData3 = try? Data(contentsOf: URL(string: imgUrl3)!)
                        if let data = imgData3 {
                            imgView3.image = UIImage.init(data: data)
                        }
                    }else {
                        imgView2.image = UIImage()
                        imgView3.image = UIImage()
                    }
                }
                
                titleLab.text = layout?.mediaModel?.artTitle
                moneyLab.text = layout?.mediaModel?.readPrice
                viewLab.text = "\(layout?.mediaModel?.readCount)"
                shareLab.text = layout?.mediaModel?.shareTitle
            }
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(imgView1)
            contentView.addSubview(imgView2)
            contentView.addSubview(imgView3)
            contentView.addSubview(titleLab)
            contentView.addSubview(viewLab)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class WYMediaLayout: NSObject {
        
        var imgViewF1: CGRect = .zero
        var imgViewF2: CGRect = .zero
        var imgViewF3: CGRect = .zero
        var titleLabF: CGRect = .zero
        var moneyLabF: CGRect = .zero
        var viewLabF: CGRect = .zero
        var shareLabF: CGRect = .zero
        
        var cellHeight: CGFloat = 0
        
        var mediaModel: WYMediaInfo? {
            didSet {
                let picArr = mediaModel?.artPic
                if let artPic = picArr {
                    
                    
                    if artPic.count == 3 {
                        
                        titleLabF = CGRect.zero
                        viewLabF = CGRect.zero
                        cellHeight = 0

                    }else{
                        
                        cellHeight = KSuitW(size: 110.0);
                        
                        let picH: CGFloat = KSuitW(size: 84.0);
                        let picW: CGFloat = KSuitW(size: 112.0);
                        let picX: CGFloat = 16.0;
                        let picY: CGFloat = (cellHeight-picH)*0.5;
                        imgViewF1 = CGRect(x:picX, y:picY, width:picW, height:picH);
                        
                        let titleX = (imgViewF1.maxX+10);
                        let titleW = (SCREEN_WIDTH-titleX-picX);
                        let titleY = picY;
                        let shareH = KSuitW(size:25);
                        let titleH = (cellHeight-picY-titleY-shareH);
                        titleLabF = CGRect(x:titleX, y:titleY, width:titleW, height:titleH);
                        
                        let shareY = (imgViewF1.maxY-shareH);
                        var shareW:CGFloat = 0.0;
                        if let shareTitle = mediaModel?.shareTitle {
                            shareW = shareTitle.count>0 ? KSuitW(size:75):0
                        }
                        let shareX = (SCREEN_WIDTH-shareW-picX);
                        shareLabF = CGRect(x: shareX, y: shareY, width: shareW, height: shareH);
                        var pointW:CGFloat = 0.0;
                        if let price = mediaModel?.readPrice {
                            let pointTextW = price.widthForText(fontSize: 12)
                            pointW = price.count>0 ? pointTextW:0
                        }
                        moneyLabF = CGRect(x:titleX, y:shareY, width:pointW, height:shareH);
                        let viewX = moneyLabF.maxX
                        let viewW = (shareLabF.minX)-viewX;
                        viewLabF = CGRect(x:viewX, y:shareY, width:viewW, height:shareH);
                    }
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        loadData()
    }
    
    private func loadData(){
        
        guard let _ = typeId else {
            return
        }
        
        let paramsDic = [
            "fid":"1",
            "os":"iOS",
            "uid":UserInfoManager.sharedManager.getUidStr(),
            "typeID":typeId!,
            "pageNo":"\(currentPage)",
            "pageNum":"10",
            ];
        let urlStr = mediaType == WYChildVCMediaType.Art ? WY_Inform_Art : WY_Inform_Video;
        NetWorkRequest.sharedInstance.postRequest(UrlString:urlStr, params:paramsDic, hudInView: parent?.view, success: { (response) in
            
            self.tableView.es.stopPullToRefresh(ignoreDate: true)
            self.tableView.es.stopLoadingMore()
            
            if let errCode = (response["err_code"] as? NSString)?.intValue {
                if errCode == 200 {
                    
                    let data = response["data"] as! [NSDictionary]
                    let infoArr = [WYMediaInfo].deserialize(from: data)! as? [WYMediaInfo]
                    if let data = infoArr{
                        for mediaInfo in data{
                            let layout = WYMediaLayout()
                            layout.mediaModel = mediaInfo
                            self.data.append(layout)
                        }
                        DispatchQueue.main.async {
                            if data.count<10 {
                                self.tableView.es.noticeNoMoreData()
                            }else {
                                self.currentPage = self.currentPage+1
                            }
                            self.tableView.reloadData()
                        }
                    }
                    
                }else{
                    self.view.makeToast(response["return_msg"] as? String)
                }
            }
            
        }) { (error) in
            self.tableView.es.stopPullToRefresh(ignoreDate: true)
            self.tableView.es.stopLoadingMore()
        }
    }
}

extension WYMediaChildVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WYMediaCell
        cell.layout = data[indexPath.row]
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let layout = data[indexPath.row]
        if let url = layout.mediaModel?.newArtUrl {
            
            let detailVC = WYFollowVC()
            detailVC.webUrl = url
            detailVC.showNavbar = true
            detailVC.title = layout.mediaModel?.artTypName
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let layout = data[indexPath.row]
        return layout.cellHeight
    }
}
