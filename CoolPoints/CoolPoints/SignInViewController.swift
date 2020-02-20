//
//  SignInViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 2/24/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_fullName: UITextField!
    @IBOutlet weak var m_password: UITextField!
    @IBOutlet weak var btnKeepMeSginedIn: UIButton!
    @IBOutlet weak var m_imgCheckmark: UIImageView!
    @IBOutlet weak var m_btnForgotPassword: UIButton!
    
    
    var isKeepMeChecked : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Sign In"
        m_containerView.layer.cornerRadius = 3
        m_containerView.layer.masksToBounds = true
        m_containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        m_containerView.layer.borderWidth = 1
        
        btnKeepMeSginedIn.layer.borderWidth = 1
        btnKeepMeSginedIn.layer.borderColor = UIColor.lightGrayColor().CGColor
        isKeepMeChecked = false
        m_imgCheckmark.hidden = true
        
        let firstAttributes = [/*NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.yellowColor(), */NSUnderlineStyleAttributeName: 1]
        
        m_btnForgotPassword.setAttributedTitle(NSAttributedString(string: "Forgot Password?", attributes: firstAttributes), forState: UIControlState.Normal)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let standardUserDefault = NSUserDefaults.standardUserDefaults()
        if let username = standardUserDefault.objectForKey("username") as? String {
            m_fullName.text = username
        }
//        standardUserDefault.setObject(user.username, forKey: "username")
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

    @IBAction func btnKeepMeSignedInClicked(sender: AnyObject) {
        isKeepMeChecked = !isKeepMeChecked
        if isKeepMeChecked == true {
            btnKeepMeSginedIn.setImage(UIImage(named: "Checkmark"), forState: UIControlState.Normal)
            m_imgCheckmark.hidden = false
        }else{
            btnKeepMeSginedIn.setImage(nil, forState: UIControlState.Normal)
            m_imgCheckmark.hidden = true
        }
    }
    
    @IBAction func btnForgotPasswordClicked(sender: AnyObject) {
        
    }
    
    @IBAction func btnContinueClicked(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        PFUser.logInWithUsernameInBackground(m_fullName.text, password: m_password.text) { (user: PFUser!, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
            if let error = error {
                UIAlertView(title: "Error", message: "Sign in failed!", delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }else {
                let standardUserDefault = NSUserDefaults.standardUserDefaults()
                standardUserDefault.setObject(user.username, forKey: "username")
                if(self.isKeepMeChecked == true){
                    standardUserDefault.setObject(self.m_password.text, forKey: "password")
                }
                standardUserDefault.synchronize()
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabbarStoryboardId") as? UIViewController
            }
        }
    }
    
}
