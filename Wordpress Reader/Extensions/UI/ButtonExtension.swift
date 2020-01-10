//
//  ButtonExtension.swift
//  Spotify_App
//
//  Created by Anıl Akkaya on 14.10.2018.
//  Copyright © 2018 Anıl Akkaya. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(type: UIButton.ButtonType = .system, backgroundColor: UIColor?, image: UIImage?, imageTintColor: UIColor?) {
        self.init(type: type)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        setImage(image, for: .normal)
        imageView?.tintColor = imageTintColor
    }
}
