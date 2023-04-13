//
//  UIResponder+Extension.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 05.04.2023..
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
