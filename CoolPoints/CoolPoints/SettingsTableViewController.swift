//
//  SettingsTableViewController.swift
//  CoolPoints
//
//  Created by matti on 2/25/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

extension Array {
    func insert(element: T) -> [[T]] {
        return (0...self.count).map() {
            var newArray = self
            newArray.insert(element, atIndex: $0)
            return newArray
        }
    }
}

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate {
    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_userBio: UILabel!
    
    @IBOutlet weak var m_userEmail: UILabel!
    
    var menuTitles : Array<String> = ["MainCellGeneralReuseIdentifier", "MainCellProfileReuseIdentifier", "MainCellAlertsReuseIdentifier", "MainCellSecurityReuseIdentifier", "MainCellPPReuseIdentifier", "MainCellToSReuseIdentifier", "MainCellFeedbackReuseIdentifier"/*, "MainCellLogoutReuseIdentifier"*/]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        m_userPhoto.layer.borderWidth = 3
        m_userPhoto.layer.borderColor = UIColor(red: 18.0/255.0, green: 176.0/255.0, blue: 173.0/255.0, alpha: 1.0).CGColor //UIColor.grayColor().CGColor
        m_userPhoto.layer.cornerRadius = m_userPhoto.frame.size.width / 2
        m_userPhoto.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = PFUser.currentUser()
        user.fetchIfNeeded()
        
        if let fullName = user["fullName"] as? String {
            m_userName.text = fullName
        }else {
            m_userName.text = " "
        }
        
        if let file = user["userPhoto"] as? PFFile {
            file.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
                if( data != nil && error == nil){
                    self.m_userPhoto.image = UIImage(data: data)
                }
            }
        }
        
        if let bio = user["bio"] as? String {
            m_userBio.text = bio
            println("bio = \(bio)")
        } else {
            m_userBio.text = " "
        }
        
        if let location = user["location"] as? String {
            m_userLocation.text = location
            println("location = \(location)")
        } else {
            m_userLocation.text = " "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return menuTitles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = menuTitles[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if menuTitles[indexPath.row] == "MainCellLogoutReuseIdentifier" {
//            
////            UIAlertView(title: "Confirm", message: "Are you going to logout now?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok").show()
//            let standardUserDefault = NSUserDefaults.standardUserDefaults()
//            standardUserDefault.removeObjectForKey("password")
//            standardUserDefault.synchronize()
//            UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserManagerStoryboardId") as? UIViewController
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIAlertView Delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("\(buttonIndex)")
        if buttonIndex == 1 {
            let standardUserDefault = NSUserDefaults.standardUserDefaults()
            standardUserDefault.removeObjectForKey("password")
            standardUserDefault.synchronize()
            UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserManagerStoryboardId") as? UIViewController
            
//            let user = PFUser.currentUser()
//            user.password = alertView.textFieldAtIndex(0)?.text
//            user.saveInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
//                if(succeed == true && error == nil){
//                    UIAlertView(title: "Success", message: "Password has been changed successfully!", delegate: nil, cancelButtonTitle: "Ok").show()
//                }else{
//                    UIAlertView(title: "Fail", message: "Password has not been changed.\nPlease try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
//                }
//            })
        }
    }
}
