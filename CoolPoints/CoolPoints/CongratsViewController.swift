//
//  CongratsViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 2/24/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

let COOL_POINTS_FOR_ACCCEPT = 150

class CongratsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_lblPoints: UILabel!
    @IBOutlet weak var m_txtInviteKey: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        m_containerView.layer.cornerRadius = 10
        m_containerView.layer.masksToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    @IBAction func btnGetStartedClicked(sender: AnyObject) {
        m_txtInviteKey.resignFirstResponder()
        
        if( m_txtInviteKey.text != "" ){
            
            let userQuery = PFUser.query()
            userQuery.whereKey("objectId", equalTo: m_txtInviteKey.text)
            if let tUser = userQuery.getFirstObject() {
                let query = PFQuery(className: "UserInfo")
                query.whereKey("user", equalTo: tUser)
                if let object = query.getFirstObject() {
                    var coolPoints = object["coolPoints"] as NSNumber!
                    if coolPoints == nil {
                        coolPoints = NSNumber(unsignedLongLong: UInt64(COOL_POINTS_FOR_ACCCEPT))
                    } else {
                        coolPoints = NSNumber(longLong: coolPoints.longLongValue + COOL_POINTS_FOR_ACCCEPT)
                    }
                    object["coolPoints"] = coolPoints
                    object.save()
                    
                    let objInfo = PFObject(className: "AcceptAction")
                    objInfo["fromUser"] = tUser
                    objInfo["toUser"] = PFUser.currentUser()
                    objInfo["comment"] = "Invite Acception"
                    objInfo["points"] = NSNumber(unsignedLongLong: UInt64(COOL_POINTS_FOR_ACCCEPT))
    //                objInfo.saveInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
    //                })
                    objInfo.save()
                }
            }
        }
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabbarStoryboardId") as? UIViewController
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var rt = self.view.frame
            rt.origin.y = -230
            self.view.frame = rt
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            var rt = self.view.frame
            rt.origin.y = 0
            self.view.frame = rt
            }, completion: nil)
    }
}
