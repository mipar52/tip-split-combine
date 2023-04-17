//
//  ScreenIdentifier.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 17.04.2023..
//

import Foundation

enum ScreenIdentifier {
    
    enum LogoView: String {
        case logoView
    }
    
    enum ResultView: String {
        case totalAmountPerPersonValueLabel
        case totalBillValueLabel
        case totalTipValueLabel
    }
    
    enum BillInputView: String {
        case textField
    }
    
    enum TipInputView: String {
        case tenPercentButton
        case twentyPercentButton
        case fifteenPercentButton
        case customTipButton
        case tipTextField
    }
    
    enum SplitInputView: String {
        case decrementButton
        case incrementButton
        case quantityValueLabel
    }
}
