//
//  tip_split_combineUITests.swift
//  tip-split-combineUITests
//
//  Created by Milan Parađina on 01.04.2023..
//

import XCTest

final class tip_split_combineUITests: XCTestCase {

    private var app: XCUIApplication!
    private var screen: CalcScreen {
        CalcScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "0€")
        XCTAssertEqual(screen.totalBillValueLabel.label, "0€")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "0€")
    }
    
    func testRegularTest() {
        //100 euro bill test
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "100 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "100 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "0 €")
    
        //10% tip
        screen.selectTip(tip: .tenPercent)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "110 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "110 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "10 €")

        //15% tip
        screen.selectTip(tip: .fifteenPercent)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "115 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "115 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "15 €")

        //20% tip
        screen.selectTip(tip: .twentyPercent)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "120 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "120 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "20 €")

        //Split bill by 4
        screen.selectIncrementButton(numberOfTaps: 3)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "30 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "120 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "20 €")

        //Split bill by 2
        screen.selectDecrementButton(numberOfTaps: 2)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "60 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "120 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "20 €")
    }
    
    func testCustomTipAndSplitByTwo() {
        screen.enterBill(amount: 300)
        
        screen.selectTip(tip: .custom(value: 200))
        screen.selectIncrementButton(numberOfTaps: 1)
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "250 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "500 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "200 €")
    }
    
    func testResetButton() {
        screen.enterBill(amount: 300)
        screen.selectTip(tip: .custom(value: 200))
        screen.selectIncrementButton(numberOfTaps: 1)
        screen.doubleTapLogoView()
        
        XCTAssertEqual(screen.amountPerPersonValueLabel.label, "0 €")
        XCTAssertEqual(screen.totalBillValueLabel.label, "0 €")
        XCTAssertEqual(screen.totalTipPersonValueLabel.label, "0 €")
        XCTAssertEqual(screen.billInputViewTextField.label, "")
        XCTAssertEqual(screen.quantityLabel.label, "1")
        XCTAssertEqual(screen.customTipAlertTextField.label, "Custom tip")
    }
}
