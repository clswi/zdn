//
//  licenseVC.swift
//  ZendeBebin
//
//  Created by Ahmadreza Rahimi on 2/28/20.
//  Copyright © 2020 DevelopX. All rights reserved.
//

import UIKit

class licenseVC: UIViewController {

    @IBAction func reactive(_ sender: Any) {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let name = alert.textFields?.first?.text {
                AMLicense().reactiveLicense(e: name)
            }
        }))

        self.present(alert, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setTitlet(font: UIFont?, color: UIColor?) {
    guard let title = self.title else { return }
    let attributeString = NSMutableAttributedString(string: title)//1
    if let titleFont = font {
        attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                      range: NSMakeRange(0, title.utf8.count))
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
