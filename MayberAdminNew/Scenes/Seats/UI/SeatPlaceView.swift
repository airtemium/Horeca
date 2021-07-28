//
//  SeatPlaceView.swift
//  MayberAdminNew
//
//  Created by Artem on 23.06.2021.
//

import Foundation
import UIKit

enum SeatPlaceViewArrange: Int
{
    case top
    case bottom
    case left
    case right
    case circle
    case additional
}

protocol SeatPlaceViewDelegate
{
    func SeatPlaceViewDelegateSelect(number: Int, points: CGPoint)
    
    func getSuperView() -> UIView?
}

class SeatPlaceView: UIView
{
    var emptySeatColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)//142 142 147
    
    private var _number = 0
    
    private var _isSelected = false
    
    var delegate: SeatPlaceViewDelegate!
    
    var _arrange: SeatPlaceViewArrange!
    
    var _isAside = false
    
    var _isCheckin = false
    
    var label: UILabel!
    
    var seat: UIView!
    
    var badge: UIView!
    
    var badgeLabel: UILabel!
    
    var originalWidth: CGFloat = 0
    
    var originalHeight: CGFloat = 0
    
    init(width: CGFloat, height: CGFloat, number: Int, arrange: SeatPlaceViewArrange)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
//        print("*** SeatPlaceView *** \(width) *** \(height)")
        
//        self.backgroundColor = .red
        
        originalWidth = width
        
        originalHeight = height
        
        _number  = number
        
        _arrange = arrange
        
//        self.backgroundColor = emptySeatColor
        
        seat = UIView()
        seat.setSize(width, height)
        seat.setX(0)
        seat.setY(0)
        seat.backgroundColor = emptySeatColor
        seat.layer.cornerRadius = width / 2
        self.addSubview(seat)
        
        label = UILabel()
        label.alpha = 0
        label.textColor = .white
        label.textAlignment = .center
        label.text = "\(number)"
        label.font = UIFont.systemFont(ofSize: 20)
        label.setSize(width, height)
        label.setX(0)
        label.setY(0)
        self.addSubview(label)
        
        //---
        
        badge = UIView()
        badge.isHidden = true
        badge.setSize(width * 0.5, height * 0.5)
        badge.setX(seat.getWidth() - 10)
        badge.setY(-5)
        badge.backgroundColor = .red
        badge.layer.cornerRadius = (width * 0.5) / 2
        self.addSubview(badge)
        
        badgeLabel = UILabel()
        badgeLabel.alpha = 1
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.text = "\(0)"
        badgeLabel.font = UIFont.systemFont(ofSize: 12)
        badgeLabel.setSize(badge.getWidth(), badge.getHeight())
        badgeLabel.setX(0)
        badgeLabel.setY(0)
        badge.addSubview(badgeLabel)
        
        //---
        
        self.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func SetLabelAlfa(alfa: CGFloat)
    {
//        UIView.animate(withDuration: 0.3) {
            self.label.alpha = alfa
//        } completion: { success in
            
//        }
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer)
    {        
        guard let d = self.delegate else {
            return
        }
        
        let location = sender.location(in: d.getSuperView())

        d.SeatPlaceViewDelegateSelect(number: _number, points: location)
    }
    
    func setBadgeCount(count: Int)
    {
//        print("*** setBadgeCount \(count)")
        if(count == 0)
        {
            badge.isHidden = true
            
            return
        }
        
        badge.isHidden = false
        badgeLabel.text = "\(count)"
    }
    
    func SetIncrease()
    {
        UIView.animate(withDuration: 0.3) {
            UIView.animate(withDuration: 0.3) {
                self.seat.setSize(self.originalWidth + 15, self.originalHeight + 15)
                self.seat.toCenterX(self)
                self.seat.toCenterY(self)
                
                self.seat.layer.cornerRadius = (self.originalWidth + 15) / 2
            }
        }
    }
    
    func UnsetIncrease()
    {
        UIView.animate(withDuration: 0.3) {
            self.seat.setSize(self.originalWidth, self.originalHeight)
            self.seat.toCenterX(self)
            self.seat.toCenterY(self)
            
            self.seat.layer.cornerRadius = self.originalWidth / 2
        }
    }
    
    func setCheckinColor(color: UIColor)
    {
        seat.backgroundColor = color
    }
        
    var IsCheckin: Bool
    {
        get
        {
            return _isCheckin
        }
        set
        {
            _isCheckin = newValue
        }
    }
    
    var IsSelected: Bool
    {
        get
        {
            return _isSelected
        }
        set
        {
            _isSelected = newValue
        }
    }
    
    var IsAside: Bool
    {
        get
        {
            return _isAside
        }
        set
        {
            _isAside = newValue
        }
    }
    
    var GetArrange: SeatPlaceViewArrange
    {
        get
        {
            return _arrange
        }
    }
    
    var GetNumber: Int
    {
        get
        {
            return _number
        }
        
        set
        {
            _number = newValue
        }
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
