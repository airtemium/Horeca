//
//  MapDeleteView.swift
//  MayberAdminNew
//
//  Created by Artem on 28.06.2021.
//

import Foundation
import UIKit

protocol MapDeleteViewDelegate
{
    func MapDeleteViewDelegateDelete()
}

class MapDeleteView: UIView
{
    var delegate: MapDeleteViewDelegate?
    
    private var _originSize: CGFloat = 0
    
    var iconDark: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "map_delete_dark")
        return i
    }()
    
    var button: UIButton = {
        var b = UIButton()
        return b
    }()
    
    init(originSize: CGFloat)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: originSize, height: originSize))
        
        _originSize = originSize
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = _originSize / 2
        
        self.addSubview(iconDark)
        
        self.addSubview(button)
        
        iconDark.setSize(20, 24)
        iconDark.toCenterX(self)
        iconDark.toCenterY(self)
        
        button.addTarget(self, action: #selector(self.actionButton(_:)), for: .touchUpInside)
    }
    
    @objc func actionButton(_ sender: AnyObject)
    {
        guard let d = self.delegate else {
            return
        }
        
        d.MapDeleteViewDelegateDelete()
        
        focusOff()
    }
    
    func focusOn()
    {
        let center = self.center
                
        UIView.animate(withDuration: 0.25) {
            self.setSize(155, self._originSize)
            self.center = center
            
            self.iconDark.toCenterX(self)
            self.iconDark.toCenterY(self)
            
            self.iconDark.image = UIImage(named: "map_delete_light")
            
            self.backgroundColor = .red
        }
    }
    
    func focusOff()
    {
        let center = self.center
        
        UIView.animate(withDuration: 0.25) {
            self.setSize(self._originSize, self._originSize)
            self.center = center
            
            self.iconDark.toCenterX(self)
            self.iconDark.toCenterY(self)
            
            self.iconDark.image = UIImage(named: "map_delete_dark")
            
            self.backgroundColor = .white
        }
    }
    
    func actionDelete()
    {
        guard let d = self.delegate else {
            return
        }
        
        d.MapDeleteViewDelegateDelete()
        
        focusOff()
    }
            
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
