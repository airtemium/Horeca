//
//  DetailsRecepeCell.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation
import UIKit

class DetailsCookingTimeCell: UITableViewCell
{
    var didSetupConstraints = false
    
    var icon: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "details_timing")
        return i
    }()
    
    var title: UILabel = {
        var l = UILabel()
        l.textColor = .white
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.sizeToFit()
        l.font = UIFont.systemFont(ofSize: 17)
        return l
    }()
    
    var sep: UIView = {
        var v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(sep)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    override func updateConstraints()
    {
        if (!didSetupConstraints)
        {
            icon.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(16)
            }
            
            title.snp.makeConstraints { make in
//                make.centerY.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(48)
                make.height.equalToSuperview()
            }
            
            sep.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
    
    func Configure(data: IDetailBaseModel)
    {
        guard let item = data as? DetailsCookingTimeModel else { return }
        
//        print("*** DetailsModifiersCell Configure")
        
        title.text = item.CookingTime
    }
}
