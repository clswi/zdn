//
//  MainVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/16/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TapticEngine
import MKProgress
import AVKit
import AVFoundation
class MainVC: UITableViewController {

    var UID: [String] = []
    var cover: [String] = []
    
    var link: [String] = []
    var coverx: [String] = []
    var name: [String] = []
    var getuidx: String?
    
    var getnamex: String?
    var getlinkx: String?

    @IBOutlet weak var imgconf: UIImageView!
    @IBOutlet weak var imgcover: UIImageView!
    
    @IBOutlet weak var namex: UILabel!
    @IBOutlet var tableview: UITableView!
    let vxsg = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableview.reloadData()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lalezar-Regular", size: 16)!], for: UIControl.State())
        navigationItem.backBarButtonItem = backButton
        
        if #available(iOS 13.0, *) {
            vxsg.backgroundColor = UIColor.systemBackground
        } else {
            vxsg.backgroundColor = UIColor.white
            // Fallback on earlier versions
        }
        vxsg.frame = view.bounds
        vxsg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vxsg)
        fetchsc()
        fetchconf()

    }
    
    func fetchsc() {
        MKProgress.show()

        Alamofire.request("https://zendebebin.ir/api/v2/main/sc.php").responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [[String: Any]] {

                    var cover: [String] = []
                    var UID: [String] = []
                    
                    for array in result {
                        let puid: String = array["uid"] as! String
                        let pcover: String = array["cover"] as! String
                        
                        cover.append(pcover)
                        UID.append(puid)
                        let url = URL(string: "\(pcover)")
                        self.imgcover.kf.setImage(with: url)
                        self.getuidx = puid
                        self.UID = UID
                        self.cover = cover
                    }
                    

                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                //                            self.tableview.cr.endHeaderRefresh()
                                TapticEngine.impact.feedback(.medium)
                                self.vxsg.alpha = 0
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
    
    func fetchconf() {

        Alamofire.request("https://zendebebin.ir/api/v2/main/apple.php").responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [[String: Any]] {

                    var link: [String] = []
                    var coverx: [String] = []
                    var name: [String] = []
                    for array in result {
                        let plink: String = array["link"] as! String
                        let pcover: String = array["cover"] as! String
                        let pname: String = array["name"] as! String

                        link.append(plink)
                        coverx.append(pcover)
                        name.append(pname)

                        let url = URL(string: "\(pcover)")
                        self.imgconf.kf.setImage(with: url)

                        self.namex.text = pname
                        self.getlinkx = plink
                        self.link = link
                        self.coverx = coverx
                        self.name = name
                    }
                    

                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                //                            self.tableview.cr.endHeaderRefresh()
                                TapticEngine.impact.feedback(.medium)
                                
                                
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let modal = storyBoard.instantiateViewController(withIdentifier: "dxmoviex") as! DMovieVC
                        modal.getuid = self.getuidx
                        self.present(modal, animated: true)
            
            }
        if indexPath.row == 5 {

            let videoURL = NSURL(string: "\(self.getlinkx!)")
            let player = AVPlayer(url: videoURL! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
                let _ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                let _ = try? AVAudioSession.sharedInstance().setActive(true)
            }
        
        }
        }
}
