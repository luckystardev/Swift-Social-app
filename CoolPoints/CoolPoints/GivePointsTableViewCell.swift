//
//  GivePointsTableViewCell.swift
//  CoolPoints
//
//  Created by tmaas510 on 3/5/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

protocol GivePointsTableViewCellDelegate {
    func favObjectAtIndexPath(indexPath: NSIndexPath) -> PFObject!
    
}

class GivePointsTableViewCell: UITableViewCell {

    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_userPhoto: UIImageView!
    
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    
    @IBOutlet weak var m_userCoolPoints: UILabel!
    
    @IBOutlet weak var m_friendButton: UIButton!
    
    var pointsQuery: PFQuery!
    var favQuery: PFQuery!
    var fileQuery: PFFile!
    var favObject: PFObject!
    var tempUser: PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        m_containerView.layer.cornerRadius = 5
//        m_containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        m_containerView.layer.borderWidth = 1
//        m_containerView.layer.masksToBounds = true
        
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2
        m_userPhoto.layer.borderColor = UIColor.lightGrayColor().CGColor
        m_userPhoto.layer.borderWidth = 1
        m_userPhoto.layer.masksToBounds = true
        
        m_userCoolPoints.layer.cornerRadius = 12
        m_userCoolPoints.layer.masksToBounds = true
        
        self.m_friendButton.selected = false
        self.m_friendButton.enabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.m_userPhoto.image = nil
        self.m_userCoolPoints.text = " "
        self.m_friendButton.selected = false
        self.m_friendButton.enabled = false
    }
    
    func refreshContents(user:PFUser){
        
        self.cancelQueries()
        tempUser = user
        
        fileQuery = user["userPhoto"] as? PFFile
        if fileQuery != nil {
            fileQuery.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                if data != nil && error == nil {
                    self.m_userPhoto.image = UIImage(data: data)
                } else {
                    self.m_userPhoto.image = nil
                }
                self.fileQuery = nil
            })
        } else {
            self.m_userPhoto.image = nil
        }
        
        if let location = user["location"] as? String {
            self.m_userLocation.text = location
        } else {
            self.m_userLocation.text = " "
        }
        
        if let fullname = user["fullName"] as? String {
            self.m_userName.text = fullname
        } else {
            self.m_userName.text = " "
        }
        
        pointsQuery = PFQuery(className: "UserInfo")
        pointsQuery.whereKey("user", equalTo: user)
        pointsQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if object != nil && error == nil {
                if let coolPoints = object["coolPoints"] as? NSNumber {
                    self.m_userCoolPoints.text = coolPoints.stringValue + " pts"
                }
            } else {
                self.m_userCoolPoints.text = " "
            }
            self.pointsQuery = nil
        }
        self.m_friendButton.enabled = false
        favQuery = PFQuery(className: "Favorites")
        favQuery.whereKey("fromUser", equalTo: PFUser.currentUser())
        favQuery.whereKey("toUser", equalTo: user)
        favQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            self.m_friendButton.enabled = true
            if error == nil && object != nil {
                self.m_friendButton.selected = true
//                self.m_friendButton.hidden = false
                self.favObject = object
            } else {
//                self.m_friendButton.hidden = true
                self.m_friendButton.selected = false
                self.favObject = PFObject(className: "Favorites")
                self.favObject["toUser"] = user
                self.favObject["fromUser"] = PFUser.currentUser()
            }
            

            self.favQuery = nil
        }
    }
    
    @IBAction func btnFavoriteClicked(sender: AnyObject) {
        if m_friendButton.selected == true {
            let favObjId = self.favObject.objectId
            self.favObject.delete()
            self.m_friendButton.selected = false
            self.favObject = PFObject(className: "Favorites")
            self.favObject["toUser"] = tempUser
            self.favObject["fromUser"] = PFUser.currentUser()
            
        NSNotificationCenter.defaultCenter().postNotificationName("MyUnlikedNotification", object: favObjId)
        } else {
            self.favObject.save()
            self.m_friendButton.selected = true
        NSNotificationCenter.defaultCenter().postNotificationName("MyLikedNotification", object: self.favObject)
        }
    }
    
    
    func cancelQueries(){
        if favQuery != nil {
            favQuery.cancel()
            favQuery = nil
        }
        if pointsQuery != nil {
            pointsQuery.cancel()
            pointsQuery = nil
        }
        if fileQuery != nil {
            fileQuery.cancel()
            fileQuery = nil
        }
    }

    deinit{
        self.cancelQueries()
        println("Deinit called!")
    }
}
