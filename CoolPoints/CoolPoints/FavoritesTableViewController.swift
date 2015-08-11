//
//  FavoritesTableViewController.swift
//  CoolPoints
//
//  Created by matti on 2/25/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController, FavoritesCellDelegate {

    var arrFavorites = Array<PFObject>()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.loadContents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("addFavObject:"), name: "MyLikedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("removeFavObject:"), name: "MyUnlikedNotification", object: nil)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "Add_Invite"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAddInviteClicked"))
        
        let leftBarButtonItem2 = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnSearchClicked"))
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Group"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnGivePointsClicked"))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem1, leftBarButtonItem2]
        
        self.navigationItem.title = "Friends"

    }
    
    func addFavObject(notification: NSNotification!){
//        println("add: \(notification.object)")
        if notification != nil {
            if notification.object != nil {
                if notification.name == "MyLikedNotification" {
                    self.arrFavorites.insert(notification.object as PFObject, atIndex: 0)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        }
    }
    func removeFavObject(notification: NSNotification!){
//        println("remove: \(notification.object)")
        
        if notification != nil {
            if notification.object != nil {
                var idx : Int
                let objId = notification.object as String
                for idx = 0; idx < self.arrFavorites.count; ++idx {
                    let obj = self.arrFavorites[idx]
                    if obj.objectId == objId {
                        self.arrFavorites.removeAtIndex(idx)
                        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: idx, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                        break
                    }
                }
            }
        }
//        self.loadContents()
    }

    func loadContents(){
        let query = PFQuery(className: "Favorites")
        query.whereKey("fromUser", equalTo: PFUser.currentUser())
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.arrFavorites = objects as [PFObject]!
                self.tableView.reloadData()
            }
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
        return arrFavorites.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 107
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesCellId", forIndexPath: indexPath) as FavoritesTableViewCell

        // Configure the cell...
        let favObj = arrFavorites[indexPath.row];
        let favuser = favObj["toUser"] as PFUser
        
        cell.m_favButton.selected = false
        cell.indexPath = indexPath
        cell.delegate = nil
        
        let infoQuery = PFQuery(className: "UserInfo")
        infoQuery.whereKey("user", equalTo: favuser)
        infoQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if error == nil {
                cell.m_userCoolPoints.text = object["coolPoints"].stringValue + " pts"
            }
        }
        
        favuser.fetchIfNeededInBackgroundWithBlock { (user: PFObject!, error: NSError!) -> Void in
            if error == nil {
                cell.m_favButton.selected = true
                cell.m_userName.text = user["fullName"] as? String
                cell.delegate = self
                if let location = user["location"] as? String {
                    cell.m_userLocation.text = location
                }
                
                if let file = favuser["userPhoto"] as? PFFile {
                    file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
                        if data != nil && error == nil {
                            cell.m_userPhoto.image = UIImage(data: data)
                        }
                    })
                }
            }
        }

        if (arrFavorites.count - indexPath.row) % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        return cell
    }


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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "OtherProfileSegueId" {
            
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow() {
                let favObj = arrFavorites[selectedIndexPath.row];
                let favuser = favObj["toUser"] as PFUser
                let dest = segue.destinationViewController as OtherProfileViewController
                dest.baseUser = favuser
            }
        }
    }

    
    // MARK: - Favorites Cell Delegate
    
    func btnFavClicked(indexPath: NSIndexPath) {
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        let favObject = arrFavorites[indexPath.row]
        let favObjId = favObject.objectId
        favObject.deleteInBackgroundWithBlock({ (succeed: Bool, error: NSError!) -> Void in
            if succeed == true && error == nil {
                println("Successfully unfavorited!")
            }
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
            
            NSNotificationCenter.defaultCenter().postNotificationName("MyUnlikedNotification", object: favObjId)
        })
        arrFavorites.removeAtIndex(indexPath.row)
        self.tableView.reloadData()
        
    }
    
    // MARK: - NavigationItem Delegate
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
}
