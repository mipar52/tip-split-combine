//
//  tip-split-combineSnapshotTests.swift
//  tip-split-combineTests
//
//  Created by Milan Parađina on 14.04.2023..
//

import XCTest
import SnapshotTesting
@testable import tip_split_combine


final class tip_split_combineSnapshotTests: XCTestCase {
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        //given
        let size = CGSize(width: screenWidth, height: 48)
        //when
        let view = LogoView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialResultView() {
        let size = CGSize(width: screenWidth, height: 224)
        //when
        let view = ResultView()
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }
    
    func testInitialResultViewWithValues() {
        let size = CGSize(width: screenWidth, height: 224)
        //when
        let result = Result(amountPerPerson: 100.0, totalBill: 45, totalTip: 60)
        let view = ResultView()
        view.configureResult(result: result)
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }
    
    func testInitialTipInputView() {
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = TipInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }
    
    func testInitialBillInputView() {
        let size = CGSize(width: screenWidth, height: 56+56+56)
        //when
        let view = BillInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }
    
    func testInitialBillInputViewWithValues() {
        let size = CGSize(width: screenWidth, height: 56+56+56)
        //when
        let view = BillInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }

    func testInitialSplitInputView() {
        let size = CGSize(width: screenWidth, height: 56)
        //when
        let view = SplitInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size), record: true)
    }
}
