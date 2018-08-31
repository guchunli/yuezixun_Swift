//
//  WYHomeVC.swift
//  yuezixun
//
//  Created by gcl on 2018/8/25.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

class WYHomeVC: WYBaseViewController {
    
    private let TitleScrollH: CGFloat = KSuitW(size: 44)
    private let TitleScrollW: CGFloat = KSuitW(size: 60)
    private let DownListW: CGFloat = 40.0
    private let DownListShadowW: CGFloat = 15.0
    private let titleMargin: CGFloat = 5.0
    private let cellID = "WYMediaTypeCell"
    
    public var mediaType:WYChildVCMediaType?
    var typeArr: [WYMediaType]?
    var selTitleItem: UIButton?
    
    private lazy var titleScrollView: UIScrollView = {
        
        var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: (SCREEN_WIDTH-DownListW)+DownListShadowW, height: TitleScrollH))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentScrollView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        var collectionView = UICollectionView(frame:  CGRect(x: 0, y: self.titleScrollView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_VIEW_HEIGHT-TitleScrollH), collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    private lazy var downlistView: WYDownListView = {
        
        var downlistView = WYDownListView(frame: CGRect(x: 0, y: (SystemTopH+TitleScrollH), width: SCREEN_WIDTH, height: (SCREEN_HEIGHT-SystemTopH-TitleScrollH)),data: typeArr!)
        downlistView.delegate = self
        return downlistView
    }()
    
    private lazy var downlistBtn: UIButton = {
        
        let downlistBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH-DownListW), y: 0, width: DownListW, height: titleScrollView.height))
        downlistBtn.backgroundColor = UIColor.clear
        downlistBtn.setBackgroundImage(UIImage(named: "down_shadow"), for: .normal)
        downlistBtn.setBackgroundImage(UIImage(named: "down_shadow"), for: .selected)
        downlistBtn.setImage(UIImage(named: "dropDown"), for: .normal)
        downlistBtn.setImage(UIImage(named: "pullUp"), for: .selected)
        downlistBtn.contentMode = .scaleAspectFit
        downlistBtn.addTarget(self, action: #selector(downlistClick(btn:)), for: UIControlEvents.touchUpInside)
        return downlistBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "资讯"
        
        if mediaType == .Art {        
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchClick))
        }
        
        loadData()
    }
    
    @objc func searchClick() {
        showDownListView(isShow: false)
    }

    private func loadData(){
        
        let paramsDic = [
            "fid":"1",
            "os":"iOS",
            "uid":UserInfoManager.sharedManager.getUidStr(),
            ];
        let urlStr = mediaType == WYChildVCMediaType.Art ? WY_Inform_ArtCate : WY_Inform_VideoType;
        NetWorkRequest.sharedInstance.postRequest(UrlString:urlStr, params:paramsDic, hudInView: nil, success: { (response) in
            
            if let errCode = (response["err_code"] as? NSString)?.intValue {
                if errCode == 200 {
                    
                    let data = response["data"] as! [NSDictionary]
                    let typeArr = [WYMediaType].deserialize(from: data)! as? [WYMediaType]
                    if let data = typeArr{
                        self.typeArr = data
                        DispatchQueue.main.async {
                            self.setup()
                        }
                    }
                    
                }else{
                    self.view.makeToast(response["return_msg"] as? String)
                }
            }
            
        }) { (error) in
            
        }
    }
    
    private func setup() {
        
        //child vc
        for type in self.typeArr! {
            let childVC = WYMediaChildVC()
            childVC.mediaType = self.mediaType
            childVC.typeId = type.typeId
            childVC.title = type.typeName
            addChildViewController(childVC)
        }
        
        createTitleScrollView()
        view.addSubview(contentScrollView)
        
//        downlistView.data = self.typeArr
//        view.addSubview(downlistView)
//        view.bringSubview(toFront: downlistView)
    }
    
    private func createTitleScrollView() {
        
        //title
        view.addSubview(titleScrollView)
        
        var lastItem: UIButton?
        for (index, vc) in childViewControllers.enumerated() {
            let titleItem = createTitleItem(title: vc.title ?? "")
            titleItem.tag = index+100
            titleItem.x = CGFloat(index) * (TitleScrollW+titleMargin)
            titleScrollView.addSubview(titleItem)
            lastItem = titleItem
            if index == 0 {
                titleItem.isSelected = true
                selTitleItem = titleItem
            }
        }
        //下拉按钮
        view.addSubview(downlistBtn)
        
        //菜单栏下的横线
        let lineView = UIView.createLineView(frame: CGRect(x: 0, y: TitleScrollH-1.0, width: SCREEN_WIDTH, height: 1.0),color: LineColor)
        view.addSubview(lineView)
        
        titleScrollView.contentSize = CGSize(width: (lastItem?.frame.maxX)!+DownListShadowW, height: titleScrollView.height)
    }
    
    
    @objc func downlistClick(btn: UIButton) {
        
        showDownListView(isShow: !btn.isSelected)
    }
    
    func showDownListView(isShow: Bool) {
        
        downlistBtn.isSelected = isShow
        
        if isShow {
            downlistView.height = 0
            view.window?.addSubview(downlistView)
            UIView.animate(withDuration: 0.3) {
                self.downlistView.height = (SCREEN_HEIGHT-self.downlistView.y)
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.downlistView.height = 0
            }) { (anim) in
                self.downlistView.removeFromSuperview()
            }
        }
    }
    
    private func createTitleItem(title: String) -> UIButton {
        let titleItem = UIButton(frame: CGRect(x: 0, y: 0, width: TitleScrollW, height: TitleScrollH))
        titleItem.setTitle(title, for: .normal)
        let attrStr = NSAttributedString(string: (titleItem.titleLabel?.text)!, attributes: [.font: UIFont.systemFont(ofSize: 16),.foregroundColor: UIColor.init(hexString: "#8C93A0")!])
        let attrStrSel = NSAttributedString(string: (titleItem.titleLabel?.text)!, attributes: [.font: UIFont.systemFont(ofSize: 17),.foregroundColor: ThemeColor])
        titleItem.setAttributedTitle(attrStr, for: .normal)
        titleItem.setAttributedTitle(attrStrSel, for: .selected)
//        titleItem.addTarget(self, action: Selector(("itemClick:")), for: .touchUpInside)
        titleItem.addTarget(self, action: #selector(itemClick(item:)), for: .touchUpInside)
        return titleItem
    }
    @objc func itemClick(item: UIButton) {
        
        setLabelSelected(item: item)
        contentScrollView.scrollToItem(at: IndexPath(row: item.tag-100, section: 0), at: .left, animated: true)
        //更新下拉刷新选中按钮
//        downlistView.updateSelectedBtn(index: item.tag-100)
    }
    
    fileprivate func setLabelSelected(item: UIButton){
        //设置标题选中状态
        if let titleItem = selTitleItem {
            titleItem.isSelected = false
        }
        item.isSelected = true
        selTitleItem = item
        
        setLabelTitleCenter(item: item)
        
        //更新下拉刷新选中按钮
        downlistView.updateSelectedBtn(index: item.tag-100)
    }
    
    //设置选中的标题居中
    fileprivate func setLabelTitleCenter(item: UIButton) {
        
        // 设置标题滚动区域的偏移量
        var offsetX = item.center.x - SCREEN_WIDTH * 0.5;
        
        if (offsetX < 0) {
            offsetX = 0;
        }

        // 最大的标题视图滚动区域
        var maxOffsetX = titleScrollView.contentSize.width - SCREEN_WIDTH + titleMargin;

        if (maxOffsetX < 0) {
            maxOffsetX = 0;
        }

        if (offsetX > maxOffsetX) {
            offsetX = maxOffsetX;
        }
        
        // 滚动区域
        titleScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

extension WYHomeVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WYDownListDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){

        var offsetX = scrollView.contentOffset.x
        let offsetXInt = Int(offsetX);
        let screenWInt = Int(SCREEN_WIDTH);
        
        let extre = CGFloat(offsetXInt % screenWInt);
        if (extre > SCREEN_WIDTH * 0.5) {
            // 往右边移动
            offsetX = offsetX + (SCREEN_WIDTH - extre);
        }else if (extre < SCREEN_WIDTH * 0.5 && extre > 0){
            // 往左边移动
            offsetX =  offsetX - extre;
        }
        
        // 获取角标
        let tag = Int(offsetX / SCREEN_WIDTH);
        // 选中标题
        let selItem = titleScrollView.viewWithTag(tag+100) as! UIButton
        setLabelSelected(item: selItem)
        
        //更新下拉刷新选中按钮
//        downlistView.updateSelectedBtn(index: tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (typeArr?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVC = childViewControllers[indexPath.row] as! WYMediaChildVC
        cell.contentView.addSubview(childVC.view)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_VIEW_HEIGHT-TitleScrollH)
    }

    func dismissDownListView() {
        showDownListView(isShow: false)
    }
    
    func didSelectedDownListItem(index: Int) {
        
        showDownListView(isShow: false)
        
        let selItem = titleScrollView.viewWithTag(index+100) as! UIButton
        itemClick(item: selItem)
    }
    
}
