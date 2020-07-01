//
//  AMLicense.swift
//  License2
//
//  Created by Ali Mirzamani on 7/29/18.
//  Copyright © 2018 Ali Mirzamani. All rights reserved.
//

import UIKit
import MKProgress
import Alamofire
public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}


class AMLicense: NSObject {
    
    // MARK: - General Defenitions
    var privateKeyRef: SecKey? = nil
    var publicKeyRef: SecKey? = nil
    let keychain = KeychainSwift(keyPrefix: "ahmed")
    
    var url: String = "https://developx.ir/license/api/"
    var appId: Int = 1 //Change this
    
    
    func loadCertificate() {
        let resourcePath = Bundle.main.path(forResource: "certificate", ofType: "p12")
        let p12Data = NSData(contentsOfFile: resourcePath!)!
        let key = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "myFuckingPassword100"]
        
        var items: CFArray?
        let securityError : OSStatus = SecPKCS12Import(p12Data, options, &items)
        
        let theArray: CFArray = items!
        if securityError == noErr && CFArrayGetCount(theArray) > 0 {
            let newArray = theArray as [AnyObject] as NSArray
            let dictionary = newArray.object(at: 0)
            
            let secIdentity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) as! SecIdentity //PrivateKey
            let secTrust = (dictionary as AnyObject).value(forKey: kSecImportItemTrust as String) as! SecTrust //PublicKey
            
