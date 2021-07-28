//
//  SeatsCarousel.swift
//  MayberAdminNew
//
//  Created by Artem on 06.07.2021.
//

import Foundation
import UIKit
import Kingfisher

protocol SeatsCarouselDelegate
{
//    func SeatsCarouselDelegateGetData()
    
    func getOrdersData(checkinUID: String, seatNumber: Int) -> [OrderItemModel]
    
    func getSeatColor(number: Int) -> UIColor
    
    func getPlaceCurrency() -> String
}

class SeatsCarousel: UIView
{
    var items = [OrderItemModel]()
    
    var delegate: SeatsCarouselDelegate!

    var seat: UIView = {
        var v = UIView()
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.cornerRadius = 59 / 2
        v.backgroundColor = UIColor.purple
        v.layer.borderWidth = 3
        return v
    }()
    
    var seatNumber: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
        return l
    }()
    
    var badge: UIView = {
        
        var b = UIView()
        b.isHidden = true
        b.backgroundColor = .red
        b.layer.cornerRadius = 24 / 2
        return b
    }()
    
    var badgeLabel: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    var carousel: iCarousel = {
        var k = iCarousel()
        k.isVertical = true
        k.type = .timeMachine
        return k
    }()
    
    var layout: UIView = {
        var v = UIView()
//        v.backgroundColor = .blue
        return v
    }()

    init()
    {
        super.init(frame: .zero)
//
//        items.append(UUID().uuidString)
//        items.append(UUID().uuidString)
//        items.append(UUID().uuidString)
//        items.append(UUID().uuidString)
//        items.append(UUID().uuidString)
            
    }
    
    func SetChoosed(seatNumber: Int, checkinUID: String)
    {
        ReloadCarousel(seatNumber: seatNumber, checkinUID: checkinUID)
    }
    
    func ReloadCarousel(seatNumber: Int, checkinUID: String)
    {
        guard let d = self.delegate else { return }
        
        self.seat.backgroundColor = d.getSeatColor(number: seatNumber)
        
        items = d.getOrdersData(checkinUID: checkinUID, seatNumber: seatNumber)
        
        if(items.count > 0)
        {
            badge.isHidden = false
            badgeLabel.text = "\(items.count)"
        }
        else
        {
            badge.isHidden = true
        }
        
        self.seatNumber.text = "\(seatNumber)"
        
        self.carousel.reloadData()
    }
    
    func Setup()
    {
                
        //rgba 1 6 19, 0.71
        
//        self.backgroundColor = UIColor(red: 1/255, green: 6/255, blue: 19/255, alpha: 1)
        self.backgroundColor = .darkGray
        
        self.addSubview(seat)
        seat.addSubview(seatNumber)
        self.addSubview(badge)
        badge.addSubview(badgeLabel)
     
        seat.setSize(59, 59)
        seat.setX(25)
        seat.setY(16)
        
        
        seatNumber.setY(0)
        seatNumber.setX(0)
        seatNumber.setSize(seat.getWidth(), seat.getHeight())

        
        badge.setSize(24, 24)
        badge.setY(seat.getY() - 3)
        badge.setX(seat.getX() + seat.getWidth() - 16)
//

        badgeLabel.setX(0)
        badgeLabel.setY(0)
        badgeLabel.setSize(badge.getWidth(), badge.getHeight())

        seatNumber.text = ""
        
        badgeLabel.text = ""

        self.addSubview(layout)
        layout.setX(40)
        layout.setY(0)
        layout.setSize(self.getWidth(), self.getHeight())
        
        layout.addSubview(carousel)
//        carousel.setX(0)
//        carousel.setY(0)
        carousel.setSize(layout.getWidth(), layout.getHeight())
        carousel.toCenterY(layout)
        carousel.toCenterX(layout)

        carousel.delegate = self
        carousel.dataSource = self

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SeatsCarousel: iCarouselDataSource, iCarouselDelegate
{
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        let item = self.items[index]
        
        guard let d = self.delegate else {
            return UIView()
        }
        
//        print("*** carousel ROW")
//        print(item)

        let v = UIView()
//        v.layer.borderWidth = 1
//        v.layer.borderColor = UIColor.white.cgColor
        v.setSize(258, 56)
        v.backgroundColor = .white
        
        let close = UIImageView()
        close.image = UIImage(named: "carousel_close")
        v.addSubview(close)
        close.setSize(20, 20)
        close.setY(6)
        close.setX(v.getWidth() - 6 - 20)
        
        
        let url = URL(string: item.PhotoURI)

        let image = UIImageView()
        image.kf.setImage(with: url, placeholder: UIImage(named: "dishThumb"))
        v.addSubview(image)
        image.setSize(74, v.getHeight())
        image.setX(0)
        image.setY(0)
        
        let text = item.Title
        
        let titleSize = getLabelSize(str: text, size: 11, isBold: false, setWidth: 136, setHeight: 0)
        
        let title = UILabel()
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        title.adjustsFontSizeToFitWidth = false
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 11)
        title.text = text
        v.addSubview(title)
        
        title.setX(7, relative: image)
        title.setY(6)
        title.setSize(titleSize.width, titleSize.height)
        
        let price = UILabel()
        price.numberOfLines = 1
        price.textColor = .black
        price.font = UIFont.systemFont(ofSize: 12)
        price.text = PriceWithCurrencyFormatter(price: item.Price, currency: d.getPlaceCurrency())
        v.addSubview(price)
        
        price.setX(7, relative: image)
        price.setY(v.getHeight() - 7 - 12)
        price.setSize(120, 12)
        //---
        
        let buttonClose = UIButton()
        buttonClose.addTarget(self, action: #selector(self.removeOrderItem(_:)), for: .touchUpInside)
        v.addSubview(buttonClose)
        
        buttonClose.setSize(40, 40)
        buttonClose.setY(0)
        buttonClose.setX(v.getWidth() - 40)
        //---
        
        return v
    }
    
    @objc func removeOrderItem(_ sender: AnyObject)
    {
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if(option == .wrap)
        {
            return 0
        }
        
        if(option == .spacing)
        {
            return value * 2.55;
        }
        
        if(option == .fadeMax)
        {
            return 0
        }

        return value
    }
}
