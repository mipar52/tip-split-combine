//
//  ButtonFactory.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 02.04.2023..
//

import UIKit

struct ButtonFactory {
    
    static func build(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(string: tip.stringValue, attributes: [.font: ThemeFont.bold(ofSite: 20),.foregroundColor: UIColor.white])
        
        text.addAttributes([.font:ThemeFont.semibold(ofSite: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
