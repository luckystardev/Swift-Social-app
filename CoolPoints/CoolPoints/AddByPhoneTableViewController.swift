//
//  AddByPhoneTableViewController.swift
//  CoolPoints
//
//  Created by matti on 2/26/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import MessageUI

class AddByPhoneTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate, UISearchBarDelegate {

    var arrPhoneNumbers : NSMutableArray = []
    @IBOutlet weak var m_searchBar: UISearchBar!
    @IBOutlet weak var m_addByePhoneDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Add by Phone"
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
        return arrPhoneNumbers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForAddViaPhoneId", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = arrPhoneNumbers[indexPath.row] as NSString;
        
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
            self.arrPhoneNumbers.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
        var phonenumber = (self.m_searchBar.text as NSString).mutableCopy() as NSMutableString
        if phonenumber == "" {
            return
        }
        
        phonenumber.insertString("(", atIndex: 0)
        phonenumber.insertString(")", atIndex: 4)
        phonenumber.insertString("-", atIndex: 5)
        phonenumber.insertString("-", atIndex: 9)
        println(phonenumber)
        arrPhoneNumbers.addObject(phonenumber)
        self.tableView.reloadData()
    }
    @IBAction func btnContinueClicked(sender: AnyObject) {

        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
        
        if MFMessageComposeViewController.canSendText() == true {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)"
            messageVC.recipients = arrPhoneNumbers
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

}
