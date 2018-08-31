//
//  WYDownListView.swift
//  yuezixun
//
//  Created by gcl on 2018/8/28.
//  Copyright © 2018年 gcl. All rights reserved.
//

import UIKit

protocol WYDownListDelegate {
    func didSelectedDownListItem(index: Int)
    func dismissDownListView()
}

class WYDownListView: UIView {
    private let cellID = "WYDownListCell"
    let itemCol:CGFloat = 3.0
    private let collectionTop:CGFloat = 15.0
    private let itemSpacing:CGFloat = 11.0
//    private var itemWTmp: CGFloat = 0
    private var itemW: CGFloat = 0
//    private var itemHTmp: CGFloat = 0
    private var itemH: CGFloat = 33

    public var data: [WYMediaType]?
    public var delegate: WYDownListDelegate?
    var selIndex: Int = 0
    
    private lazy var downlistView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        
        var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: collectionTop, left: itemSpacing, bottom: collectionTop, right: itemSpacing)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DownListCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    private class DownListCell: UICollectionViewCell{
        
        var mediaType: WYMediaType? {
            didSet {
                titleLab.text = mediaType?.typeName
                if let clicked = mediaType?.isClicked,clicked {
                    titleLab.layer.borderColor = ThemeColor.cgColor
                    titleLab.textColor = ThemeColor
                }else {
                    titleLab.layer.borderColor = TipColor.cgColor
                    titleLab.textColor = TipColor
                }
            }
        }
        
        lazy var titleLab: UILabel = {
           
            var lab = UILabel.createLabel(color: TipColor, fontSize: 14)
            lab.frame = self.bounds
            lab.layer.cornerRadius = self.height*0.5
            lab.layer.masksToBounds = true
            lab.layer.borderColor = TipColor.cgColor
            lab.layer.borderWidth = 1.0
            lab.textAlignment = .center
            return lab
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)

            self.contentView.addSubview(titleLab)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    private lazy var tapView: UIButton = {
        
        var tapView = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        tapView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        tapView.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return tapView
    }()

    init(frame: CGRect,data: [WYMediaType]) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        
        itemW = (SCREEN_WIDTH-(itemCol+1.0)*itemSpacing)/itemCol
//        itemH = itemW*0.3
        
        addSubview(downlistView)
        addSubview(tapView)
        
        self.data = data
        downlistView.reloadData()
        downlistView.layoutIfNeeded()
//        let rowNum = CGFloat((data.count+1)/Int(itemCol))
//        var tapY = itemH*rowNum
//        tapY = tapY+itemSpacing*(rowNum-1)+2*collectionTop
//        tapY = min(tapY, frame.height)
        let tapY = downlistView.contentSize.height+2*collectionTop
        
        downlistView.height = tapY
        tapView.y = tapY
        tapView.height = self.frame.height-tapY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateSelectedBtn(index: Int) {
        selIndex = index
        downlistView.reloadData()
    }
    
    @objc func tapClick() {
        
        if delegate != nil {
            delegate!.dismissDownListView()
        }
    }
}

extension WYDownListView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DownListCell
        let mediaType = data![indexPath.row]
        if indexPath.row == selIndex {
            mediaType.isClicked = true
        }else{
            mediaType.isClicked = false
        }
        cell.mediaType = mediaType
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selIndex = indexPath.row
        downlistView.reloadData()
        
        if delegate != nil {
            delegate!.didSelectedDownListItem(index: selIndex)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: SCREEN_WIDTH, height: SCREEN_VIEW_HEIGHT-TitleScrollH)
//    }
}
