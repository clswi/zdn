//
//  dradioVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 2/17/20.
//  Copyright © 2020 DevelopX. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import AVKit
import AVFoundation
import MediaPlayer
import TapticEngine

class dradioVC: UIViewController {

    var getimg: String?

//    @IBAction func close(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//        player.pause()
//    }
    @IBOutlet weak var namex: UILabel!
    @IBOutlet weak var vooolx: UISlider!
    @IBAction func volaction(_ sender: Any) {
        
        //        vooolx.value = AVAudioSession.sharedInstance().outputVolume
        
        MPVolumeView.setVolume(vooolx.value)
    }
    @IBOutlet weak var PlayO: UIButton!
    @IBAction func PlayA(_ sender: Any) {
        playMusic = !playMusic
    }
    
    @IBOutlet weak var radioimage: UIImageView!
    
    
    var player : AVPlayer!
    var audioPlayer : AVAudioPlayer!
    
    var playMusic: Bool = false {
        didSet {
            if playMusic == true {
                PlayO.setImage(UIImage(named: "play"), for: .normal)
                player.pause()
                
            } else {
                PlayO.setImage(UIImage(named: "pause"), for: .normal)
                player.play()
                
            }
        }
    }
    
    var getname: String?
    var getlink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lalezar-Regular", size: 16)!], for: UIControl.State())
        navigationItem.backBarButtonItem = backButton
        
        self.namex.text = "\(getname!)"
        TapticEngine.impact.feedback(.medium)
        

        
        
        
        
        modalPresentationCapturesStatusBarAppearance = true
        
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        
        let urlx = URL(string: "\(getimg!)")
        radioimage.kf.setImage(with: urlx)
        
        
        let url = "\(getlink!)"
        player = AVPlayer(url: URL(string: url)!)
        let volumex = AVAudioSession.sharedInstance().outputVolume
        player.volume = volumex
        player.volume = 0.5
        player.rate = 0.5
        player.play()
        
        
        
        let _ = try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        let _ = try? AVAudioSession.sharedInstance().setActive(true)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func viewWasTapped() {
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume;
            
        }
    }
}