            let securityError = SecIdentityCopyPrivateKey(secIdentity, &privateKeyRef)
            if securityError != noErr {
                privateKeyRef = nil
            }
            publicKeyRef = SecTrustCopyPublicKey(secTrust)
        }
    }
    func encrypt(rawData: Data) -> Data {
        loadCertificate()
        let plainBuffer = [UInt8](rawData)
        var cipherBufferSize : Int = Int(SecKeyGetBlockSize(publicKeyRef!))
        var cipherBuffer = [UInt8](repeating:0, count:Int(cipherBufferSize))
        let status = SecKeyEncrypt(publicKeyRef!, SecPadding.PKCS1, plainBuffer, plainBuffer.count, &cipherBuffer, &cipherBufferSize)
        if (status != errSecSuccess) {
            print("Failed Encryption")
        }
        return NSData(bytes: cipherBuffer, length: cipherBuffer.count) as Data
    }
    func decrypt(encryptedData: Data) -> Data {
        loadCertificate()
        var plaintextBufferSize = Int(SecKeyGetBlockSize(privateKeyRef!))
        var plaintextBuffer = [UInt8](repeating:0, count:Int(plaintextBufferSize))
        let status = SecKeyDecrypt(privateKeyRef!, SecPadding.PKCS1, [UInt8](encryptedData), plaintextBufferSize, &plaintextBuffer, &plaintextBufferSize)
        if (status != errSecSuccess) {
            print("Failed Decrypt")
        }
        return Data(bytes: plaintextBuffer, count: plaintextBufferSize)
    }
    
    
    func alertView(alertText: String) {
        DispatchQueue.main.async {
            let screenSize = UIScreen.main.bounds
            let alertView = UIView(frame: CGRect(x: 0, y: -100, width: screenSize.width, height: 100))
            alertView.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
            
            let label = UILabel(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: 44))
            label.text = alertText
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont(name: "IRANSansMobile-Medium", size: 17)
            label.adjustsFontSizeToFitWidth = true
            alertView.addSubview(label)
            
            UIView.animate(withDuration: 0.2) {
                var frame: CGRect = alertView.frame
                frame.origin.y = 0
                alertView.frame = frame
                UIApplication.shared.windows.first!.addSubview(alertView)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.2, animations: {
                    var frame: CGRect = alertView.frame
                    frame.origin.y = -100
                    alertView.frame = frame
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alertView.removeFromSuperview()
                }
            }
        }
    }
    func CheckMail(email: String) -> Bool {
        if (email.range(of: ".") != nil) && (email.range(of: "@") != nil) {
            return true
        } else {
            return false
        }
    }
    
    // Logout
    func logOut() {
        let email: String? = keychain.get("myEmail")
        
        let params = ["e" : email!, "aId" : appId] as [String : Any]
        
        fetchData(url: url+"logout.php", params: params, loader: true) { (json) in
            if json["status"] as! Int == 200 {
                self.keychain.delete("active")
                self.keychain.delete("myEmail")
                self.keychain.delete("myToken")
                
                // License Page
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "license")
                var topController = UIApplication.shared.keyWindow?.rootViewController
                while ((topController?.presentedViewController) != nil) {
                    topController = topController?.presentedViewController
                }
                topController?.present(vc, animated: true, completion: nil)
                
            } else {
                self.alertView(alertText: json["error"] as! String)
            }
        }
    }
    
    // GetMail
    func getMail() -> String {
        let email: String? = keychain.get("myEmail")
        return email!
    }
    
    // Buy
    func payLicense(e: String, c: String) {
        if CheckMail(email: e) {
            let deviceId: String? = keychain.get("deviceId")
            let params = ["e" : e,
                          "c" : c,
                          "o" : deviceId!,
                          "aId" : appId] as [String : Any]
            
            fetchData(url: url+"buy.php", params: params, loader: true) { (json) in
                if json["status"] as! Int == 200 {
                    self.openSafari(payURL: json["payUrl"] as! String)
                } else {
                    self.alertView(alertText: json["error"] as! String)
                }
            }
        } else {
            alertView(alertText: "ایمیل را صحیح وارد کنید.")
        }
    }
    func registerlcns(e: String) {
        if CheckMail(email: e) {
            let deviceId: String? = keychain.get("deviceId")
//            let params = ["email" : e,
//                          "appid" : appId] as [String : Any]
            
            let parameters: Parameters = ["email": e, "appid": appId]
            
            Alamofire.request("https://zendebebin.ir/api/AdminApp/register.php", method: .get, parameters: parameters).responseJSON { response in
                
                if (response.result.isSuccess){
                    if let result = response.result.value as? [[String: Any]] {
                        print(response)
                        for array in result {
                            let message: String = array["message"] as! String

                            if message == "ایمیل در دیتابیس موجود است!"{
                                self.alertView(alertText: "این ایمیل قبلا ثبت شده است!")

                            }
                            else if message == "OK" {
                                self.alertView(alertText: "ثبت نام موفق آمیز بود هم اکنون می توانید وارد شوید!")
                            }
                            //                        self.getamount = pamount
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                    //                            self.tableview.cr.endHeaderRefresh()

                                    
                                }, completion: nil)
                            }
                            
                            URLCache.shared.removeAllCachedResponses()
                            URLCache.shared.diskCapacity = 0
                            URLCache.shared.memoryCapacity = 0
                            
                        }
                        
                    }
                }
                else if (response.result.isFailure) {
                    //                self.hud.textLabel.text = "عدم ارتباط با اینترنت!"
                    print("error")
                    
                    
                }
                
            }
        }
         else {
            alertView(alertText: "ایمیل را صحیح وارد کنید.")
        }
    }
    func openSafari(payURL: String) {
        DispatchQueue.main.async {
            UIApplication.shared.openURL(URL(string: payURL)!)
        }
    }
    
    // Reactive
    func reactiveLicense(e: String) {
        if CheckMail(email: e) {
            
            let deviceId: String? = keychain.get("deviceId")
            
            let params = ["e" : e,
                          "dId" : deviceId!,
                          "aId" : appId] as [String : Any]
            
            
            fetchData(url: url+"reactive.php", params: params, loader: true) { (json) in
                if json["status"] as! Int == 200 {
                    
                    self.keychain.set(true, forKey: "active")
                    self.keychain.set(json["email"] as! String, forKey: "myEmail")
                    self.keychain.set(json["token"] as! String, forKey: "myToken")
                    
                    // Main Page
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mpg")
                    var topController = UIApplication.shared.keyWindow?.rootViewController
                    while ((topController?.presentedViewController) != nil) {
                        topController = topController?.presentedViewController
                    }
                    topController?.present(vc, animated: true, completion: nil)
                    
                } else {
                    self.alertView(alertText: json["error"] as! String)
                }
            }
        } else {
            alertView(alertText: "ایمیل را صحیح وارد کنید.")
        }
    }
    
    // Redeem
    func redeemLicense(e: String, c: String) {
        if CheckMail(email: e) {
            
            let deviceId: String? = keychain.get("deviceId")
            
            let params = ["e" : e,
                          "c" : c,
                          "aId" : appId,
                          "dId" : deviceId!] as [String : Any]
            
            fetchData(url: url+"redeem.php", params: params, loader: true) { (json) in
                if json["status"] as! Int == 200 {
                    self.keychain.set(true, forKey: "active")
                    self.keychain.set(json["email"] as! String, forKey: "myEmail")
                    self.keychain.set(json["token"] as! String, forKey: "myToken")
                    
                    // Main Page
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mpg")
                    var topController = UIApplication.shared.windows.first!.rootViewController
                    while ((topController?.presentedViewController) != nil) {
                        topController = topController?.presentedViewController
                    }

                    topController?.modalPresentationStyle = .overCurrentContext
                    topController?.present(vc, animated: true, completion: nil)
                    
                } else {
                    self.alertView(alertText: json["error"] as! String)
                }
            }
            
            
        } else {
            alertView(alertText: "ایمیل را صحیح وارد کنید.")
        }
    }
    
    
    var container = UIView()
    var indicatorView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showWaiting() {
        let screenSize = UIScreen.main.bounds
        DispatchQueue.main.async {
            MKProgress.config.hudType = .radial
            MKProgress.config.circleBorderColor = .black
            MKProgress.show()
//            self.container.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
//            self.container.backgroundColor = UIColor(white: 0, alpha: 0.0)
//
//            self.indicatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//            self.indicatorView.center = self.container.center
//            self.indicatorView.backgroundColor = UIColor(white: 0, alpha: 0.0)
//            self.indicatorView.clipsToBounds = true
//            self.indicatorView.layer.cornerRadius = 10
//
//
//            let indicatorViewSize = self.indicatorView.frame.size
//            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//            self.activityIndicator.style = .whiteLarge
//            self.activityIndicator.center = CGPoint(x: indicatorViewSize.width/2, y: indicatorViewSize.height/2)
//
//            self.indicatorView.addSubview(self.activityIndicator)
//            self.container.addSubview(self.indicatorView)
//            self.activityIndicator.startAnimating()
//
//            UIView.animate(withDuration: 0.2) {
//                self.container.backgroundColor = UIColor(white: 0, alpha: 0.3)
//                self.indicatorView.backgroundColor = UIColor(white: 0, alpha: 0.7)
//                UIApplication.shared.keyWindow?.addSubview(self.container)
//            }
        }
    }
    func hideWaiting() {
        DispatchQueue.main.async {

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                MKProgress.hide()
                
            }
        }
    }
    
    typealias CompletionHandler = (_ json: [String : Any]) -> Void
    func fetchData(url: String, params: [String : Any], loader: Bool, completionHandler: @escaping CompletionHandler) {
        if loader {
            showWaiting()
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let urlRequest = NSURL(string: url)!
            let request = NSMutableURLRequest(url: urlRequest as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = encrypt(rawData: data)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    if loader {
                        self.hideWaiting()
                    }
                    if error?.localizedDescription == "The Internet connection appears to be offline." {
                        AMLicense().alertView(alertText: "لطفا به اینترنت متصل شوید")
                    } else {
                        AMLicense().alertView(alertText: error!.localizedDescription)
                    }
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: self.decrypt(encryptedData: data!), options: .mutableContainers) as? NSDictionary
                    DispatchQueue.main.async {
                        if loader {
                            self.hideWaiting()
                        }
                        completionHandler(json as! [String : Any])
                    }
                } catch {
                    if loader {
                        self.hideWaiting()
                    }
                    AMLicense().alertView(alertText: "دوباره تلاش کنید")
                }
            }
            task.resume()
            
        } catch {
            if loader {
                self.hideWaiting()
            }
            AMLicense().alertView(alertText: "دوباره تلاش کنید")
        }
    }
    
}
