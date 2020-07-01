//
//  MovieVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 11/16/19.
//  Copyright © 2019 DevelopX. All rights reserved.
//

    import UIKit
    import Alamofire
    import Kingfisher
    import TapticEngine
    class MovieVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        

        
        @IBOutlet weak var collectionview: UICollectionView!
        var uidx: String?
        
        var name: [String] = []
        var img: [String] = []
        var Typee: [String] = []
        var UID: [String] = []
        var link: [String] = []
        var psLink: String?
        var npsLink: String?
        
        
        var checkerload: String?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            fetchDatax()
            
        }
        
        
        func fetchDatax() {

            Alamofire.request("https://www.filimo.com/etc/api/list/listtype/tag/listid/thumbnailspecial/luser/u_4386900/ltoken/60b6aa6419abecb4c5f7bddab24f137e/devicetype/ios").responseJSON { response in
                
                if (response.result.isSuccess){
                    
                    if let result = response.result.value as? [String : Any] {
                        
                        
                        
                        var name: [String] = []
                        var img: [String] = []
                        var Typee: [String] = []
                        var UID: [String] = []
                        let Listd: Dictionary = result["list"] as! Dictionary <String, Any>
     
                        let Datalists = Listd["list_data"] as! NSArray
                        let dataar: Dictionary = Datalists[0] as! Dictionary <String, Any>
                        let dataX = dataar["data"] as! NSArray
                        
                        for array in dataX as! [Dictionary <String, Any>]{

                            let pname: String = array["movie_title"] as! String
                            let pimg: String = array["movie_img_b"] as! String
                            let puid: String = array["uid"] as! String
                            let ptype: String = "Filimo"

                            name.append(pname)
                            img.append(pimg)
                            Typee.append(ptype)
                            UID.append(puid)
                        }
                        
                        self.name = name
                        self.img = img
                        self.Typee = Typee
                        self.UID = UID
                        DispatchQueue.main.async {
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
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
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            self.collectionview.scrollToNearestVisibleCollectionViewCell()
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                self.collectionview.scrollToNearestVisibleCollectionViewCell()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! colCell
            cell.name.text = name[indexPath.row]
            cell.name.adjustsFontSizeToFitWidth = true
            
            let url = URL(string: "\(self.img[indexPath.row])")
            cell.imgx.kf.setImage(with: url)
            return cell
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            
            TapticEngine.selection.feedback()

            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let modal = storyBoard.instantiateViewController(withIdentifier: "dxmoviex") as! DMovieVC
//            modal.modalPresentationStyle = .custom
//            modal.getname = name[indexPath.row]
//            modal.getimg = img[indexPath.row]
            modal.getuid = UID[indexPath.row]
//            let keychain = KeychainSwift()
//            keychain.set("\(UID[indexPath.row])", forKey: "uidd")
            self.present(modal, animated: true)

            

            
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return name.count
            
        }

        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            print("selected item at index")
            UIView.animate(withDuration: 0.15, animations: {
                let cell = collectionView.cellForItem(at: indexPath as IndexPath)
                cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
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
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
