//
//  CalculatorVM.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 03.04.2023..
//

import Foundation
import Combine

class CalculatorVM {
    
    struct Input {
        //input from views -> user intercations
        let billPublisher: AnyPublisher<Double, Never> //never returnes failure
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
        let viewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        //view update
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
        let viewTapPublisher: AnyPublisher<Void, Never>
    }
    
    private let audioPlayerService: AudioPlayerService
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    func tranform(input: Input) -> Output {
        let updateViewPublishers = Publishers.CombineLatest3(input.billPublisher, input.tipPublisher, input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
            let totalTip = getTipAmount(bill: bill, tip: tip)
            let totalBill = bill + totalTip
            let amountPerPerson = totalBill / Double(split)
            
            let result = Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)
            
            return Just(result)
        }.eraseToAnyPublisher()
        
        let resetCalculatorPublisher = input.logoViewTapPublisher.handleEvents(receiveOutput:  { [unowned self] _ in
            audioPlayerService.playSound()
        }).flatMap { _ in
            return Just(())
        }.eraseToAnyPublisher()
        
        let viewTap = input.viewTapPublisher
    
        return Output(updateViewPublisher: updateViewPublishers, resetCalculatorPublisher: resetCalculatorPublisher, viewTapPublisher: viewTap)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(value: let value):
            return Double(value)
        }
    }
}
