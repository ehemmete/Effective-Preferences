//
//  AppDelegate.swift
//  EffectivePreferences
//
//  Created by Eric.Hemmeter on 7/26/19.
//  Copyright © 2019 Sneakypockets. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func flatten(_ array: [Any]) -> [Any] {

        return array.reduce([Any]()) { result, current in
            switch current {
            case(let arrayOfAny as [Any]):
                return result + flatten(arrayOfAny)
            default:
                return result + [current]
            }
        }
    }
    
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var outputLabel: NSTextField!
    @IBOutlet var prefDomainTextField: NSTextField!
    @IBOutlet var keyTextField: NSTextField!
    
    @IBAction func lookupButton(_ sender: NSButton) {
        let preferenceDomain = prefDomainTextField.stringValue
        let key = keyTextField.stringValue
        if key.isEmpty {
            let optionsArray = [(preferenceDomain as CFString, kCFPreferencesCurrentUser, kCFPreferencesAnyHost),
                                (preferenceDomain as CFString, kCFPreferencesAnyUser, kCFPreferencesAnyHost),
                                (preferenceDomain as CFString, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost),
                                (preferenceDomain as CFString, kCFPreferencesAnyUser, kCFPreferencesCurrentHost)]
            let keys = optionsArray.compactMap { (opt1, opt2, opt3) in return CFPreferencesCopyKeyList(opt1, opt2, opt3) }
            if keys.isEmpty {
                outputLabel.stringValue = String("No keys found")
            } else {
                
                //let array = keys.compactMap { $0 as? String }
                
                let array_temp = flatten(keys)
                print(array_temp)
                let array = array_temp as! [String]
                let output = array.joined(separator: "\n")
                outputLabel.stringValue = output
            }
        } else {
            
            if let properyList = CFPreferencesCopyAppValue(key as CFString, preferenceDomain as CFString) {
                let data = CFPropertyListCreateData(nil, properyList, .xmlFormat_v1_0, 0, nil).takeRetainedValue()
                
                outputLabel.stringValue = String(data: data as Data, encoding: .utf8) ?? String("No result")
            } else {
                outputLabel.stringValue = String("No result")
            }
        }
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

