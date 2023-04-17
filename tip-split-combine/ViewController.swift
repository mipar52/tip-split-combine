//
//  CalculatorViewController.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorViewController: UIViewController {

    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        logoView,
        resultView,
        billInputView,
        tipInputView,
        splitInputView,
        UIView()
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
        }()
    
    private let calculatorVM = CalculatorVM()
    private var cancelable = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bind()
    }
    
    private func bind() {
        
        let input = CalculatorVM.Input(billPublisher: billInputView.billPublisher,
                                       tipPublisher: tipInputView.tipPublisher,
                                       splitPublisher: splitInputView.splitPublisher,
                                       logoViewTapPublisher: logoViewTapPublisher,
                                       viewTapPublisher: viewTapPublisher)
        
        let output = calculatorVM.tranform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configureResult(result: result)
        }.store(in: &cancelable)
        
        output.resetCalculatorPublisher.sink { [unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()

            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 5.0,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.logoView.transform = .identity
                }
            }
        }.store(in: &cancelable)
        
        output.viewTapPublisher.sink { [unowned self] _ in
            print("dissmiss view")
            view.endEditing(true)
        }.store(in: &cancelable)
    }
    
    private func setupLayout() {
        view.backgroundColor = ThemeColor.background
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

