//
//  ProfileTableViewCell.swift
//  CoolPoints
//
//  Created by matti on 3/6/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var m_viewForContent: UIView!
    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_createdAt: UILabel!
    @IBOutlet weak var m_comment: UITextView!
    @IBOutlet weak var m_lblComment: UILabel!
    @IBOutlet weak var m_description: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        m_viewForContent.layer.cornerRadius = 5
//        m_viewForContent.layer.borderWidth = 1
//        m_viewForContent.layer.borderColor = UIColor.lightGrayColor().CGColor
//        m_viewForContent.layer.masksToBounds = true
        
        
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2
//        m_userPhoto.layer.borderColor = UIColor.greenColor().CGColor
//        m_userPhoto.layer.borderWidth = 1
        m_userPhoto.layer.masksToBounds = true
        m_userPhoto.image = nil
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
