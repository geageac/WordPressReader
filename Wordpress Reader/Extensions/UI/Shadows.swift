//
//  Shadows.swift
//  LNPopupControllerExample
//
//  Created by Tezz on 12/19/19.
//  Copyright © 2019 Leo Natan. All rights reserved.
//

import Foundation
import SwiftyShadow

extension UIView {
    func addOuterShadow() {
        if traitCollection.userInterfaceStyle == .light {
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.5
            self.layer.shadowColor = getSecondaryColor().cgColor
            self.layer.shadowOffset = CGSize.zero
            self.generateOuterShadow()
        }
    }
    
    func removeShadows() {
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize.zero
    }
    
    func addInnerShadow() {
        self.layer.shadowRadius = self.layer.cornerRadius
        self.layer.shadowOpacity = 0.25
        self.layer.shadowColor = getSecondaryColor().cgColor
        self.layer.shadowOffset = CGSize.zero
        self.generateInnerShadow()
    }
    
    func addImage(url: URL?) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.sd_setImage(with: url, completed: nil)//.image = UIImage(named: "RubberMat")
        backgroundImage.contentMode =  .scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
    }
    
    func addImage(image: UIImage?) {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode =  .scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
    }
}

extension UITableView {
    func addBackgroundImage(url: URL) {
        let backgroundImage = UIImageView()
        backgroundImage.sd_setImage(with: url, completed: nil)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = false
        self.backgroundView = backgroundImage
    }
}
