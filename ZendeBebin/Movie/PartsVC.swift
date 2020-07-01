//
//  PartsVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/29/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TapticEngine
import AVKit
import AVFoundation
import MKProgress

class PartsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return self.name.count
    }
    
    
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var name: [String] = []
    var img: [String] = []
    var link: [String] = []
    var UID: [String] = []
    var Coverx: [String] = []
    var Typex: [String] = []
    var idSX: [String] = []
    var getname: String?
    var gettype: String?
    var getlink: String?
    var getEpisode: String?
    var getID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lalezar-Regular", size: 16)!], for: UIControl.State())
        navigationItem.backBarButtonItem = backButton
        self.title = "\(getname!)"
        self.tableview.alpha = 0
        self.tableview.reloadData()
        if gettype == "Filimo"{
            self.fetchDatax()
        }
        else if gettype == "Namava"{
            fetchNamava()
        }
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        modalPresentationCapturesStatusBarAppearance = true

    }
    
    func fetchtostream() {
        let parameters: Parameters = ["id": "\(getID!)"]
        Alamofire.request("https://shahbaghi.com/F/data/namavaa/stream.php", method: .post, parameters: parameters).responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [String: Any] {
                    
                    print(result)
                    
                    
                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                TapticEngine.impact.feedback(.medium)
                                // alert mikhad
                                                                            
                            }, completion: nil)
                        }
                        
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        
                    }
                    
                }
            }
            else if (response.result.isFailure) {
                print("error")
            }
            
        }
    }
    
    func fetchNamava() {
        let vxsg = UIView()
        if #available(iOS 13.0, *) {
            vxsg.backgroundColor = UIColor.systemBackground
        } else {
            vxsg.backgroundColor = UIColor.white
            // Fallback on earlier versions
        }
        vxsg.frame = view.bounds
        vxsg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vxsg)
        
            MKProgress.show()
        
        let parameters: Parameters = ["id": "\(getEpisode!)"]
        Alamofire.request("\(getlink!)", method: .post, parameters: parameters).responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [[String: Any]] {
                    
                    for array in result {
                        //
                        let pname: String = array["title"] as! String
                        let pimg: String = array["pict"] as! String
                        let pid: Int = array["id"] as! Int
                        let pidx: String = String(pid)

                        self.name.append(pname)
                        self.img.append(pimg)
                        self.Coverx.append("")
                        self.idSX.append(pidx)
                    }
                    
                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                self.tableview.alpha = 1
                                TapticEngine.impact.feedback(.medium)
                                self.tableview.reloadData()
                                vxsg.alpha = 0
                                MKProgress.hide()
                            }, completion: nil)
                        }
                        
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        
                    }
                    
                }
            }
            else if (response.result.isFailure) {
                print("error")
            }
            
        }
    }
    func fetchDatax() {

        let vxsg = UIView()
        if #available(iOS 13.0, *) {
            vxsg.backgroundColor = UIColor.systemBackground
        } else {
            vxsg.backgroundColor = UIColor.white
            // Fallback on earlier versions
        }
        vxsg.frame = view.bounds
        vxsg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vxsg)
        
            MKProgress.show()
        Alamofire.request("\(getlink!)").responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [String: Any] {
                    
                    let Listd = result["movieserialbyseason"] as! NSArray
                    let xsx = Int(self.getEpisode!)
                    let dataar: Dictionary = Listd[xsx!] as! Dictionary <String, Any>
                    
                    
                    let Datalists = dataar["season_data"] as! NSArray
                    
                    for array in Datalists as! [Dictionary <String, Any>]{
                        
                        let pname: String = array["movie_title"] as! String
                        let pimg: String = array["movie_img_b"] as! String
                        let puid: String = array["uid"] as! String
                        let pcover: String = array["movie_cover"] as! String
                        
                        self.name.append(pname)
                        self.img.append(pimg)
                        self.UID.append(puid)
                        self.Coverx.append(pcover)
                    }
                    
                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                self.tableview.alpha = 1
                                TapticEngine.impact.feedback(.medium)
                                self.tableview.reloadData()
                                vxsg.alpha = 0
                                MKProgress.hide()
                            }, completion: nil)
                        }
                        
                        
                        URLCache.shared.removeAllCachedResponses()
                        URLCache.shared.diskCapacity = 0
                        URLCache.shared.memoryCapacity = 0
                        
                    }
                    
                }
            }
            else if (response.result.isFailure) {
                print("error")
                
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbseris", for: indexPath) as! tbcellx
        
        
        cell.name.text = self.name.reversed()[indexPath.row]
        let url = URL(string: "\(self.img[indexPath.row])")
        cell.imgx.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TapticEngine.selection.feedback()
        
        if self.gettype == "Namava"{
            self.getID = idSX.reversed()[indexPath.row]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {

                    self.fetchtostream()
                }, completion: nil)
            }
 
        }
        else{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyBoard.instantiateViewController(withIdentifier: "dxmoviex") as! DMovieVC
        modal.getname = name.reversed()[indexPath.row]
        modal.getimg = img.reversed()[indexPath.row]
        modal.getuid = UID.reversed()[indexPath.row]
//        let keychain = KeychainSwift()
//        keychain.set("\(UID.reversed()[indexPath.row])", forKey: "uidd")
        self.present(modal, animated: true)

        }
        
    }
       override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected item at index")
        UIView.animate(withDuration: 0.15, animations: {
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        })
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        print("unselected item at index")
        UIView.animate(withDuration: 0.15, animations: {
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            cell?.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        })
    }
    

    
      
    
    }

