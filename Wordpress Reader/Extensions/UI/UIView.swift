//
//  PanGestureExtension.swift
//  Spotify_App
//
//  Created by Anıl Akkaya on 12.10.2018.
//  Copyright © 2018 Anıl Akkaya. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setupHomeView(viewController: UIViewController?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let viewController = viewController {
            viewController.view.addSubview(self)
            leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        }
    }
}

public func delay(n: UInt32 = 2, completion: @escaping () -> Void = { }) {
    let qualityOfServiceClass = DispatchQoS.QoSClass.background
    let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
    backgroundQueue.async(execute: {
        sleep(n)
        DispatchQueue.main.async {
            completion()
        }
    })
}
