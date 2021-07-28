//
//  DetailsCoverCell.swift
//  MayberAdminNew
//
//  Created by Artem on 09.06.2021.
//

import Foundation
import UIKit
import Kingfisher

protocol DetailsCoverCellDelegate
{
    func DetailsCoverCellDelegateBack()
    
    func DetailsCoverCellDelegateGetCountInTheCategory() -> [Int]
    
    func DetailsCoverCellDelegateGetPrevItem()
    
    func DetailsCoverCellDelegateGetNextItem()
    
    func DetailsCoverCellDelegateGetPrevCategory()
    
    func DetailsCoverCellDelegateGetNextCategory()
    
}

class DetailsCoverCell: UITableViewCell
{
    var didSetupConstraints = false
    
    var delegate: DetailsCoverCellDelegate?
    
    private var _UID = ""
    
    private var _sliders = [UIView]()
    
    var cover: UIImageView = {
        var b = UIImageView()
        b.clipsToBounds = true
        b.contentMode = .scaleAspectFill
        return b
    }()
    
    var bg: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return b
    }()
    
    var categoryTitle: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.numberOfLines = 0
        l.sizeToFit()
        l.font = UIFont.boldSystemFont(ofSize: 32)
        return l
    }()
    
    var itemTitle: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.numberOfLines = 0
        l.sizeToFit()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        return l
    }()
    
    var priceTitle: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.numberOfLines = 0
        l.sizeToFit()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        return l
    }()
    
    var buttonBack: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "details_button_back"), for: .normal)
        return b
    }()
    
    var buttonLeft: UIButton = {
        var b = UIButton()
        return b
    }()
    
    var buttonRight: UIButton = {
        var b = UIButton()
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //--
        
        self.contentView.addSubview(cover)
        
        self.contentView.addSubview(bg)
        
        self.contentView.addSubview(buttonLeft)
        
        self.contentView.addSubview(buttonRight)
        
        self.contentView.addSubview(categoryTitle)
        
        self.contentView.addSubview(itemTitle)
        
        self.contentView.addSubview(priceTitle)
        
        self.contentView.addSubview(buttonBack)
        
        //--
        
        buttonBack.addAction {
            self.actionBack()
        }

        setNeedsUpdateConstraints()
        
        //-----
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.contentView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.contentView.addGestureRecognizer(swipeLeft)
        
        buttonLeft.addAction {
            self.actionLeft()
        }
        
        buttonRight.addAction {
            self.actionRight()
        }
    }
    
    @objc func swipeLeft(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.DetailsCoverCellDelegateGetNextCategory()
    }
    
    @objc func swipeRight(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.DetailsCoverCellDelegateGetPrevCategory()
    }
    
    func actionLeft()
    {
        guard let d = self.delegate else {
            return
        }
        
        d.DetailsCoverCellDelegateGetPrevItem()
    }

    func actionRight()
    {
        guard let d = self.delegate else {
            return
        }
        
        d.DetailsCoverCellDelegateGetNextItem()
    }
    
    func actionBack()
    {
        print("** DETAILS BACK 1")
        
        guard let d = self.delegate else {
            return
        }
        
        print("** DETAILS BACK 2")
        
        d.DetailsCoverCellDelegateBack()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        for i in _sliders
        {
            i.snp.removeConstraints()
            i.removeFromSuperview()
        }
        
        _sliders = [UIView]()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    override func updateConstraints()
    {
        if (!didSetupConstraints)
        {
            cover.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(394)
                make.top.equalToSuperview()
            }
            
            bg.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(394)
                make.top.equalToSuperview()
            }
            
            buttonLeft.snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(2)
                make.height.equalTo(394)
                make.top.equalToSuperview()
                make.left.equalToSuperview()
            }
            
            buttonRight.snp.makeConstraints { make in
                make.width.equalToSuperview().dividedBy(2)
                make.height.equalTo(394)
                make.top.equalToSuperview()
                make.left.equalTo(buttonLeft.snp.right)
            }
            
            buttonBack.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.top.equalToSuperview().offset(42)
                make.left.equalToSuperview().offset(18)
            }
            
            categoryTitle.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(133)
                make.left.equalToSuperview().offset(18)
            }
            
            itemTitle.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-60)
                make.left.equalToSuperview().offset(18)
            }
            
            priceTitle.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-32)
                make.left.equalToSuperview().offset(18)
            }
        }
        
        super.updateConstraints()
    }
    
    func Configure(data: IDetailBaseModel)
    {
//        print("*** DetailsCoverCell Configure")
        
        guard let item = data as? DetailCoverModel else { return }
        
        _UID = item.ItemUID
        
        guard let d = self.delegate else {
            return
        }
        
        let metaInfo = d.DetailsCoverCellDelegateGetCountInTheCategory()
        
       
        
        let url = URL(string: item.Image)
        self.cover.kf.setImage(with: url, placeholder: UIImage(named: "details_default_cover"))
        
        categoryTitle.text = item.CategoryName
        
        itemTitle.text = item.ItemName
        
        priceTitle.text = PriceWithCurrencyFormatter(price: item.Price, currency: item.Currency)
        
        
        
        // ----
        
        var slideWidth: CGFloat = 0
        
        slideWidth = (ScreenSize.SCREEN_WIDTH - 16 - 16 - (CGFloat(metaInfo[0]) * 3)) / CGFloat(metaInfo[0])
        
        var offset: CGFloat = 16
        
//        print("** SLIDERS \(metaInfo[0])")
        
        for i in _sliders
        {
            i.snp.removeConstraints()
            i.removeFromSuperview()
        }
        
        _sliders = [UIView]()
        
        for i in 1...metaInfo[0]
        {
//            print("** SLIDER \(i) \(offset) \(slideWidth)")
            
            let v = UIView()
            v.backgroundColor = UIColor.white.withAlphaComponent((i == metaInfo[1]) ? 1 : 0.37)
            self.contentView.addSubview(v)
            
            v.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(offset)
                make.width.equalTo(slideWidth)
                make.height.equalTo(2)
                make.top.equalToSuperview().offset(15)
            }
            
            _sliders.append(v)
            
            offset = offset + slideWidth + 3
        }
        
    }
}
