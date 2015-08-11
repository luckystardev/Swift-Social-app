//
//  LinkFacebookViewController.swift
//  CoolPoints
//
//  Created by matti on 2/24/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import Social

class LinkFacebookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Sign Up"
        
        self.navigationItem.hidesBackButton = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func addCoolPointsForSocial(){
        let query = PFQuery(className: "UserInfo")
        var coolPoints : NSNumber!
        var obj : PFObject!
        query.whereKey("user", equalTo: PFUser.currentUser())
        obj = query.getFirstObject()
        if obj != nil {
            coolPoints = obj["coolPoints"] as NSNumber
            obj["coolPoints"] = NSNumber(longLong: coolPoints.longLongValue + 1500)
        }else{
            obj = PFObject(className: "UserInfo")
            obj["user"] = PFUser.currentUser()
            obj["coolPoints"] = NSNumber(unsignedLongLong: 1500)
        }

        obj.save()
    }
    
    @IBAction func btnLinkFacebookClicked(sender: AnyObject) {
        
        
//        let user = PFUser.currentUser()
//        let userName = user["fullName"] as String
//        /* ============ Share on Facebook ============ */
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
//            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookSheet.setInitialText("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)")
//            facebookSheet.completionHandler = { result -> Void in
//                var getResult = result as SLComposeViewControllerResult
//                switch(getResult.rawValue){
//                case SLComposeViewControllerResult.Cancelled.rawValue: println("Cancelled")
//                case SLComposeViewControllerResult.Done.rawValue:
//                    println("Done")
//                    self.addCoolPointsForSocial()
//                default: println("Error!")
//                }
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            self.presentViewController(facebookSheet, animated: true, completion: nil)
//        }else {
//            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
        let user = PFUser.currentUser()
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        
        if PFFacebookUtils.isLinkedWithUser(user) == false {
            PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (succeeded: Bool, error: NSError!) -> Void in
                if succeeded {
                    println("User logged in with Facebook!")
                    println("User logged in with Twitter")
                    let query = PFQuery(className: "UserInfo")
                    var coolPoints : NSNumber!
                    var obj : PFObject!
                    query.whereKey("user", equalTo: PFUser.currentUser())
                    obj = query.getFirstObject()
                    if obj != nil {
                        coolPoints = obj["coolPoints"] as NSNumber
                        obj["coolPoints"] = NSNumber(longLong: coolPoints.longLongValue + 1500)
                    }else{
                        obj = PFObject(className: "UserInfo")
                        obj["user"] = PFUser.currentUser()
                        obj["coolPoints"] = NSNumber(unsignedLongLong: 1500)
                    }
                    
                    obj.save()
                    
                    MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                    
                    
                    let postParams = ["link":"https://itunes.apple.com/us/app/coolpoints-be-awesome-together/id517619016?mt=8", "name":"CoolPoints", "message":"Here we go", "caption":"Build great relationship with CoolPoints!", "description":"Join CoolPoints"]
                    
//                    FBRequestConnection.startWithGraphPath("me/feed", parameters: postParams, HTTPMethod: "POST") { (request: FBRequestConnection!, object: AnyObject!, error: NSError!) -> Void in
//                        if let error = error {
//                            
//                            println("Error: %@", error)
//                        }else {
//                            println("Object: %@", object )
//                            self.performSegueWithIdentifier("GotoCongratsSegueId", sender: self)
//                        }
//                    }
                    
                    
                }else{
                    println("Linking with facebook was just failed!")
                    println("Error: \(error)")
                    
                    MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                }
            })
        }
    }
}
