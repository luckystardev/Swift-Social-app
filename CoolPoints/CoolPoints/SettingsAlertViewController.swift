//
//  SettingsAlertViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 4/4/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

class SettingsAlertViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var m_userPhoto: UIImageView!
    @IBOutlet weak var m_userName: UILabel!
    @IBOutlet weak var m_userLocation: UILabel!
    @IBOutlet weak var m_userBio: UILabel!
    
    @IBOutlet weak var m_contentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    
    @IBAction func btnCancelClicked(sender: AnyObject) {
    }
    @IBAction func btnSaveClicked(sender: AnyObject) {
    }
    @IBAction func m_alertSwitchWhenReceivePoints(sender: AnyObject) {
    }
    @IBAction func m_alertSwitchWhenComments(sender: AnyObject) {
    }
    
    // MARK: - UITableView Stuff
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let arrCellIdentifiers = ["SettingsGeneralCellId1", "SettingsGeneralCellId2", "SettingsGeneralCellId3"]
        let cellIdentifier = arrCellIdentifiers[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        return cell
    }
}
