//
//  UIView+Extension.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 02.04.2023..
//

import UIKit

extension UIView {
    func addShadow(off:CGSize, color: UIColor, radius: CGFloat, opacity:Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.shadowOffset = off
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRoundedCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
    
}
