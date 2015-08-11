//
//  TimelineCollectionViewController.swift
//  CoolPoints
//
//  Created by matti on 2/26/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

let reuseIdentifier = "profileCollectionViewCellId"

class TimelineCollectionViewController: UICollectionViewController, MosaicLayoutDelegate {

    var arrComments: Array<PFObject> = []
    var arrFavUsers: Array<PFUser> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        (self.collectionViewLayout as MosaicLayout).delegate = self
        // Do any additional setup after loading the view.
        self.reloadContents()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadContents"), name: "MyLikedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadContents"), name: "MyUnlikedNotification", object: nil)
        
    }
    
    func reloadContents(){
        let user = PFUser.currentUser()
        let favUserQuery = PFQuery(className: "Favorites")
        favUserQuery.whereKey("fromUser", equalTo: user)
        favUserQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil && error == nil {
                self.arrFavUsers.removeAll(keepCapacity: false)
                for object in objects {
                    self.arrFavUsers.append(object["toUser"] as PFUser)
                }
                let actionQuery1 = PFQuery(className: "Action")
                actionQuery1.whereKey("toUser", containedIn: self.arrFavUsers)
                let actionQuery2 = PFQuery(className: "Action")
                actionQuery2.whereKey("fromUser", containedIn: self.arrFavUsers)
                let orQuery = PFQuery.orQueryWithSubqueries([actionQuery1, actionQuery2])
                orQuery.orderByDescending("createdAt")
                orQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    if objects != nil && error == nil {
                        self.arrComments = objects as [PFObject]
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Timeline"
        
        let leftBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "Add_Invite"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAddInviteClicked"))
        
        let leftBarButtonItem2 = UIBarButtonItem(image: UIImage(named: "search"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnSearchClicked"))
        
        let rightBarButtonItem = /*UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("btnGivePointsClicked"))*/UIBarButtonItem(image: UIImage(named: "Group"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnGivePointsClicked"))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem1, leftBarButtonItem2]
        
    }

    func btnGivePointsClicked(){
        println("btnGivePointsClicked")
        self.performSegueWithIdentifier("GivePointsFromTimelineSegueId", sender: self)
    }
    
    func btnSearchClicked(){
        println("btnSearchClicked")
        self.performSegueWithIdentifier("SearchByFromTimelineSegueId", sender: self)
    }
    
    func btnAddInviteClicked(){
        println("btnAdd_InviteClicked")
        self.performSegueWithIdentifier("AddInviteFromTimelineSegueId", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "OtherProfileSegueId" {
            let arrSelectedItems = self.collectionView?.indexPathsForSelectedItems()
            if let indexPath = arrSelectedItems?.first as? NSIndexPath {
                var row = indexPath.row
                row = (row > 1) ? row - 1 : row
                
                let user = PFUser.currentUser()
                let commentObj = arrComments[row] as PFObject
                if let cUser = commentObj["fromUser"] as? PFUser {//(user.objectId == commentObj["toUser"].objectId ? commentObj["fromUser"] as? PFUser : commentObj["toUser"] as? PFUser) {
                    if cUser.objectId == user.objectId {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "OtherProfileSegueId" {
            let arrSelectedItems = self.collectionView?.indexPathsForSelectedItems()
            if let indexPath = arrSelectedItems?.first as? NSIndexPath {
                var row = indexPath.row
                row = (row > 1) ? row - 1 : row
                
                let user = PFUser.currentUser()
                let commentObj = arrComments[row] as PFObject
                if let cUser = commentObj["fromUser"] as? PFUser {//(user.objectId == commentObj["toUser"].objectId ? commentObj["fromUser"] as? PFUser : commentObj["toUser"] as? PFUser) {
                    let dest = segue.destinationViewController as OtherProfileViewController
                    dest.baseUser = cUser
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return arrComments.count > 1 ? arrComments.count + 2 : arrComments.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        var row = indexPath.row
        if row == 1 || row == arrComments.count + 1 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("emptyCollectionViewCellId", forIndexPath: indexPath) as UICollectionViewCell
        }
        row = (row > 1) ? row - 1 : row
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("profileCollectionViewCellId", forIndexPath: indexPath) as ProfileCollectionViewCell
        let commentObj = arrComments[row] as PFObject
        cell.setData(commentObj, row: row)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    
    // MARK: Mosaic Layout Delegate
    
    func collectionView(collectionView: UICollectionView!, relativeHeightForItemAtIndexPath indexPath: NSIndexPath!) -> Float {
        if indexPath.row == 1 || indexPath.row == arrComments.count + 1 {
            return 0.5
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, isDoubleColumnAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    func numberOfColumnsInCollectionView(collectionView: UICollectionView!) -> UInt {
        return 2
    }
    
}
