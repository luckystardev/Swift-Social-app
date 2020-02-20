//
//  SettingsProfileViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 3/21/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit
import MobileCoreServices

class SettingsProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_userBio: UILabel!
    
    @IBOutlet weak var m_contentTable: UITableView!
    var originOffsetY: CGFloat = 0
    var activeTextField: UITextField!
    
    var username : String = ""
    var userlocation : String = ""
    var userBio : String = ""
    var userImage : UIImage!
    
    var imagePicker = UIImagePickerController()
    
    var isLoaded : Bool!
    var isPhotoChanged : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isLoaded = false
        isPhotoChanged = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        if isLoaded == false {
            isLoaded = true
            let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))//UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("btnBackClicked"))
            self.navigationItem.leftBarButtonItem = backButton
            self.navigationItem.title = "Settings"
            
            let user = PFUser.currentUser()
            username = user["fullName"] as String
            m_userName.text = username
            if let file = user["userPhoto"] as? PFFile {
                file.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
                    if( data != nil && error == nil){
                        self.userImage = UIImage(data: data)
                        self.m_userPhoto.image = self.userImage
                        self.m_userPhoto.layer.borderWidth = 3
                        self.m_userPhoto.layer.borderColor = UIColor(red: 18.0/255.0, green: 176.0/255.0, blue: 173.0/255.0, alpha: 1.0).CGColor //UIColor.grayColor().CGColor
                        self.m_userPhoto.layer.cornerRadius = self.m_userPhoto.frame.size.width / 2
                        self.m_userPhoto.layer.masksToBounds = true
                        
                        self.m_contentTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                }
            }
            
            if let bio = user["bio"] as? String {
                userBio = bio
                m_userBio.text = bio
            } else {
                m_userBio.text = " "
            }
            
            if let location = user["location"] as? String {
                m_userLocation.text = location
                userlocation = location
            } else {
                m_userLocation.text = " "
            }
        }
    }
    
    func btnBackClicked(){
        self.navigationController?.popViewControllerAnimated(true)
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

    //MARK: - UITableView stuff
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            UIActionSheet(title: "Select Photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera Roll", "Camera").showInView(self.view)
        }
        if indexPath.row == 13 {
            
            PFUser.logOut()
            
            let standardUserDefault = NSUserDefaults.standardUserDefaults()
            standardUserDefault.removeObjectForKey("password")
            standardUserDefault.synchronize()
            UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserManagerStoryboardId") as? UIViewController
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        SettingsProfileCellId1
        let cellIdentifier = "SettingsProfileCellId\(indexPath.row + 1)"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        
        if(indexPath.row == 1){
            let iv = cell.contentView.viewWithTag(1) as UIImageView
            iv.image = userImage
            iv.layer.cornerRadius = iv.frame.size.width / 2
            iv.layer.masksToBounds = true
        }
        if(indexPath.row == 2){
            let tf = cell.contentView.viewWithTag(2) as UITextField
            tf.text = username
        }
        if(indexPath.row == 3){
            let tf = cell.contentView.viewWithTag(3) as UITextField
            tf.text = userlocation
        }
        if(indexPath.row == 4){
            let tf = cell.contentView.viewWithTag(4) as UITextField
            tf.text = userBio
        }
        
        return cell
    }
    
    //MARK: - UITextField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 2 {
            username = textField.text
        }
        if textField.tag == 3 {
            userlocation = textField.text
        }
        if textField.tag == 4 {
            userBio = textField.text
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    //MARK: - Keyboard Notifications Observer
    func keyboardWillShow(notification: NSNotification) {
        
        let cell = activeTextField.superview?.superview as UITableViewCell
        
        if originOffsetY == 0 {
            originOffsetY = self.m_contentTable.contentOffset.y
        }
        
        let navBarRect = (self.navigationController?.navigationBar.frame)!
        let yVal = cell.frame.origin.y + cell.frame.size.height - originOffsetY //+ navBarRect.origin.y + navBarRect.size.height
        
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[/*UIKeyboardFrameBeginUserInfoKey*/UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                if yVal > keyboardSize.origin.y {
                    self.m_contentTable.contentOffset = CGPoint(x: 0, y: originOffsetY + yVal - keyboardSize.origin.y)
                } else {

                }
                // ...
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        self.m_contentTable.contentOffset = CGPoint(x: 0, y: originOffsetY)
        originOffsetY = 0
    }

    
    // MARK: - UIActionSheet Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
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
        
        let cell = self.m_contentTable.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as UITableViewCell?
        
        let iv = cell?.contentView.viewWithTag(1) as UIImageView
        
        if let image1 = editingInfo[UIImagePickerControllerEditedImage] as? UIImage {
            userImage = image1
        }else if let image2 = editingInfo[UIImagePickerControllerCropRect] as? UIImage {
            userImage = image2
            
        }else {// if let image3 = editingInfo[UIImagePickerControllerOriginalImage] as? UIImage
            userImage = image
        }
        
        iv.image = userImage
        isPhotoChanged = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UIButton Actions

    @IBAction func btnSaveClicked(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        let user = PFUser.currentUser()
        //        user.username = m_txtFullname.text
        user["fullName"] = username
        user["location"] = userlocation
        user["bio"] = userBio
        if isPhotoChanged == true {
            if userImage != nil {
                let data = UIImageJPEGRepresentation(userImage, 1.0)
                let file = PFFile(data: data)
                user["userPhoto"] = file
            }
        }
        user.saveInBackgroundWithBlock { (succeed: Bool, error: NSError!) -> Void in
            if(succeed == true && error == nil){
                UIAlertView(title: "Success", message: "Your account has been changed successfully!", delegate: nil, cancelButtonTitle: "Ok").show()
                NSNotificationCenter.defaultCenter().postNotificationName("UserBasicProfileChanged", object: nil)
                
            }else {
                UIAlertView(title: "Error", message: "An error occurred while saving your account settings. Please try again later.", delegate: nil, cancelButtonTitle: "Ok").show()
                
            }
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSPAClicked(sender: AnyObject) {
        
    }
    
}
