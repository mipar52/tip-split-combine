//
//  tip_split_combineTests.swift
//  tip-split-combineTests
//
//  Created by Milan Parađina on 01.04.2023..
//

import XCTest
import Combine

@testable import tip_split_combine

final class tip_split_combineTests: XCTestCase {
    
    //SUT -> System under test
    private var sut: CalculatorVM!
    private var cancellables: Set<AnyCancellable>!
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()
    private var audioPlayerService: MockAudioPlayerService!
    
    override func setUp() { // -> creates an instance of the SUT
        sut = .init(audioPlayerService: audioPlayerService)
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() { // -> when the test ends, resets the SUT
        sut = nil
        cancellables = nil
        audioPlayerService = nil
        super.tearDown()
    
    }
    
    func testResultWithoutTipForOnePerson() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.tranform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.tranform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }

    func testResultWith10PercentTipFor2Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.tranform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4Person() {
        //given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 25)
        let split: Int = 4
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.tranform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 31.25)
            XCTAssertEqual(result.totalBill, 125)
            XCTAssertEqual(result.totalTip, 25)
        }.store(in: &cancellables)
    }
    
    func testDoubleTapLogoViewAndPlaySound() {
            //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.tranform(input: input)
        let expectation = XCTestExpectation(description: "Reset calc called")
        let expecataiontTow = audioPlayerService.expectation
        //then
        output.resetCalculatorPublisher.sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        //when
        
        logoViewTapSubject.send()
        wait(for: [expectation, expecataiontTow], timeout: 1.0)
    }


    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPublisher: Just(split).eraseToAnyPublisher(),
                     logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher(),
                     viewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "play sound is called")
    func playSound() {
        expectation.fulfill()
    }
}
