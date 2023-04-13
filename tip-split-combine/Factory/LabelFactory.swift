//
//  LabelFactory.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 02.04.2023..
//

import UIKit

struct LabelFactory {
    
    static func build(text: String?, font: UIFont, backgroundColor: UIColor = .clear, textColor: UIColor = ThemeColor.text, textAligment: NSTextAlignment = .center) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = textAligment
        
        return label
    }
}
