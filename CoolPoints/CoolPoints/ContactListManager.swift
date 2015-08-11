//
//  ContactListManager.swift
//  CoolPoints
//
//  Created by matti on 3/4/15.
//  Copyright (c) 2015 matti. All rights reserved.
//

import UIKit
import AddressBookUI
import MessageUI

class ContactListManager: ABPeoplePickerNavigationController, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var pickedContactInfo : NSMutableDictionary!
    var superController : UIViewController!
    class var SharedInstance:ContactListManager
    {
        contactListManager.peoplePickerDelegate = contactListManager
        return contactListManager
    }
    
    // MARK: - PeoplePickerNavigationController Delegate
    func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
        pickedContactInfo = NSMutableDictionary()
        
        self.setValueForInvite(person, propertyType: kABPersonFirstNameProperty, myKey: "firstName")
        self.setValueForInvite(person, propertyType: kABPersonLastNameProperty, myKey: "lastName")
        
        let phonesRef: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        
        let count = ABMultiValueGetCount(phonesRef)
        for index in 0...count-1{
            var currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, index).takeRetainedValue()
            let currentPhoneValue : NSString! = ABMultiValueCopyValueAtIndex(phonesRef, index).takeRetainedValue() as NSString
            
            if CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, CFStringCompareFlags.allZeros) == CFComparisonResult.CompareEqualTo {
                pickedContactInfo.setObject(currentPhoneValue, forKey: "mobileNumber")
                println("PhoneValue: \(currentPhoneValue)")
            }
            
            if CFStringCompare(currentPhoneLabel, kABPersonPhoneIPhoneLabel, CFStringCompareFlags.allZeros) == CFComparisonResult.CompareEqualTo {
                pickedContactInfo.setObject(currentPhoneValue, forKey: "iPhoneNumber")
                println("iPhoneValue: \(currentPhoneValue)")
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            if MFMessageComposeViewController.canSendText() == false {
                UIAlertView(title: "Error", message: "Unable to send SMS message.", delegate: nil, cancelButtonTitle: "Ok").show()
            }else{
                
                var phoneNumber : NSString! = nil
                if self.pickedContactInfo["iPhoneNumber"] != nil {
                    phoneNumber = self.pickedContactInfo["iPhoneNumber"] as NSString
                }else if self.pickedContactInfo["mobileNumber"] != nil {
                    phoneNumber = self.pickedContactInfo["mobileNumber"] as NSString
                }
                if(phoneNumber != nil){
                    let sms = MFMessageComposeViewController()
                    sms.messageComposeDelegate = self
                    sms.recipients = [phoneNumber]
                    sms.body = "Hi, How are you?\nCoolPoints is inviting you for fun!\n"
                    self.superController!.presentViewController(sms, animated: true, completion: nil)
                }
            }
        })
    }
    
    func setValueForInvite(person : ABRecord!, propertyType:ABRecordID, myKey: NSString){
        let firstName = ABRecordCopyValue(person, propertyType).takeRetainedValue() as? NSString
        if firstName != nil{
            pickedContactInfo.setObject(firstName!, forKey: myKey)
        }else{
            pickedContactInfo.setObject("", forKey: myKey)
        }
    }
    
    // MARK: - MessageComposerViewController Delegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.superController = nil
        })
    }
}
let contactListManager = ContactListManager()