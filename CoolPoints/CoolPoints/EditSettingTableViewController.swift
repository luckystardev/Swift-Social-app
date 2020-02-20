//
//  EditSettingTableViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 3/5/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditSettingTableViewController: UITableViewController, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var m_userImage: UIImageView!
    @IBOutlet weak var m_txtFullname: UITextField!
    @IBOutlet weak var m_txtLocation: UITextField!
    @IBOutlet weak var m_txtBio: UITextField!
    @IBOutlet weak var m_txtEmail: UITextField!
    @IBOutlet weak var m_txtPhonenumber: UITextField!

    var imagePicker = UIImagePickerController()
    var isPhotoChanged : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let savebuttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("btnSaveClicked"))
         self.navigationItem.rightBarButtonItem = savebuttonItem //editButtonItem()
        
        isPhotoChanged = false
        
        let user = PFUser.currentUser()
        m_userImage.layer.borderColor = UIColor.grayColor().CGColor
        m_userImage.layer.borderWidth = 1
        m_userImage.layer.masksToBounds = true
        
        if let file = user["userPhoto"] as? PFFile {
            file .getDataInBackgroundWithBlock({ (data:NSData!, error: NSError!) -> Void in
                if(data != nil && error == nil){
                    self.m_userImage.image = UIImage(data: data)
                }
            })
        }
        
        if let location = user["location"] as? String {
            m_txtLocation.text = location
        }
        if let bio = user["bio"] as? String {
            m_txtBio.text = bio
        }
        if let fullname = user["fullName"] as? String {
            m_txtFullname.text = fullname;
        }
        m_txtEmail.text = user.email
    }
    
    @IBAction func editPhotoClicked(sender: AnyObject) {
        UIActionSheet(title: "Select Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera Roll", "Camera").showInView(self.view)
    }

    func btnSaveClicked() {
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        let user = PFUser.currentUser()
//        user.username = m_txtFullname.text
        user["fullName"] = m_txtFullname.text
        user["location"] = m_txtLocation.text
        user["bio"] = m_txtBio.text
        user.email = m_txtEmail.text
        if let image = m_userImage.image {
            if(isPhotoChanged == true){
                let data = UIImageJPEGRepresentation(image, 1.0)
                let file = PFFile(data: data)
                user["userPhoto"] = file
            }
        }
        
        user.saveInBackgroundWithBlock { (succeed: Bool, error: NSError!) -> Void in
            if(succeed == true && error == nil){
                UIAlertView(title: "Success", message: "Your account has been changed successfully!", delegate: nil, cancelButtonTitle: "Ok").show()

            }else {
                UIAlertView(title: "Error", message: "An error occurred while saving your account settings. Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
                
            }
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIActionSheet Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("\(buttonIndex)")
        
        if buttonIndex == 2 {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else if(buttonIndex == 1) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePickerController Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        if let image1 = editingInfo[UIImagePickerControllerEditedImage] as? UIImage {
            m_userImage.image = image1
        }else if let image2 = editingInfo[UIImagePickerControllerCropRect] as? UIImage {
            m_userImage.image = image2
        }else {// if let image3 = editingInfo[UIImagePickerControllerOriginalImage] as? UIImage {
//            m_userImage.image = image3
            m_userImage.image = image
        }
        isPhotoChanged = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
