//
//  OtherProfileViewController.swift
//  CoolPoints
//
//  Created by matti on 3/11/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var m_contentTable: UITableView!
    
    var arrComments: Array<PFObject> = []
    var refreshControl : UIRefreshControl!
    var baseUser : PFUser!
    
    var favObject : PFObject!
    var headerView : MyProfileSectionHeaderTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadMyTimeLine"), forControlEvents: UIControlEvents.ValueChanged)
        m_contentTable.addSubview(refreshControl)

        headerView = m_contentTable.dequeueReusableCellWithIdentifier("MyProfileSectionHeaderTableViewCell1") as MyProfileSectionHeaderTableViewCell
        headerView.setUser(self.baseUser)
        
        self.loadContents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyLikedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyUnlikedNotification", object: nil)
        

        
    }
    
    func loadContents(){
        
        self.updateProfile()
        self.reloadMyTimeLine()
        self.getFavoriteObject(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

            let leftBarButtonItem = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnBackClicked"))
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Group"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnGivePointsClicked"))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func updateProfile(){
        if baseUser != nil {
            baseUser.fetchIfNeededInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                if(error == nil && object != nil){
                    self.navigationItem.title = self.baseUser["fullName"] as String?
                }
            })
        }
    }
    
    func getFavoriteObject(notification: NSNotification!){

        if notification != nil {
            if self.favObject != nil {
                if notification.name == "MyLikedNotification" {
                    if self.favObject.objectId != notification.object?.objectId {
                        return
                    }
                } else {
                    if self.favObject.objectId != notification.object as? String {
                        return
                    }
                }
                
            }
        }
        if baseUser != nil {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let favQuery = PFQuery(className: "Favorites")
            favQuery.whereKey("fromUser", equalTo: PFUser.currentUser())
            favQuery.whereKey("toUser", equalTo: self.baseUser)
            favQuery.getFirstObjectInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                self.favObject = object
                self.setFavoriteStatus()
                MBProgressHUD.hideHUDForView(self.view, animated: false)
            })
        }
    }
    
    func setFavoriteStatus(){
//        self.m_contentTable.reloadData()
        if self.favObject == nil {
            headerView.setFavoriteStatus(false)
        }else{
            headerView.setFavoriteStatus(true)
        }

    }
    
    @IBAction func btnFavoriteClicked(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)

        if self.favObject == nil {
            self.favObject = PFObject(className: "Favorites")
            self.favObject.setObject(PFUser.currentUser(), forKey: "fromUser")
            self.favObject.setObject(baseUser, forKey: "toUser")
            self.favObject.saveInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
                self.setFavoriteStatus()
                MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                NSNotificationCenter.defaultCenter().postNotificationName("MyLikedNotification", object: self.favObject)
                let fullName = self.baseUser["fullName"] as String!
                UIAlertView(title: "Success", message: "You added \(fullName) in your friend list successfully.", delegate: nil, cancelButtonTitle: "Ok").show()
            })
        } else {
            let favObjId = self.favObject.objectId
            self.favObject.deleteInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
                self.favObject = nil
                self.setFavoriteStatus()
                MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
                NSNotificationCenter.defaultCenter().postNotificationName("MyUnlikedNotification", object: favObjId)
            })
        }
    }
    
    func btnBackClicked(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func reloadMyTimeLine(){
        
        if baseUser != nil {
            println("reloadMyTimeLine was called!")
            let user = baseUser
            
            let actionQuery1 = PFQuery(className: "Action")
            actionQuery1.whereKey("toUser", equalTo: user)
            let actionQuery2 = PFQuery(className: "Action")
            actionQuery2.whereKey("fromUser", equalTo: user)
            let orQuery = PFQuery.orQueryWithSubqueries([actionQuery1, actionQuery2])
            
            orQuery.orderByDescending("createdAt")
            orQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                println("ReloadMyTimeCall was completed")
                if objects != nil && error == nil {
                    self.arrComments = objects as [PFObject]
                    self.m_contentTable.reloadData()
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func btnGivePointsClicked(){
        println("btnGivePointsClicked")
        self.performSegueWithIdentifier("OGivePointsToPeopleSegueId", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "OGivePointsToPeopleSegueId" {
            let destController = segue.destinationViewController as GivePointsToPeopleViewController
            destController.user = baseUser
        }
    }
    
    // MARK: - UITableView Stuff
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            self.setFavoriteStatus()
            return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 203
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return arrComments.count
        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("profiletblCellId", forIndexPath: indexPath) as ProfileTableViewCell
        
        let user = PFUser.currentUser()
        let commentObj = arrComments[row] as PFObject
        
        if let comment = commentObj["comment"] as? String {
            cell.m_lblComment.text = comment
        } else {
            cell.m_lblComment.text = " "
        }
        
        cell.m_userPhoto.layer.cornerRadius = cell.m_userPhoto.frame.size.width / 2
//        cell.m_userPhoto.layer.borderColor = UIColor.greenColor().CGColor
//        cell.m_userPhoto.layer.borderWidth = 1
        cell.m_userPhoto.layer.masksToBounds = true

            let fromUser = commentObj["fromUser"] as PFUser
            let toUser = commentObj["toUser"] as PFUser
            let currentUser = PFUser.currentUser()

        fromUser.fetchIfNeededInBackgroundWithBlock { (fromUser: PFObject!, error: NSError!) -> Void in
            var fromUserName = fromUser["fullName"] as String
            if currentUser.objectId == fromUser.objectId {
                fromUserName = "You"
            }
            toUser.fetchIfNeededInBackgroundWithBlock({ (toUser: PFObject!, error: NSError!) -> Void in
                
                var toUserName = toUser["fullName"] as String
                if currentUser.objectId == toUser.objectId {
                    toUserName = "you"
                }
                let cUser = (self.baseUser.objectId == fromUser.objectId ? toUser : fromUser )
                
                if let coolPoints = commentObj["coolPoints"] as? NSNumber {
                    
                    cell.m_description.text = "\(fromUserName) gave \(toUserName) \(coolPoints.stringValue) points"
                    
                } else {
                    cell.m_description.text = " "
                }
                
                if let file = cUser["userPhoto"] as? PFFile {
                    file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        if data != nil && error == nil {
                            cell.m_userPhoto.image = UIImage(data: data)
                            
                        }
                    })
                }
                
            })
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy" //"M/d/yy"
        let dateStr = dateFormatter.stringFromDate(commentObj.createdAt)
        cell.m_createdAt.text = dateStr
        
        if (arrComments.count - indexPath.row) % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        
        return cell
    }
}