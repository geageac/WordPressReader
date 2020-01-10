//
//  UITableView.swift
//  Wordpress Reader
//
//  Created by Tezz on 1/8/20.
//  Copyright © 2020 Leo Natan. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func addBlur() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        self.backgroundView = blurView
    }
}
