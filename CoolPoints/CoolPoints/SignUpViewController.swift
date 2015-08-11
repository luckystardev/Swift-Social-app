//
//  SignUpViewController.swift
//  CoolPoints
//
//  Created by matti on 2/24/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var m_containerView: UIView!
    @IBOutlet weak var m_fullName: UITextField!
    @IBOutlet weak var m_emailAddress: UITextField!
    @IBOutlet weak var m_password: UITextField!
    @IBOutlet weak var m_rePassword: UITextField!
    @IBOutlet weak var m_imgCheckmark: UIImageView!
    @IBOutlet weak var m_btnToS: UIButton!
    @IBOutlet weak var btnKeepMeSginedIn: UIButton!
    
    var isKeepMeChecked: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        m_containerView.layer.cornerRadius = 5;
        m_containerView.layer.borderWidth = 1;
        m_containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        btnKeepMeSginedIn.layer.borderWidth = 1
        btnKeepMeSginedIn.layer.borderColor = UIColor.lightGrayColor().CGColor
        isKeepMeChecked = false
        m_imgCheckmark.hidden = true
        
        let firstAttributes = [/*NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.yellowColor(), */NSUnderlineStyleAttributeName: 1]
        
        m_btnToS.setAttributedTitle(NSAttributedString(string: "Terms of Service and Privacy Policy", attributes: firstAttributes), forState: UIControlState.Normal)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Sign Up"
        
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

    @IBAction func btnContinueClicked(sender: AnyObject) {
        
        if isKeepMeChecked == false {
            UIAlertView(title: "Warning", message: "Please read and accept terms of service and privacy policy", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        if m_fullName.text == "" {
            UIAlertView(title: "Error", message: "Please enter your full name.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        if m_emailAddress.text == "" {
            UIAlertView(title: "Error", message: "Please enter your email address.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        if m_password.text == "" {
            UIAlertView(title: "Error", message: "Please enter your password.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        if m_password.text != m_rePassword.text{
            UIAlertView(title: "Error", message: "Please enter your password correctly.", delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        let user = PFUser()
        user.username = m_emailAddress.text
        user.email = m_emailAddress.text
        user.password = m_password.text
        user["fullName"] = m_fullName.text
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
            if let error = error{
                UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }else{
                
                let obj = PFObject(className: "UserInfo")
                obj["user"] = user
                obj["coolPoints"] = NSNumber(unsignedLongLong: 2500)
                obj.save()
                PFUser.logInWithUsername(user.username, password: self.m_password.text)
                self.performSegueWithIdentifier("LinkWithTwitterSegueId", sender: self)
            }
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnCheckmarkClicked(sender: AnyObject) {
        isKeepMeChecked = !isKeepMeChecked
        if isKeepMeChecked == true {
            m_imgCheckmark.hidden = false
        }else{
            m_imgCheckmark.hidden = true
        }
    }
    
}
