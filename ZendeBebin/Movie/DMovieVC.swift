//
//  DMovieVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/24/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TapticEngine
import AVKit
import AVFoundation
import MKProgress
import AVPlayerViewControllerSubtitles

class DMovieVC: UITableViewController {

    var getuid: String?
    var getname: String?
    var getimg: String?
    var psLink: String?
    var npsLink: String?
    var plinko: String?
    
    @IBOutlet weak var playo: UIButton!
    @IBAction func playX(_ sender: Any) {
        
            TapticEngine.selection.feedback()
            

                if (plinko?.isEmpty)!{
                    playo.alpha = 0
                }
                else if plinko == "nointer"{
                    playo.alpha = 0
                }
                else if self.npsLink == "" {
                    
                    let videoURLx = Foundation.URL(string: ("\(plinko!)"))
                    let playerx = AVPlayer(url: videoURLx!)
                    let playerViewControllerx = AVPlayerViewController()
                    playerViewControllerx.player = playerx
                    self.present(playerViewControllerx, animated: true) {
                        let valuex =  UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(valuex, forKey: "orientation")
                        UIViewController.attemptRotationToDeviceOrientation()
                        playerViewControllerx.player!.play()
                        
                        let _ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        let _ = try? AVAudioSession.sharedInstance().setActive(true)
                    }
                }
                else if self.psLink == ""{
                    
                }
                else {
                    print("true")
                    
                    let videoURLxs = Foundation.URL(string: ("\(plinko!)"))
                    let playerxs = AVPlayer(url: videoURLxs!)
                    let playerViewControllerxs = AVPlayerViewController()
                    playerViewControllerxs.player = playerxs
                    self.present(playerViewControllerxs, animated: true) {
                        let valuexs =  UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(valuexs, forKey: "orientation")
                        UIViewController.attemptRotationToDeviceOrientation()
                        playerViewControllerxs.player!.play()
                        
                        
                        let subtitleURL = Foundation.URL(string: ("\(self.psLink!)"))
                        playerViewControllerxs.addSubtitles().open(file: subtitleURL!, encoding: String.Encoding.utf8)
                        
                        // Change text properties
                        playerViewControllerxs.subtitleLabel?.textColor = UIColor.yellow
                        
                        playerViewControllerxs.subtitleLabel?.font = UIFont(name: "IRANSansMobile-Medium", size: 20)
                        let _ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        let _ = try? AVAudioSession.sharedInstance().setActive(true)
                    }
            }
                
                
            }

        
        

    @IBOutlet weak var Ddesc: UILabel!
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var yearcontry: UILabel!
    @IBOutlet weak var timex: UILabel!
    @IBOutlet weak var imgp: UIImageView!
    @IBOutlet weak var cover: UIImageView!
    
    let vxsg = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lalezar-Regular", size: 16)!], for: UIControl.State())
        navigationItem.backBarButtonItem = backButton
        name.adjustsFontSizeToFitWidth = true
        

        
        fetchData()
    }
    func fetchData() {
        if #available(iOS 13.0, *) {
            vxsg.backgroundColor = UIColor.systemBackground
        } else {
            vxsg.backgroundColor = UIColor.white
            // Fallback on earlier versions
        }
        vxsg.frame = self.view.bounds
        vxsg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(vxsg)
        
            MKProgress.show()

        Alamofire.request("https://www.filimo.com/etc/api/movie/uid/\(getuid!)/luser/u_4386900/ltoken/60b6aa6419abecb4c5f7bddab24f137e/devicetype/ios").responseJSON { response in
                
                if (response.result.isSuccess){
                    if let result = response.result.value as? [String : Any] {
                        
                        
                        let pmovie: Dictionary = result["movie"] as! Dictionary <String, Any>
                        
                        let ptypex: Bool = pmovie["is_serial"] as! Bool
                        let price: String = pmovie["price_txt"] as! String
                        let pimdb: String = pmovie["imdb_rate"] as! String
                        let pimgx: String = pmovie["movie_img_b"] as! String
                        let pnamex: String = pmovie["movie_title"] as! String
    //                    self.name.text = "\(pnamex)"
                        if pimdb == "0.00"{
//                            self.imdbx.text = ""
//                            self.imdbimgx.alpha = 0
                        }
                        else{
//                            self.imdbx.text = "\(pimdb)"
//                            self.imdbimgx.alpha = 1

                        }
                        if price == "به زودی" {
                            self.playo.alpha = 0
                            let status: String = pmovie["movie_status_txt"] as! String
                            print("\(status)")
                            self.Ddesc.text = "\(status.withoutHtmlx)"
                            self.plinko = ""
//                            self.imdbimgx.alpha = 0
//                            self.imdbx.text = ""
//                            self.timeimg.alpha = 0
//
//                            self.namefilm.text = "\(pnamex)"
                            let urlcx = URL(string: "\(pimgx)")
                            self.cover.kf.setImage(with: urlcx)

                        }
                        else{
                            self.playo.alpha = 1
                            let ptime: Float = pmovie["duration"] as! Float
                            let plink: String = pmovie["movie_src"] as! String
                            let pcover: String = pmovie["cover_adr"] as! String
                            
                            let pcountry: String = pmovie["country_1"] as! String
                            let pcat: String = pmovie["category_1"] as! String
                            let pyear: String = pmovie["produced_year"] as! String
                            let pdesc: String = pmovie["description"] as! String
                        
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                    
                                    
                                    self.plinko = plink
//                                    self.creator.text = "\(pcountry)"
                                    self.yearcontry.text = "\(pyear) - \(pcountry)"
//                                    self.genre.text = "\(pcat)"
                                    self.timex.text = "\(ptime.clean) دقیقه"
                                    
                                    let urlc = URL(string: "\(pcover)")
                                    self.cover.kf.setImage(with: urlc)
                                    
                                    let urlp = URL(string: "\(pimgx)")
                                    self.imgp.kf.setImage(with: urlp)
                                    
                                    self.name.text = "\(pnamex)"
                                    self.Ddesc.text = "\(pdesc.withoutHtmlx)"
                                    
                                    self.vxsg.alpha = 0
                                    MKProgress.hide()

                                    
                                }, completion: nil)
                            }

                            
                            
                            let psubtitledata: Dictionary = (pmovie["subtitle_data"] as? Dictionary <String, Any>)!
                            let psubtitlear = psubtitledata["subtitle"] as? [[String: Any]]
                            
                            if (psubtitlear?.isEmpty)!{
                                print("This is Nil SubTitle!")
                                self.npsLink = ""
                            }
                            else{
                                let x:Dictionary = psubtitlear![0]
                                let psublink: String = x["src_vtt"] as! String
                                self.psLink = psublink
                                
                                
                            }
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            self.Ddesc.alpha = 1

                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                    //                            self.tableview.cr.endHeaderRefresh()
                                    self.tableview.reloadData()
                                    
                                    self.cover.alpha = 1
//                                    self.timeimg.alpha = 1
                                    self.timex.alpha = 1
                                    self.name.alpha = 1
                                    self.imgp.alpha = 1
//                                    self.genre.alpha = 1
//                                    self.creator.alpha = 1
//                                    self.year.alpha = 1
                                    

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
//                    self.plinko = "nointer"
                    
                }
                
            }
        }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        // return UITableViewAutomaticDimension for older than Swift 4.2
    }
}
extension String {
    public var withoutHtmlx: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
