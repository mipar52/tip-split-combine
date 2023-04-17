//
//  CalcScreen.swift
//  tip-split-combineUITests
//
//  Created by Milan Parađina on 17.04.2023..
//

import XCTest

//MARK: https://www.hackingwithswift.com/articles/148/xcode-ui-testing-cheat-sheet -> Cheat sheet
class CalcScreen {
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
//    Logo view
    var logoView: XCUIElement {
        app.otherElements[ScreenIdentifier.LogoView.logoView.rawValue]
    }
//    Result view
    var amountPerPersonValueLabel: XCUIElement {
        return app.staticTexts[ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue]
    }
    
    var totalBillValueLabel: XCUIElement {
        return app.staticTexts[ScreenIdentifier.ResultView.totalBillValueLabel.rawValue]
    }
    
    var totalTipPersonValueLabel: XCUIElement {
        return app.staticTexts[ScreenIdentifier.ResultView.totalTipValueLabel.rawValue]
    }
    
//    Bill input view
    var billInputViewTextField: XCUIElement {
        return app.textFields[ScreenIdentifier.BillInputView.textField.rawValue]
    }
    
//    Tip input view
    var tenPercentTipButton: XCUIElement {
        return app.buttons[ScreenIdentifier.TipInputView.tenPercentButton.rawValue]
    }
    var fifteenPercentTipButton: XCUIElement {
        return app.buttons[ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue]
    }
    var twentyPercentTipButton: XCUIElement {
        return app.buttons[ScreenIdentifier.TipInputView.twentyPercentButton.rawValue]
    }
    var customPercentTipButton: XCUIElement {
        return app.buttons[ScreenIdentifier.TipInputView.customTipButton.rawValue]
    }
    var customTipAlertTextField: XCUIElement {
        app.textFields[ScreenIdentifier.TipInputView.tipTextField.rawValue]
    }
    
//    Split input view
    var incrementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.incrementButton.rawValue]
    }
    var decementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.decrementButton.rawValue]
    }
    var quantityLabel: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue]
    }
    
//    Actions
    func enterBill(amount: Double) {
        billInputViewTextField.tap()
        billInputViewTextField.typeText("\(amount)\n")
    }
    
    func selectTip(tip: Tip) {
        switch tip {
            
        case .tenPercent:
            tenPercentTipButton.tap()
        case .fifteenPercent:
            fifteenPercentTipButton.tap()
        case .twentyPercent:
            twentyPercentTipButton.tap()
        case .custom(value: let value):
            customPercentTipButton.tap()
            XCTAssertTrue(customTipAlertTextField.waitForExistence(timeout: 1.0))
            customTipAlertTextField.typeText("\(value)\n")
        }
    }
    
    func selectIncrementButton(numberOfTaps: Int) {
        incrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func selectDecrementButton(numberOfTaps: Int) {
        decementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func doubleTapLogoView() {
        logoView.tap(withNumberOfTaps: 2, numberOfTouches: 1)
    }
}

enum Tip {
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case custom (value: Int)
}
