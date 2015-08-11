//
//  MyProfileSectionHeaderTableViewCell.swift
//  CoolPoints
//
//  Created by matti on 3/21/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class MyProfileSectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_userDescription: UILabel!
    @IBOutlet weak var m_userCoolPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        m_userPhoto.layer.borderWidth = 3
        m_userPhoto.layer.borderColor = UIColor(red: 18.0/255.0, green: 176.0/255.0, blue: 173.0/255.0, alpha: 1.0).CGColor //UIColor.grayColor().CGColor
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2
        m_userPhoto.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setUser(user: PFUser){
        //        m_userCoolPoints.text = "0 Points"
        let query = PFQuery(className: "UserInfo")
        query.whereKey("user", equalTo: user)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                let coolPoints = object["coolPoints"] as NSNumber
                self.m_userCoolPoints.text = "\(coolPoints.longLongValue) Points"
            }
        }
        
        if let file = user["userPhoto"] as? PFFile {
            file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                self.m_userPhoto.image = UIImage(data: data)
            })
        }
        
        if let fullName = user["fullName"] as? String {
            m_userName.text = fullName
        }
        
        if let location = user["location"] as? String {
            m_userLocation.text = location
        }else {
            m_userLocation.text = " "
        }
        
        if let bio = user["bio"] as? String {
            m_userDescription.text = bio
        }else {
            m_userDescription.text = " "
        }
    }
    func setFavoriteStatus(isFavorite: Bool){
        if isFavorite == true {
            m_userPhoto.layer.borderColor = UIColor.redColor().CGColor
        }else{
            m_userPhoto.layer.borderColor = UIColor(red: 18.0/255.0, green: 176.0/255.0, blue: 173.0/255.0, alpha: 1.0).CGColor //UIColor.grayColor().CGColor
        }
        m_userPhoto.layer.masksToBounds = true
    }
}
