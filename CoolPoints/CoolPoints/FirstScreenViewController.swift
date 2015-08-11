//
//  FirstScreenViewController.swift
//  CoolPoints
//
//  Created by matti on 2/24/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.alpha = 1
//        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigationBarBackground"), forBarMetrics: .Default)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
//        UITabBar.appearance().backgroundImage = UIImage(named: "tabbarBackground")
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor(red: 22.0/255.0, green: 93.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        
        let standardUserDefault = NSUserDefaults.standardUserDefaults()
        if let username = standardUserDefault.objectForKey("username") as? String {
            if let password = standardUserDefault.objectForKey("password") as? String {
                if username != "" && password != "" {
                    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser!, error: NSError!) -> Void in
                        MBProgressHUD.hideHUDForView(self.view, animated: false)
                        if let error = error {
                            UIAlertView(title: "Error", message: "Sign in failed!", delegate: nil, cancelButtonTitle: "Ok").show()
                            return
                        }else {
                            
                            UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabbarStoryboardId") as? UIViewController
                        }
                    }
                }
            }
        }
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

}
