//
//  MayberLoader.swift
//  MayberAdminNew
//
//  Created by Artem on 30.06.2021.
//

import Foundation
import Lottie

class MayberLoader: UIView
{
    var title: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 20)
        l.sizeToFit()
        l.numberOfLines = 0
        return l
    }()
    
    
    init(title: String)
    {
        super.init(frame: .zero)
        
        self.backgroundColor = .black
        
        let animationView = AnimationView()
        
        let animation = Animation.named("MayberLoader")
            
        animationView.animation = animation
//        animationView.contentMode = .scaleAspectFit
        self.addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        animationView.play()
        animationView.loopMode = .loop
        
        //---
        
        
        self.addSubview(self.title)
        
        self.title.text = title
        
        self.title.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
