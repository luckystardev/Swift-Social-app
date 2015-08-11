//
//  SettingsFeedbackTableViewController.swift
//  CoolPoints
//
//  Created by matti on 4/4/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class SettingsFeedbackTableViewController: UITableViewController {

    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_userBio: UILabel!
    
    @IBOutlet weak var m_txtTitle: UITextField!
    @IBOutlet weak var m_txtFeedback: UITextView!
    
    override func viewWillAppear(animated:Bool){
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))//UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("btnBackClicked"))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "Settings"
        
        
        let user = PFUser.currentUser()
        m_userName.text = user["fullName"] as? String
        if let file = user["userPhoto"] as? PFFile {
            file.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
                if( data != nil && error == nil){
                    self.m_userPhoto.image = UIImage(data: data)
                    self.m_userPhoto.layer.borderWidth = 3
                    self.m_userPhoto.layer.borderColor = UIColor(red: 18.0/255.0, green: 176.0/255.0, blue: 173.0/255.0, alpha: 1.0).CGColor //UIColor.grayColor().CGColor
                    self.m_userPhoto.layer.cornerRadius = self.m_userPhoto.frame.size.width / 2
                    self.m_userPhoto.layer.masksToBounds = true
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
        
        m_txtFeedback.layer.borderWidth = 1
        m_txtFeedback.layer.borderColor = UIColor.blackColor().CGColor
        m_txtFeedback.layer.masksToBounds = true
    }
    
    func btnBackClicked(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 4
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

}
