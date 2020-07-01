//
//  AppDelegate.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/15/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    let keychain = KeychainSwift(keyPrefix: "ahmed")
       let device = UIDevice.current
       let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
       let myUrl = "https://developx.ir/license/api/"
       let myApp = 1
       let myStore = "site"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        observeReachability()
        checkFunc()
        return true
    }
    private var reachability : Reachability!
    
    func observeReachability() {
        self.reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            let active: Bool = (keychain.get("active") != nil)
            if active {
                let myToken = keychain.get("myToken")
                let myEmail = keychain.get("myEmail")
                let myDevice = keychain.get("deviceId")
                
                let params2 = ["t" : myToken!]
                
                AMLicense().fetchData(url: myUrl+"checkValid.php", params: params2, loader: false) { (json) in
                    if json["status"] as! Int == 200 {
                        
                        let email = json["e"] as! String
                        let deviceId = json["dId"] as! String
                        
                        if ((myEmail == email) && (myDevice == deviceId)) {
                            
                            self.showRootView(id: "mpg")
                            
                        } else {
                            
                            self.keychain.delete("active")
                            self.keychain.delete("myEmail")
                            self.keychain.delete("myToken")
                            
                            self.showRootView(id: "license")
                        }
                        
                    } else if (json["status"] as! Int == 190) {
                        
                        self.keychain.delete("active")
                        self.keychain.delete("myEmail")
                        self.keychain.delete("myToken")
                        
                        self.showRootView(id: "license")
                        
                    } else {
                        AMLicense().alertView(alertText: json["error"] as! String)
                    }
                }
            }
            break
        case .wifi:
            let active: Bool = (keychain.get("active") != nil)
            if active {
                let myToken = keychain.get("myToken")
                let myEmail = keychain.get("myEmail")
                let myDevice = keychain.get("deviceId")
                
                let params2 = ["t" : myToken!]
                
                AMLicense().fetchData(url: myUrl+"checkValid.php", params: params2, loader: false) { (json) in
                    if json["status"] as! Int == 200 {
                        
                        let email = json["e"] as! String
                        let deviceId = json["dId"] as! String
                        
                        if ((myEmail == email) && (myDevice == deviceId)) {
                            
                            self.showRootView(id: "mpg")
                            
                        } else {
                            
                            self.keychain.delete("active")
                            self.keychain.delete("myEmail")
                            self.keychain.delete("myToken")
                            
                            self.showRootView(id: "license")
                        }
                        
                    } else if (json["status"] as! Int == 190) {
                        
                        self.keychain.delete("active")
                        self.keychain.delete("myEmail")
                        self.keychain.delete("myToken")
                        
                        self.showRootView(id: "license")
                        
                    } else {
                        AMLicense().alertView(alertText: json["error"] as! String)
                    }
                }
            }
            break
        case .none:
            print("Network is not available.")
            break
        case .unavailable:
            print("Network is not available.")
            break
        }
    }
    
    func checkFunc() {
        
        let appOpen: Bool = (keychain.get("appOpen") != nil)
        let active: Bool = (keychain.get("active") != nil)
        let deviceId: String? = keychain.get("deviceId")
        
        if appOpen {
            // Update Device
            let params = ["dVr" : device.systemVersion,
                          "dnm" : device.name,
                          "aVr" : version,
                          "oId" : deviceId!] as [String : Any]
            
            AMLicense().fetchData(url: myUrl+"update.php", params: params, loader: false) { (json) in
                if json["status"] as! Int != 200 {
                    AMLicense().alertView(alertText: json["error"] as! String)
                }
            }
            
            if active {
                let myToken = keychain.get("myToken")
                let myEmail = keychain.get("myEmail")
                let myDevice = keychain.get("deviceId")
                
                self.showRootView(id: "mpg")
                
                let params2 = ["t" : myToken!]
                
                AMLicense().fetchData(url: myUrl+"checkValid.php", params: params2, loader: false) { (json) in
                    if json["status"] as! Int == 200 {
                        
                        let email = json["e"] as! String
                        let deviceId = json["dId"] as! String
                        
                        if ((myEmail == email) && (myDevice == deviceId)) {
                            
                            self.showRootView(id: "mpg")
                            
                        } else {
                            
                            self.keychain.delete("active")
                            self.keychain.delete("myEmail")
                            self.keychain.delete("myToken")
                            
                            self.showRootView(id: "license")
                        }
                        
                    } else if (json["status"] as! Int == 190) {
                        
                        self.keychain.delete("active")
                        self.keychain.delete("myEmail")
                        self.keychain.delete("myToken")
                        
                        self.showRootView(id: "license")
                        
                    } else {
                        AMLicense().alertView(alertText: json["error"] as! String)
                    }
                }
            } else {
                self.showRootView(id: "license")
            }
            
        } else {
            // Create New Device
            let params = ["aID" : myApp,
                          "uID" : device.identifierForVendor!.uuidString,
                          "str" : myStore,
                          "dVr" : device.systemVersion,
                          "dtp" : device.model,
                          "dnm" : device.name,
                          "aVr" : version,
                          "dmd" : device.modelName
                ] as [String : Any]
            
            AMLicense().fetchData(url: myUrl+"create.php", params: params, loader: false) { (json) in
                if json["status"] as! Int == 200 {
                    self.keychain.set(true, forKey: "appOpen")
                    self.keychain.set(json["objId"] as! String, forKey: "deviceId")
                } else {
                    AMLicense().alertView(alertText: json["error"] as! String)
                }
                
                self.showRootView(id: "license")
            }
        }
    }
    
    func showRootView(id: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()

    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if urlComponents?.host == "license" {
            let items = (urlComponents?.queryItems)! as [NSURLQueryItem]
            let dictionary = [items[0].name : items[0].value!,
                              items[1].name : items[1].value!]
            
            if dictionary["status"] == "NO" {
                AMLicense().alertView(alertText: "خرید کامل نشد.")
            }
            if (dictionary["status"] == "reactive") {
                AMLicense().alertView(alertText: "لطفا ری اکتیو کنید.")
            }
            if (dictionary["status"] == "OK") {
                checkPay(e: dictionary["email"]!)
            }
        }
        return true
    }
    
    func checkPay(e: String) {
        
        let params = ["e" : e, "aId" : myApp] as [String : Any]
        
        AMLicense().fetchData(url: myUrl+"checkPay.php", params: params, loader: true) { (json) in
            if json["status"] as! Int == 200 {
                self.keychain.set(true, forKey: "active")
                self.keychain.set(json["email"] as! String, forKey: "myEmail")
                self.keychain.set(json["token"] as! String, forKey: "myToken")
                
                self.showRootView(id: "mpg")
            } else {
                AMLicense().alertView(alertText: json["error"] as! String)
            }
        }
    }



}

