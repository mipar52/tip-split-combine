//
//  Double+extension.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 05.04.2023..
//

import Foundation

extension Double {
    var currencyFormatted: String {
        var isWholeNumber: Bool {
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        //formatter.locale = Locale(identifier: "en_US")
        formatter.locale = Locale(identifier: "hr_HR")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        //formatter.currencySymbol = "$"
        formatter.currencyCode = "EUR"
        return formatter.string(for: self) ?? ""
    }
    
    func formatAsCurrency(currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits = floor(self) == self ? 0 : 2
        return currencyFormatter.string(from: self as NSNumber)
    }
}
