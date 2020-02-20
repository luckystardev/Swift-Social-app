//
//  ProfileViewController.swift
//  CoolPoints
//
//  Created by tmaas510 on 2/25/15.
//  Copyright (c) 2015 tmaas510. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var m_contentTable: UITableView!
    @IBOutlet weak var m_profileView: UIView!
    
    var arrComments: Array<PFObject> = []
    var refreshControl : UIRefreshControl!
    
    var topDate : NSDate!
    var bottomDate : NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadMyTimeLine"), forControlEvents: UIControlEvents.ValueChanged)
        m_contentTable.addSubview(refreshControl)

        topDate = nil
        bottomDate = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadProfile:"), name: "UserBasicProfileChanged", object: nil)
    }
    
    func reloadProfile(notification: NSNotification!){
        self.m_contentTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
            let leftBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "Add_Invite"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAddInviteClicked"))
            
            let leftBarButtonItem2 = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnSearchClicked"))
            
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Group"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnGivePointsClicked"))
            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            self.navigationItem.leftBarButtonItems = [leftBarButtonItem1, leftBarButtonItem2]

        self.navigationItem.title = "Profile"

        self.reloadMyTimeLine()
    }
    
    func btnBackClicked(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func reloadMyTimeLine(){
        println("reloadMyTimeLine was called!")
        let user = PFUser.currentUser()
        
        let actionQuery1 = PFQuery(className: "Action")
        actionQuery1.whereKey("toUser", equalTo: user)
        let actionQuery2 = PFQuery(className: "Action")
        actionQuery2.whereKey("fromUser", equalTo: user)
        let orQuery = PFQuery.orQueryWithSubqueries([actionQuery1, actionQuery2])
        
        orQuery.orderByDescending("createdAt")
        if topDate != nil {
            orQuery.whereKey("createdAt", greaterThan: topDate)
        }
        orQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            println("ReloadMyTimeCall was completed")
            if objects != nil && error == nil {
                self.arrComments = (objects as [PFObject]) + self.arrComments
                var arrIndexPaths : Array<NSIndexPath> = []
                var i : Int
                for i = 0; i < objects.count; i++ {
                    let indexPath = NSIndexPath(forRow: i, inSection: 1)
                    arrIndexPaths.append(indexPath)
                }
                if self.arrComments.count > 0 {
                    self.topDate = self.arrComments[0].createdAt
                }
                self.m_contentTable.insertRowsAtIndexPaths(arrIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)

            }
            self.refreshControl.endRefreshing()
            
        }
    }
    
    func btnGivePointsClicked(){
        println("btnGivePointsClicked")
        self.performSegueWithIdentifier("gotoGivePointsControllerSegueId", sender: self)
    }
    
    func btnSearchClicked(){
        println("btnSearchClicked")
        self.performSegueWithIdentifier("SearchByVCSegueId", sender: self)
    }
    
    func btnAddInviteClicked(){
        println("btnAdd_InviteClicked")
        self.performSegueWithIdentifier("AddInviteSegueId", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OtherProfileSegueId" {
            
            if let selectedIndexPath = self.m_contentTable.indexPathForSelectedRow() {
            
                let user = PFUser.currentUser()
                let commentObj = arrComments[selectedIndexPath.row] as PFObject
                if let cUser = (user.objectId == commentObj["toUser"].objectId ? commentObj["fromUser"] as? PFUser : commentObj["toUser"] as? PFUser) {
                    let dest = segue.destinationViewController as OtherProfileViewController
                    dest.baseUser = cUser
//                    dest.loadContents()
                }
            }
        }
    }

    // MARK: - UITableView Stuff
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableCellWithIdentifier("MyProfileSectionHeaderTableViewCell") as MyProfileSectionHeaderTableViewCell
            headerView.setUser(PFUser.currentUser())

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
        if section == 1{
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
//            cell.m_comment.text = comment
            cell.m_lblComment.text = comment
        } else {
//            cell.m_comment.text = " "
            cell.m_lblComment.text = " "
        }

        cell.m_userPhoto.image = nil
        
        if let cUser = (user.objectId == commentObj["toUser"].objectId ? commentObj["fromUser"] as? PFUser : commentObj["toUser"] as? PFUser) {
            
            cUser.fetchIfNeededInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                if object != nil && error == nil {
                
                    if let coolPoints = commentObj["coolPoints"] as? NSNumber {
                        if let fullname = cUser["fullName"] as? String {
                        
                            if user.objectId == commentObj["toUser"].objectId {
                                cell.m_description.text = "\(fullname) gave you \(coolPoints.stringValue) points"
                            }else {
                                cell.m_description.text = "You gave \(fullname) \(coolPoints.stringValue) points"
                            }
                        }
                    } else {
                        cell.m_description.text = " "
                    }
                    
                    if let file = object["userPhoto"] as? PFFile {
                        file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                            if data != nil && error == nil {
                                cell.m_userPhoto.image = UIImage(data: data)
                                
                            }
                        })
                    }
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
