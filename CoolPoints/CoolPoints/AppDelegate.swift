//
//  AppDelegate.swift
//  CoolPoints
//
//  Created by matti on 2/24/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import Parse
import Bolts

let TWITTER_CONSUMER_KEY = "NZAmnQ4eIDmUposOAw884NzF6"//"1OXvFhSE38QtyKJ2UTqKkTjgM"
let TWITTER_CONSUMER_SECRET = "BWBLLfEmDXD8M0o4vgt96T17dXYYcFeBcNgZFY1xMbrvJyPXOB"//"772RRs2toTVVQeJtJnTC9ptmi9jHrkyjgoDPHO4jd8OFatJRu7"
let TWITTER_TOKEN = "TWITTER_TOKEN"
let TWITTER_SECRET = "TWITTER_SECRET"
let PARSE_APPLICATION_ID = "zV3SLjRTdoh2oVx1rpdu5SW4ONSJ3mkqmtM6Znzk"
let PARSE_CLIENT_KEY = "jojo4fbK8YxRBf8uzAxxkJgIEDZttzyXjdLTpdK6"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId(PARSE_APPLICATION_ID, clientKey: PARSE_CLIENT_KEY)
        
//        PFFacebookUtils.initializeFacebook()
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFTwitterUtils.initializeWithConsumerKey(TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        if url.scheme? == "coolpoints" {
            let d = self.parametersDictionaryFromQueryString(url.query)
            let token = d["oauth_token"] as? String
            let verifier = d["oauth_verifier"] as? String
            
            TwitterManager.sharedTwitter.setOAuthToken(token, verifier: verifier)
            return true
        }else {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//            return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
        }
    }
    func parametersDictionaryFromQueryString(queryString: String?) -> NSDictionary!{
        let md = NSMutableDictionary()
        if let queryString = queryString {
            let queryComponents = queryString.componentsSeparatedByString("&")
            for s in queryComponents {
                let pair = s.componentsSeparatedByString("=")
                if pair.count != 2 {
                    continue
                }
                
                let key = pair[0]
                let value = pair[1]
                
                md[key] = value
            }
        }
        return md
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

