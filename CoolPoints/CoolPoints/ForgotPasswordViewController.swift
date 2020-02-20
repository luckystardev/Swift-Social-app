//
//  ForgotPasswordViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 2/25/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var m_emailAddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Forgot Password"
        self.navigationItem.setHidesBackButton(true, animated: false)
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
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func btnSendClicked(sender: AnyObject) {
        if m_emailAddress.text == "" {
            UIAlertView(title: "Error", message: "Enter your email address please.", delegate: nil, cancelButtonTitle: "Ok").show()
        } else {
            PFUser.requestPasswordResetForEmailInBackground(m_emailAddress.text, block: { (succeed: Bool, error: NSError!) -> Void in
                if(succeed == true && error == nil){
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    UIAlertView(title: "Success", message: "Email for resetting password was sent successfully!", delegate: nil, cancelButtonTitle: "Ok").show()
                } else {
                    UIAlertView(title: "Error", message: "Sending email to reset password was failed!", delegate: nil, cancelButtonTitle: "Ok").show()
                }
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
