//
//  BaseLoader.swift
//  MayberAdminNew
//
//  Created by Airtemium on 01.06.2021.
//

import Foundation
import UIKit

class BaseLoader: UIView
{
    var bg: UIView = {
        var b = UIView()
        b.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return b
    }()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.addSubview(bg)
        
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        var spinner: UIActivityIndicatorView!
        
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            spinner = UIActivityIndicatorView()
        }
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        self.addSubview(spinner)
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

