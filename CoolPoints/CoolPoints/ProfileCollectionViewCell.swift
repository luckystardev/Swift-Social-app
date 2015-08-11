//
//  ProfileCollectionViewCell.swift
//  CoolPoints
//
//  Created by matti on 3/6/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_createdAt: UILabel!
    @IBOutlet weak var m_comment: UILabel!
    @IBOutlet weak var m_additionalPoints: UILabel!
    @IBOutlet weak var m_viewForLeft: UIView!
    @IBOutlet weak var m_viewForRight: UIView!
    
    func setData(commentObj : PFObject, row: Int){
//        let commentObj = arrComments[row] as PFObject
        m_userPhoto.image = nil
        if let comment = commentObj["comment"] as? String {
            m_comment.text = comment
        } else {
            m_comment.text = " "
        }
        
        if let coolPoints = commentObj["coolPoints"] as? NSNumber {
            m_additionalPoints.text = coolPoints.stringValue + " Points"
        } else {
            m_additionalPoints.text = " "
        }
        m_additionalPoints.layer.cornerRadius = m_additionalPoints.frame.size.height / 2
        m_additionalPoints.layer.masksToBounds = true
        
        m_viewForLeft.hidden = true
        m_viewForRight.hidden = true
        
        if let cUser = commentObj["fromUser"] as? PFUser {
            cUser.fetchIfNeededInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                if object != nil && error == nil {
                    if let file = object["userPhoto"] as? PFFile {
                        file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                            if data != nil && error == nil {
                                self.m_userPhoto.image = UIImage(data: data)
                                self.m_userPhoto.layer.cornerRadius = self.m_userPhoto.frame.size.width / 2
                                self.m_userPhoto.layer.borderColor = UIColor(red: 2.0 / 255.0, green: 171.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0).CGColor //UIColor.blueColor().CGColor
                                self.m_userPhoto.layer.borderWidth = 1
                                self.m_userPhoto.layer.masksToBounds = true
                                
                                if row % 2 == 0 {
                                    self.m_viewForLeft.hidden = true
                                    self.m_viewForRight.hidden = false
                                } else {
                                    self.m_viewForLeft.hidden = false
                                    self.m_viewForRight.hidden = true
                                }
                            }
                        })
                    }
                    
                }
            })
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy"
        let dateStr = dateFormatter.stringFromDate(commentObj.createdAt)
        self.m_createdAt.text = dateStr
        
//        dateFormatter.dateFormat = "MMMM"
//        let monthStr = dateFormatter.stringFromDate(commentObj.createdAt)
//        
//        dateFormatter.dateFormat = "d"
//        var dayStr = dateFormatter.stringFromDate(commentObj.createdAt)
//        if dayStr == "1" {
//            dayStr = "1st"
//        }else if dayStr == "2" {
//            dayStr = "2nd"
//        }else if dayStr == "3" {
//            dayStr = "3rd"
//        }else{
//            dayStr = dayStr + "th"
//        }
//        
//        dateFormatter.dateFormat = "yyyy"
//        let yearStr = dateFormatter.stringFromDate(commentObj.createdAt)
//        
//        self.m_createdAt.text = monthStr + " " + dayStr + " " + yearStr
    }
}
