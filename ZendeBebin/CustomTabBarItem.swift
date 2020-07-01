//
//  CustomTabBarItem.swift
//  iDM
//
//  Created by Sina Rabiei on 11/7/17.
//  Copyright © 2017 XDevelopers.ir. All rights reserved.
//

import UIKit

class CustomTabBarItem: UITabBarItem {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
    }

}
