//
//  GivePointsViewController.swift
//  CoolPoints
//
//  Created by matti on 3/5/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class GivePointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var m_contentTable: UITableView!
    @IBOutlet weak var m_txtDescription: UITextView!
    @IBOutlet weak var m_searchBar: UISearchBar!
    var orQuery: PFQuery!
    
    var arrUsers : Array<PFUser> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Give Points"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyLikedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("getFavoriteObject:"), name: "MyUnlikedNotification", object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        if segue.identifier == "GivePointsStoryboardSegueId" {
            let destController = segue.destinationViewController as GivePointsToPeopleViewController
            destController.user = arrUsers[(m_contentTable.indexPathForSelectedRow()?.row)!]
        }
    }

    // MARK: - UITableView Stuff
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let gpCell = cell as GivePointsTableViewCell
        gpCell.cancelQueries()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 107
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GivePointsCellId", forIndexPath: indexPath) as GivePointsTableViewCell

        let user = arrUsers[indexPath.row]
        cell.refreshContents(user)
        
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
        if searchText == "" {
            arrUsers.removeAll(keepCapacity: false)
            m_contentTable.reloadData()
        }else {
            
            let xx = searchText
            let searchQuery1 = PFUser.query()
            searchQuery1.whereKey("fullName", matchesRegex: xx, modifiers: "i")
            
            let searchQuery2 = PFUser.query()
            searchQuery2.whereKey("email", matchesRegex: xx, modifiers: "i")
            
            let searchQuery3 = PFUser.query()
            searchQuery3.whereKey("bio", matchesRegex: xx, modifiers: "i")
            
            orQuery = PFQuery.orQueryWithSubqueries([searchQuery1, searchQuery2, searchQuery3])
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
    
    func getFavoriteObject(notification: NSNotification!){
        var userId : String
        if notification != nil {
            self.m_contentTable.reloadData()
        }
    }
}
