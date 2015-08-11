//
//  AddByEmailTableViewController.swift
//  CoolPoints
//
//  Created by matti on 2/26/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import MessageUI

class AddByEmailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var m_searchbar: UISearchBar!
    @IBOutlet weak var m_addByEmailDescription: UITextView!
    
    let arrEmails : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Add by Email"
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func btnBackClicked(){
        self.navigationController?.popViewControllerAnimated(true)
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
        return arrEmails.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addViaEmailCellId", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = arrEmails[indexPath.row] as? String

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.arrEmails.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            println("\(self.arrEmails) : \(self.arrEmails.count)")
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    @IBAction func btnAddClicked(sender: AnyObject) {
        
//        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        
        if emailTest?.evaluateWithObject(m_searchbar.text) == true {
            arrEmails.addObject(m_searchbar.text)
            self.tableView.reloadData()
        } else {
            UIAlertView(title: "Error", message: "Please enter the correct email address.", delegate: nil, cancelButtonTitle: "Ok").show()
        }
        m_searchbar.text = "";

    }
    
    @IBAction func btnContinueClicked(sender: AnyObject) {
        
        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients(arrEmails)
        picker.setSubject("CoolPoints")
        picker.setMessageBody("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(PFUser.currentUser().objectId)", isHTML: true)
        picker.navigationBar.tintColor = UIColor.whiteColor()
        if MFMailComposeViewController.canSendMail() == true {
            self.presentViewController(picker, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.BlackOpaque, animated: true)
                
            })
        } else {
            UIAlertView(title: "Error", message: "Your device can not send e-mail. Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "Ok")
        }
    }
    
    // MARK: - MFMailComposeViewController Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
