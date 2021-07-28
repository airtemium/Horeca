//
//  InfoHint.swift
//  MayberAdminNew
//
//  Created by Artem on 17.06.2021.
//

import Foundation
import UIKit

class InfoHint: UIView
{
    var titleLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.textColor = .black
        l.font = UIFont.systemFont(ofSize: 14)
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.sizeToFit()
        return l
    }()
    
    init(title: String)
    {
        let size = getLabelSize(str: title, size: 14, isBold: false, setWidth: ScreenSize.SCREEN_WIDTH / 2, setHeight: 0)

        
        super.init(frame: CGRect(x: 0, y: 0, width: size.width + 20, height: size.height + 20))
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        
        self.alpha = 0
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        layer.cornerRadius = 12
        
        self.titleLabel.text = title
        self.addSubview(self.titleLabel)
        
//        self.layoutIfNeeded()
        
        self.titleLabel.setSize(size.width, size.height)
        self.titleLabel.toCenterX(self)
        self.titleLabel.setY(10)
        
//        self.titleLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(size.width)
//            make.height.equalTo(size.height)
//            make.top.equalToSuperview().offset(10)
//        }
    }
    
    func Show()
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut)
        {
            self.alpha = 1
        } completion: { success in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut)
            {
                self.alpha = 0
            } completion: { success in
//                self.snp.removeConstraints()
                self.removeFromSuperview()
            }
        }

    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
