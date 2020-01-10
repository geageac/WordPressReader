//
//  HTMLString.swift
//  GlidingCollectionDemo
//
//  Created by Tezz on 8/9/19.
//  Copyright © 2019 Ramotion Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toURL() -> URL {
        guard let url = URL(string: self) else { return URL(string: "")! }
        return url
    }
}

extension String {
    func toHTML() -> String {
        var finalString = ""
        for char in self {
            for scalar in String(char).unicodeScalars {
                finalString.append("&#\(scalar.value)")
            }
        }
        return finalString
    }
}

extension String {
    init(htmlEncodedString: String) {
        self.init()
        if let attributedString = htmlEncodedString.htmlToAttributedString() {
            self = attributedString.string
        }
        else {
            self = htmlEncodedString
        }
    }
    
    func htmlToAttributedString() -> NSAttributedString? {
        if let data = self.data(using:.utf8) {
            // pm171004 converted to Swift 4
            let options:[NSAttributedString.DocumentReadingOptionKey : Any] =
                [NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
                 NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue]
            if let attributedString = try? NSAttributedString(data:data, options:options, documentAttributes:nil) {
                return attributedString
            }
        }
        return nil
    }
    
}


