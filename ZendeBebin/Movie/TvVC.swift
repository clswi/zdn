//
//  TvVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/16/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TapticEngine
import AVKit
import AVFoundation

class TvVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    
    var name: [String] = []
    var img: [String] = []
    var link: [String] = []
    
    var getname: String?
    var getlink: String?
    var getimg: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchDatax()

        
    }
    
    func fetchDatax() {

        Alamofire.request("https://zendebebin.ir/api/TVCategory/sarasari.php").responseJSON { response in
            
            if (response.result.isSuccess){
                if let result = response.result.value as? [[String: Any]] {
                    
                    var name: [String] = []
                    var img: [String] = []
                    var link: [String] = []
                    
                    
                    for array in result {
                        
                        let pname: String = array["name"] as! String
                        let pimg: String = array["img"] as! String
                        let plink: String = array["link"] as! String
                        
                        name.append(pname)
                        img.append(pimg)
                        link.append(plink)
                        
                    }
                    
                    self.name = name
                    self.img = img
                    self.link = link
                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                //                            self.tableview.cr.endHeaderRefresh()
                                self.collectionview.alpha = 1
                                TapticEngine.impact.feedback(.medium)
                                self.collectionview.reloadData()

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
    
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! colCell
                //        cell.name.text = name[indexPath.row]
                cell.name.text = self.name[indexPath.row]
                let url = URL(string: "\(self.img[indexPath.row])")
                cell.imgx.kf.setImage(with: url)
                cell.name.adjustsFontSizeToFitWidth = true
                return cell
            }
            func numberOfSections(in collectionView: UICollectionView) -> Int {
                // #warning Incomplete implementation, return the number of sections
                return 1
            }
            
            
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
                
                TapticEngine.selection.feedback()

                    let videoURL = Foundation.URL(string: (self.link[indexPath.row]))
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        let value =  UIInterfaceOrientation.portrait.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                        UIViewController.attemptRotationToDeviceOrientation()
                        playerViewController.player!.play()
                        let _ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        let _ = try? AVAudioSession.sharedInstance().setActive(true)
                    }

                
            }
            
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return name.count
                
            }
            func delay(_ delay:Double, closure:@escaping ()->()) {
                DispatchQueue.main.asyncAfter(
                    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
            }
            func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
                print("selected item at index")
                UIView.animate(withDuration: 0.15, animations: {
                    let cell = collectionView.cellForItem(at: indexPath as IndexPath)
                    cell?.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                })
            }
            func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
                print("unselected item at index")
                UIView.animate(withDuration: 0.15, animations: {
                    let cell = collectionView.cellForItem(at: indexPath as IndexPath)
                    cell?.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
                })
            }
            override var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
        }
