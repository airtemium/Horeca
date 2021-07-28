//
//  DetailsRecepeCell.swift
//  MayberAdminNew
//
//  Created by Artem on 10.06.2021.
//

import Foundation
import UIKit

class DetailsEmptyCell: UITableViewCell
{
    var didSetupConstraints = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear

        self.selectionStyle = UITableViewCell.SelectionStyle.none

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

        }
        
        super.updateConstraints()
    }
    
    func Configure(data: IDetailBaseModel)
    {

    }
}
