//
//  LinkTwitterViewController.swift
//  CoolPoints
//
//  Created by matti on 2/24/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import Social

class TwitterManager :NSObject {
    var twitter : STTwitterAPI!
    var oauthAccessToken : String!
    var oauthAccessTokenSecret : String!
    
    class var sharedTwitter : TwitterManager {
        struct Singleton {
            static let instance = TwitterManager()
        }
        return Singleton.instance
    }

    override init(){
        super.init()
        
        self.twitter = STTwitterAPI(OAuthConsumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let oat = userDefaults.objectForKey(TWITTER_TOKEN) as? String {
            self.oauthAccessToken = oat
        }

        if let oats = userDefaults.objectForKey(TWITTER_SECRET) as? String {
            self.oauthAccessTokenSecret = oats
        }

    }
    func startTwitter(){
        if (oauthAccessToken != nil && oauthAccessTokenSecret != nil) {

            self.twitter = STTwitterAPI(OAuthConsumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET, oauthToken: oauthAccessToken, oauthTokenSecret: oauthAccessTokenSecret)
            
            self.twitter.verifyCredentialsWithSuccessBlock({ (username: String!) -> Void in
                let twitterInfo = ["token": self.oauthAccessToken, "secret" : self.oauthAccessTokenSecret]
                let dict = ["twitterUserInfo":twitterInfo]
                NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: "TwitterTokenSecretNotification", object: self, userInfo: dict), postingStyle: NSPostingStyle.PostWhenIdle)
                
                }, errorBlock: { (error: NSError!) -> Void in
                println("Error: \(error)")
            })
            
        } else{

            self.twitter = STTwitterAPI(OAuthConsumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
            
            self.twitter.postTokenRequest({ (url: NSURL!, oauthToken: String!) -> Void in
                
                println("URL: \(url)")
                println("oauthToken: \(oauthToken)")
                UIApplication.sharedApplication().openURL(url)
                
                }, authenticateInsteadOfAuthorize: false,
                forceLogin: NSNumber(bool: true),
                screenName: nil,
                oauthCallback: "coolpoints://swapp.com/callback",
                errorBlock: { (error: NSError!) -> Void in
                    println("Error: \(error)")
                }
            )
        }
    }
    func setOAuthToken(token : String?, verifier : String?){
        
        if let token = token {
        if let verifier = verifier {
        
            self.twitter.postAccessTokenRequestWithPIN(verifier, successBlock: { (oauthToken: String!, oauthTokenSecret: String!, userId: String!, screenName: String!) -> Void in
                
                println("Screen Name: \(screenName)")
                
                self.oauthAccessToken = oauthToken
                self.oauthAccessTokenSecret = oauthTokenSecret
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(self.oauthAccessToken, forKey: TWITTER_TOKEN)
                userDefaults.setObject(self.oauthAccessTokenSecret, forKey: TWITTER_SECRET)
                userDefaults.synchronize()
                
                let twitterInfo = ["token": self.oauthAccessToken, "secret" : self.oauthAccessTokenSecret]
                let dict = ["twitterUserInfo":twitterInfo]
                NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: "TwitterTokenSecretNotification", object: self, userInfo: dict), postingStyle: NSPostingStyle.PostWhenIdle)
                
                }, errorBlock: { (error: NSError!) -> Void in
                    println("Error: \(error)")
                }
            )
        }
        }
    }
    func post(tracklink: String, imglink:String){
        
        let user = PFUser.currentUser()
        let userName = user["fullName"] as String
//        let mediaurl = NSURL(string: imglink) as NSURL!
        let status = "\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(PFUser.currentUser().objectId)"
        
        self.twitter.postStatusUpdate(status, inReplyToStatusID: nil, latitude: nil, longitude: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, successBlock: { (objects: [NSObject : AnyObject]!) -> Void in
            println("Successfully updated: \(status)")
            }) { (error: NSError!) -> Void in
            println("Error in updating status: \(error)")
        }
//        self.twitter.postStatusUpdate(status, inReplyToStatusID: nil, mediaURL: nil, placeID: nil, latitude: nil, longitude: nil, uploadProgressBlock: { (bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) -> Void in
//                println("Uploading...")
//            }, successBlock: { (objects: [NSObject : AnyObject]!) -> Void in
//                println("Successfully uploaded: \(status)")
//            }) { (error: NSError!) -> Void in
//                println("Error in uploading: \(error)")
//        }
    }
}

class LinkTwitterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Sign Up"
        
        self.navigationItem.hidesBackButton = true
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

    func addCoolPointsForSocial(){
        let query = PFQuery(className: "UserInfo")
        var coolPoints : NSNumber!
        var obj : PFObject!
        query.whereKey("user", equalTo: PFUser.currentUser())
        obj = query.getFirstObject()
        if obj != nil {
            coolPoints = obj["coolPoints"] as NSNumber
            obj["coolPoints"] = NSNumber(longLong: coolPoints.longLongValue + 1500)
        }else{
            obj = PFObject(className: "UserInfo")
            obj["user"] = PFUser.currentUser()
            obj["coolPoints"] = NSNumber(unsignedLongLong: 1500)
        }

        obj.save()
    }
    
    func shareTwitter(iText: NSString?){
        var bodyString = "status= "
        if let iText = iText {
            bodyString = "status=\(iText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        }
        
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
        var tweetRequest = NSMutableURLRequest(URL: url!)
        tweetRequest.HTTPMethod = "POST"
        tweetRequest.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        PFTwitterUtils.twitter().signRequest(tweetRequest)
        if let allHeaderFields = tweetRequest.allHTTPHeaderFields {
            println(allHeaderFields)
            
        }
        
        var response: NSURLResponse? = nil
        var error : NSError? = nil
        let data : NSData! = NSURLConnection.sendSynchronousRequest(tweetRequest, returningResponse: &response, error: &error)
        
        if let error = error {
            println("Error: \(error)")
        } else {
            println("Response: \(response)")
        }
    }
    
    @IBAction func btnLinkTwitterClicked(sender: AnyObject) {
        let user = PFUser.currentUser()
        if PFTwitterUtils.isLinkedWithUser(user) == false {
            PFTwitterUtils.linkUser(user, block: { (succeeded: Bool, error: NSError!) -> Void in
                if succeeded == true {
                    self.shareTwitter("Testing2")
                }else {
                    UIAlertView(title: "Error", message: "An error was occurred while linking Twitter", delegate: nil, cancelButtonTitle: "Ok").show()
                }
                
            })
        }else{
            self.shareTwitter("Testing1")
        }
        

        //        ==========================================
        
//        let user = PFUser.currentUser()
//        let userName = user["fullName"] as String
//        /* ============ Share on Twitter ============ */
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
//            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            twitterSheet.addURL(NSURL(string: "http://www.apple.com"))
//            twitterSheet.setInitialText("\(userName) has invited you to sign up for a free CoolPoints account. By following this link and entering the code below you will receive 150 FREE CoolPoints.\nURL\nRedemption Code = \(user.objectId)")
//            twitterSheet.completionHandler = { result -> Void in
//                var getResult = result as SLComposeViewControllerResult
//                switch(getResult.rawValue){
//                case SLComposeViewControllerResult.Cancelled.rawValue: println("Cancelled")
//                case SLComposeViewControllerResult.Done.rawValue:
//                    println("Done")
//                    self.addCoolPointsForSocial()
//                default: println("Error!")
//                }
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            self.presentViewController(twitterSheet, animated: true, completion: nil)
//        }else {
//            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }

        
        
//        ==========================================
        
        
        
/*        NSURL *requestURL = [NSURL URLWithString:@"https://upload.twitter.com/1.1/statuses/update_with_media.json"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        request.HTTPMethod = @"POST";
        NSString *stringBoundary = @"---------------------------14737809831466499882746641449";
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [descView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // add image data
        NSData *imageData = UIImageJPEGRepresentation(bigImage, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"media[]\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set URL
        [request setURL:requestURL];
        
        
        // Construct the parameters string. The value of "status" is percent-escaped.
        
        
        [[PFTwitterUtils twitter] signRequest:request];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        // Post status synchronously.
        NSData *data1 = [NSURLConnection sendSynchronousRequest:request
            returningResponse:&response
            error:&error];
        
        // Handle response.
        if (!error) {
            NSString *responseBody = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            NSLog(@"Error: %@", responseBody);
        } else {
            NSLog(@"Error: %@", error);
        }*/
        
//        return
        
        
//---------------------------------------------------------------------------------------
//        let user = PFUser.currentUser()
//        TwitterManager.sharedTwitter.startTwitter()
//        let twitter = STTwitterAPI(appOnlyWithConsumerKey: "1OXvFhSE38QtyKJ2UTqKkTjgM", consumerSecret: "772RRs2toTVVQeJtJnTC9ptmi9jHrkyjgoDPHO4jd8OFatJRu7")
//        STTwitterAPI *twitter = [[STTwitterAPI alloc] init];
//        
//        STTwitterAppOnly *appOnly = [STTwitterAppOnly twitterAppOnlyWithConsumerName:consumerName consumerKey:consumerKey consumerSecret:consumerSecret];
//        
//        twitter.oauth = appOnly;
//        
//        return twitter;
        
        
//        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
//        if PFTwitterUtils.isLinkedWithUser(user) == false {
//            PFTwitterUtils.linkUser(user, block: { (succeeded: Bool, error: NSError!) -> Void in
//                if PFTwitterUtils.isLinkedWithUser(user) == true {
//                    println("User logged in with Twitter")
//                    let query = PFQuery(className: "UserInfo")
//                    var coolPoints : NSNumber!
//                    var obj : PFObject!
//                    query.whereKey("user", equalTo: PFUser.currentUser())
//                    obj = query.getFirstObject()
//                    if obj != nil {
//                        coolPoints = obj["coolPoints"] as NSNumber
//                        obj["coolPoints"] = NSNumber(longLong: coolPoints.longLongValue + 1500)
//                    }else{
//                        obj = PFObject(className: "UserInfo")
//                        obj["user"] = PFUser.currentUser()
//                        obj["coolPoints"] = NSNumber(unsignedLongLong: 1500)
//                    }
//
//                    obj.save()
//                    
//                    MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
//                    self.performSegueWithIdentifier("LinkWithFacebookSegueId", sender: self)
//                }else {
//                    MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: false)
//                    println("Linking with Twitter was just failed!")
//                    println("Error: \(error)")
//                }
//            })
//        }
    }
}
