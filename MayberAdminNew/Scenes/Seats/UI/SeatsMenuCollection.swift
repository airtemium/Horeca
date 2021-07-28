//
//  SeatsMenuCollection.swift
//  MayberAdminNew
//
//  Created by Airtemium on 30.05.2021.
//

import Foundation
import UIKit

protocol SeatsMenuCollectionManipulationDelegate
{
    func SeatsMenuCollectionDelegateOffsetUp()
    
    func SeatsMenuCollectionDelegateOffsetDown()
}

protocol SeatsMenuCollectionDelegate
{
    func getItemsCount() -> Int
    
    func getItemByIdx(idx: Int) -> SeatsMenuItemModel
    
    func showCategoryItemsBy(categoryUID: String)
    
    func anyActionForMenuItem(uid: String, location: CGPoint, size: CGSize)
    
    func showActionForMenuItem(uid: String)
    
    func showDrinksCategory()
}

class SeatsMenuCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    private var _blockHeight: CGFloat = 90
    
    var delegate: SeatsMenuCollectionDelegate?
    
    var manipulationDelegate: SeatsMenuCollectionManipulationDelegate?
    
    var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.itemSize = CGSize(width: ScreenSize.SCREEN_WIDTH / 2, height: 90)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 0)
                
        var cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        cv.backgroundColor = UIColor.clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.reorderingCadence = .immediate
        cv.layoutMargins = UIEdgeInsets.zero
        return cv
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                        
        self.backgroundColor = UIColor.black
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SeatsMenuItemCell.self, forCellWithReuseIdentifier: "seatsMenuItemCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ReloadData()
    {
        self.collectionView.reloadData()
    }
    
    //---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        guard let d = self.delegate else {
            return CGSize(width: ScreenSize.SCREEN_WIDTH / 2, height: 90)
        }
        
        let item = d.getItemByIdx(idx: indexPath.row)
        
        if(indexPath.row == 0 && item.Type == .DrinkCategory)
        {
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 90)
        }
        else
        {
            return CGSize(width: ScreenSize.SCREEN_WIDTH / 2, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let d = self.delegate else {
            return 0
        }

        return d.getItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let d = self.delegate else {
            return SeatsMenuItemCell()
        }
        
        let item = d.getItemByIdx(idx: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatsMenuItemCell", for: indexPath) as? SeatsMenuItemCell
        cell?.delegate = self
        cell?.Configure(item: item)
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        print("*** scrollViewDidScroll \(self.collectionView.contentOffset.y)")
        
//        guard let d = self.manipulationDelegate else {
//            return
//        }
        
//        if(self.collectionView.contentOffset.y >= _blockHeight * 2)
//        {
//            d.SeatsMenuCollectionDelegateOffsetUp()
//        }
//        else if(self.collectionView.contentOffset.y <= _blockHeight * 2)
//        {
//            d.SeatsMenuCollectionDelegateOffsetDown()
//        }
    }
}

extension SeatsMenuCollection: SeatsMenuItemCellDelegate
{
    func showDrinksCategory()
    {
        guard let d = self.delegate else {
            return
        }
        
        d.showDrinksCategory()
    }
    
    func getSuperView() -> UIView?
    {
        return self.superview
    }
    
    func showActionForMenuItem(uid: String)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.showActionForMenuItem(uid: uid)
    }
    
    func showCategoryItemsBy(categoryUID: String)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.showCategoryItemsBy(categoryUID: categoryUID)
    }
    
    func anyActionForMenuItem(uid: String, location: CGPoint, size: CGSize)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.anyActionForMenuItem(uid: uid, location: location, size: size)
    }
}
