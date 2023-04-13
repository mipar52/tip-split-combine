//
//  ThemeFont.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit

struct ThemeFont {
    static func regular(ofSite size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(ofSite size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size) ?? .systemFont(ofSize: size)
    }

    static func semibold(ofSite size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: size) ?? .systemFont(ofSize: size)
    }
}
