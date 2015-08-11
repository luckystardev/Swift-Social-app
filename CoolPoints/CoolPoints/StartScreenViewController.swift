//
//  StartScreenViewController.swift
//  CoolPoints
//
//  Created by macos on 3/11/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("TimerFired"), userInfo: nil, repeats: false)
    }
    
    func TimerFired(){
        UIApplication.sharedApplication().keyWindow?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserManagerStoryboardId") as? UIViewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
