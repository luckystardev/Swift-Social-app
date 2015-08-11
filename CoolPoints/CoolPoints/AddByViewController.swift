//
//  AddByViewController.swift
//  CoolPoints
//
//  Created by matti on 2/26/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import Social
import AddressBookUI
import MessageUI

class AddByViewController: UIViewController, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var m_txtDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        TwitterManager.sharedTwitter.startTwitter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationItem.title = "Invite"
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    func btnBackClicked(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnAddByEmailClicked(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() == true {
            let user = PFUser.currentUser()
            let userName = user["fullName"] as String
            
            let messageVC = MFMailComposeViewController()

            messageVC.setMessageBody("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)", isHTML: false)
            messageVC.mailComposeDelegate = self
            messageVC.setSubject("CoolPoints")
            messageVC.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(messageVC, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.BlackOpaque, animated: true)
            })
        } else{
            UIAlertView(title: "Error", message: "Unable to send SMS, Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    @IBAction func btnAddByPhoneClicked(sender: AnyObject) {
        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
        
        if MFMessageComposeViewController.canSendText() == true {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)"
            messageVC.messageComposeDelegate = self
            messageVC.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(messageVC, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.BlackOpaque, animated: true)
            })
        } else{
            UIAlertView(title: "Error", message: "Unable to send SMS, Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    @IBAction func btnAddByTwitterClicked(sender: AnyObject) {
        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
        /* ============ Share on Twitter ============ */
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        }else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        /* =========== Share on Twitter ================ */
        
/*            let bodyString = "checkposting" //Let's get cool points together%21\nKey = \(PFUser.currentUser().objectId)
            let url = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
            let tweetRequest = NSMutableURLRequest(URL: url!)
            tweetRequest.HTTPMethod = "POST"
            tweetRequest.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            if let twitter = PFTwitterUtils.twitter() {
                twitter.signRequest(tweetRequest)
                var response : NSURLResponse?
                var error: NSError?
                let data = NSURLConnection.sendSynchronousRequest(tweetRequest, returningResponse: &response, error: &error)
                if let error = error {
                    println("Error: \(error)")
                } else {
                    if let data = data {
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Response : \(responseString)")
                    } else {
                        println("Error in data")
                    }
                }
            } else {
                println("Twitter is not available")
            }
*/
        /* =========== Share on Twitter =============== */

//        TwitterManager.sharedTwitter.post("https://itunes.apple.com/", imglink: "")
    }
    
    
    @IBAction func btnAddByFacebookClicked(sender: AnyObject) {
        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
        /* ============ Share on Facebook ============ */
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        }else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
/*        let params = FBLinkShareParams(link: NSURL(string: "https://itunes.apple.com/us/app/artattack-where-art-lives/id972677321?ls=1&mt=8"), name: "CoolPoints", caption: "Let's get cool points together!", description: "Key = \(PFUser.currentUser().objectId)", picture: nil)
        
        if FBDialogs.canPresentShareDialogWithParams(params) == true {
            FBDialogs.presentShareDialogWithParams(params, clientState: nil, handler: { (call: FBAppCall!, results: [NSObject : AnyObject]!, error: NSError!) -> Void in
                if (error == nil){
                    println("result \(results)")
                } else {
                    println("Error :\(error)")
                }
            })
        } else {
            
        }    */
    }
    
    @IBAction func btnAddByContactsClicked(sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() == true {
            
            let user = PFUser.currentUser()
            let userName = user["fullName"] as String
            
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)"
            messageVC.messageComposeDelegate = self
            messageVC.navigationBar.tintColor = UIColor.whiteColor()
            self.presentViewController(messageVC, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.BlackOpaque, animated: true)
            })
        } else{
            UIAlertView(title: "Error", message: "Unable to send SMS, Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    // MARK: - MessageComposeViewController Delegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }

    }

    // MARK: - MailComposeViewController Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch (result.value){
        case MFMailComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultFailed.value:
            println("Message was failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MFMailComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
    
}
