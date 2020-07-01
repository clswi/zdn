//
//  EpisodesVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/26/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import TapticEngine
import MKProgress

class EpisodesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var name: [String] = []
    var img: [String] = []
    var link: [String] = []
    var typex: [String] = []
    var Episodex: [String] = []
    
    @IBOutlet weak var tableview: UITableView!
    
    var getname: String?
    var getlink: String?
    var getimg: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = getname
        fetchDatax()
        modalPresentationCapturesStatusBarAppearance = true
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lalezar-Regular", size: 16)!], for: UIControl.State())
        navigationItem.backBarButtonItem = backButton
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
                if let result = response.result.value as? [[String: Any]] {

                    for array in result {
                        
                        let pname: String = array["name"] as! String
                        let pimg: String = array["img"] as! String
                        let plink: String = array["link"] as! String
                        let ptype: String = array["type"] as! String
                        let pepisode: String = array["episode"] as! String
                        
                        self.name.append(pname)
                        self.img.append(pimg)
                        self.link.append(plink)
                        self.Episodex.append(pepisode)
                        self.typex.append(ptype)
                        
                    }

                    DispatchQueue.main.async {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                                //                            self.tableview.cr.endHeaderRefresh()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellxp", for: indexPath) as! tbcellx
        
        
        cell.name.text = self.name[indexPath.row]
        let url = URL(string: "\(self.img[indexPath.row])")
        cell.imgx.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TapticEngine.selection.feedback()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal = storyBoard.instantiateViewController(withIdentifier: "dparts") as! PartsVC
        modal.getname = "\(self.name[indexPath.row])"
        modal.gettype = self.typex[indexPath.row]
        modal.getlink = self.link[indexPath.row]
        modal.getEpisode = self.Episodex[indexPath.row]
        self.navigationController?.pushViewController(modal, animated: true)

    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("selected item at index")
        UIView.animate(withDuration: 0.15, animations: {
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        print("unselected item at index")
        UIView.animate(withDuration: 0.15, animations: {
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            cell?.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.name.count
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
