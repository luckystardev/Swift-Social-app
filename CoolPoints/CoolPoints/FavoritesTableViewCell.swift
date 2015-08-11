//
//  FavoritesTableViewCell.swift
//  CoolPoints
//
//  Created by matti on 2/25/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

@objc
protocol FavoritesCellDelegate{
    func btnFavClicked(indexPath:NSIndexPath)
}

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userCoolPoints: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_favButton: UIButton!
    
    var indexPath: NSIndexPath!
    var delegate : FavoritesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            //Adding round border of container View
//        m_containerView.layer.borderWidth = 1
//        m_containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        m_containerView.layer.cornerRadius = 10
//        m_containerView.layer.masksToBounds = true
        //Adding shadow
//        m_containerView.layer.shadowOffset = CGSizeMake(1, 1)
//        m_containerView.layer.shadowColor = UIColor.blackColor().CGColor!
//        m_containerView.layer.shadowRadius = 4.0
//        m_containerView.layer.shadowOpacity = 0.8
//        m_containerView.layer.shadowPath = UIBezierPath(rect:m_containerView.layer.bounds).CGPath
        
        m_userPhoto.layer.borderWidth = 1
        m_userPhoto.layer.borderColor = UIColor.grayColor().CGColor
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2;
        m_userPhoto.layer.masksToBounds = true
        
        m_userCoolPoints.layer.cornerRadius = 12
        m_userCoolPoints.layer.masksToBounds = true
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnFavClicked(sender: AnyObject) {
        delegate?.btnFavClicked(indexPath)
    }
}
