//
//  SearchByViewController.swift
//  CoolPoints
//
//  Created by matti on 3/11/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class SearchByViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var m_contentTable: UITableView!
    @IBOutlet weak var m_txtDescription: UITextView!
    @IBOutlet weak var m_searchBar: UISearchBar!

    var orQuery :PFQuery! = nil
    var arrUsers : Array<PFUser> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Search"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyLikedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyUnlikedNotification", object: nil)
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getFavoriteObject(notification: NSNotification!){
        var userId : String
        if notification != nil {
            self.m_contentTable.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let indexpath = m_contentTable.indexPathForSelectedRow() {
            m_contentTable.reloadRowsAtIndexPaths([indexpath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchedUserSegueId" {
            if let selectedIndexPath = self.m_contentTable.indexPathForSelectedRow() {

                let cUser = arrUsers[selectedIndexPath.row]
                cUser.fetchIfNeededInBackgroundWithBlock({ (object: PFObject!, error: NSError!) -> Void in
                    if(error == nil && object != nil){
                        let dest = segue.destinationViewController as OtherProfileViewController
                        dest.baseUser = cUser
                    }
                })
            }
        }
    }
    
    // MARK: - UITableView Stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GivePointsCellId") as GivePointsTableViewCell
        
        cell.m_userPhoto.image = nil
        cell.m_userLocation.text = ""
        cell.m_userName.text = ""
        cell.m_userCoolPoints.text = ""
        
        let user = arrUsers[indexPath.row]
        cell.refreshContents(user)
//        if let file = user["userPhoto"] as? PFFile {
//            file.getDataInBackgroundWithBlock({ (data: NSData!, error: NSError!) -> Void in
//                if data != nil && error == nil {
//                    cell.m_userPhoto.image = UIImage(data: data)
//                }
//            })
//        }
//        
//        if let location = user["location"] as? String {
//            cell.m_userLocation.text = location
//
//        }
//        
//        if let fullname = user["fullName"] as? String {
//            cell.m_userName.text = fullname
//        }
//        
//        let pointsQuery = PFQuery(className: "UserInfo")
//        pointsQuery.whereKey("user", equalTo: user)
//        pointsQuery.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
//            
//            if object != nil && error == nil {
//                if let coolPoints = object["coolPoints"] as? NSNumber {
//                    cell.m_userCoolPoints.text = coolPoints.stringValue + " pts"
//                }
//            }
//        }
        return cell
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        println(searchBar.text)
        self.searchUsers(searchBar.text)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        println(searchText)
        
        self.searchUsers(searchText)
        
    }
    
    func searchUsers(searchText: String){

        
        
        if orQuery != nil {
            orQuery.cancel()
            orQuery = nil
        }
        if searchText == "" || searchText == "#" {
            arrUsers.removeAll(keepCapacity: false)
            m_contentTable.reloadData()
        }else {
            
            if searchText.hasPrefix("#") == true {
                let xx = searchText.substringFromIndex(advance(searchText.startIndex, 1))
                orQuery = PFQuery(className: "Action")
                orQuery.whereKey("comment", matchesRegex: xx, modifiers: "i")
                orQuery.selectKeys(["toUser"])
                orQuery.includeKey("toUser")
                
                orQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    if let error = error {
                        println("Error: \(error)")
                    } else {
                        self.arrUsers.removeAll(keepCapacity: false)
                        for object in objects {
                            var i : Int
                            let objId = (object["toUser"] as PFUser).objectId
                            for i = 0; i < self.arrUsers.count; i++ {
                                let obj = self.arrUsers[i]
                                if obj.objectId == objId {
                                    self.arrUsers.removeAtIndex(i)
                                    break
                                }
                            }
                            self.arrUsers.append(object["toUser"] as PFUser)
                        }
//                        self.arrUsers = objects as Array<PFUser>
                        println("Search Completed: \(objects.count)")
                        self.m_contentTable.reloadData()
                    }
                    self.orQuery = nil
                })
            }else {
            
                let xx = searchText
                let searchQuery1 = PFUser.query()
                searchQuery1.whereKey("fullName", matchesRegex: xx, modifiers: "i")
                
                let searchQuery2 = PFUser.query()
                searchQuery2.whereKey("email", matchesRegex: xx, modifiers: "i")
                
                let searchQuery3 = PFUser.query()
                searchQuery3.whereKey("bio", matchesRegex: xx, modifiers: "i")
                
                let searchQuery4 = PFUser.query()
                searchQuery4.whereKey("location", matchesRegex: xx, modifiers: "i")
                
                orQuery = PFQuery.orQueryWithSubqueries([searchQuery1, searchQuery2, searchQuery3, searchQuery4])
                orQuery.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
                
                orQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                    if let error = error {
                        println("Error: \(error)")
                    } else {
                        self.arrUsers = objects as Array<PFUser>
                        println("Search Completed: \(objects.count)")
                        self.m_contentTable.reloadData()
                    }
                    self.orQuery = nil
                })
            }
        }
    }
    
}