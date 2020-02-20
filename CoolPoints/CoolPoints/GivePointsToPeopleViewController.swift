//
//  GivePointsToPeopleViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 3/5/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

class GivePointsToPeopleViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userCoolPoints: UILabel!
    @IBOutlet weak var m_additionalPoints: UILabel!
    @IBOutlet weak var m_description: UITextView!
    @IBOutlet weak var m_givePointsButton: UIButton!
    @IBOutlet weak var m_numberOfDescription : UILabel!
    @IBOutlet weak var m_plusButton: UIButton!
    @IBOutlet weak var m_minusButton: UIButton!
    var additionalPoints:Int64!//UInt64!
    
    weak var user : PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        additionalPoints = 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Give Points"
        
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2
        m_userPhoto.layer.borderColor = UIColor.lightGrayColor().CGColor
        m_userPhoto.layer.borderWidth = 1
        m_userPhoto.layer.masksToBounds = true
        
        if let file = user["userPhoto"] as? PFFile {
            file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                if data != nil && error == nil {
                    self.m_userPhoto.image = UIImage(data: data)
                }
            })
        }
        if let fullname = user["fullName"] as? String {
            m_userName.text = fullname
        }
        
        let infoQuery = PFQuery(className: "UserInfo")
        infoQuery.whereKey("user", equalTo: user)
        infoQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if object != nil && error == nil {
                if let coolPoints = object["coolPoints"] as? NSNumber {
                    self.m_userCoolPoints.text = coolPoints.stringValue + " POINTS"
                }
            }
        }
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))
        self.navigationItem.leftBarButtonItem = backButton
        
        if let desc = m_description.text {
            let length = countElements(desc)
            m_numberOfDescription.text = "\(140 - length) characters"
        }
    }
    
    func btnBackClicked(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnMinusPointsClicked(sender: AnyObject) {

        additionalPoints = additionalPoints - 10
//        if additionalPoints <= 0 {
//            m_minusButton.setImage(UIImage(named: "decreasePointsButton"), forState: UIControlState.Normal)
//        }else{
//            m_minusButton.setImage(UIImage(named: "decreasePointsButton(1)"), forState: UIControlState.Normal)
//        }
        if additionalPoints == 0 {
            m_givePointsButton.enabled = false
            m_minusButton.enabled = false
        } else {
            m_givePointsButton.enabled = true
            m_minusButton.enabled = true
        }
        m_additionalPoints.text = "\(additionalPoints) pts"
    }
    @IBAction func btnAddPointsClicked(sender: AnyObject) {
        additionalPoints = additionalPoints + 10
//        if additionalPoints <= 0 {
//            m_minusButton.setImage(UIImage(named: "decreasePointsButton"), forState: UIControlState.Normal)
//        }else{
//            m_minusButton.setImage(UIImage(named: "decreasePointsButton(1)"), forState: UIControlState.Normal)
//        }
        if additionalPoints == 0 {
            m_givePointsButton.enabled = false
            m_minusButton.enabled = false
        } else {
            m_givePointsButton.enabled = true
            m_minusButton.enabled = true
        }
        m_additionalPoints.text = "\(additionalPoints) pts"
    }
    @IBAction func btnTakePhotoClicked(sender: AnyObject) {
        
    }
    @IBAction func btnGivePointsClicked(sender: AnyObject) {
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        
        let infoQuery = PFQuery(className: "UserInfo")
        infoQuery.whereKey("user", equalTo: self.user)
        infoQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            var userInfoObj = object
            if( userInfoObj == nil ){
                userInfoObj = PFObject(className: "UserInfo")
                userInfoObj["user"] = self.user
            }
            if userInfoObj["coolPoints"] == nil {
                userInfoObj["coolPoints"] = NSNumber(unsignedLongLong: 0 )
            }
                if let coolPoints = userInfoObj["coolPoints"] as? NSNumber {
                    userInfoObj["coolPoints"] = NSNumber(longLong: coolPoints.longLongValue + self.additionalPoints )
                    userInfoObj.saveInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
                        println("Error: \(error)")
                        
                        if(succeed == true && error == nil){
                            let actionObj = PFObject(className: "Action")
                            actionObj["toUser"] = self.user
                            actionObj["fromUser"] = PFUser.currentUser()
                            actionObj["coolPoints"] = NSNumber(longLong: self.additionalPoints)
                            actionObj["comment"] = self.m_description.text
                            
                            actionObj.saveInBackgroundWithBlock { (succeed: Bool, error: NSError!) -> Void in
                                
                                MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                                if succeed == true && error == nil {
                                    
                                    let fullName = self.user["fullName"] as String
                                    UIAlertView(title: "Success", message: "You gave \(fullName) \(self.additionalPoints) points successfully.", delegate: nil, cancelButtonTitle: "Ok").show()
                                    self.navigationController?.popViewControllerAnimated(true)
                                }
                            }
                        }else{
                            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                            UIAlertView(title: "Error", message: "Giving points was failed. Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
                        }
                        
                    })
                }else{
                    MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let length = countElements(text)
        let updatedLen = countElements(textView.text) + length//range.location + length
        if (length>0 && updatedLen <= 140) || (length == 0) {
            return true
        }
        return false
    }
    
    func textViewDidChange(textView: UITextView) {
        let length = countElements(textView.text)
        m_numberOfDescription.text = "\(140 - length) characters"
        
    }
}
