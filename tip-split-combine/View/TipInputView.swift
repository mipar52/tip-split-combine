//
//  TipInputView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.configure(topText: "Enter", bottomText: "your tip")
        
        return headerView
    }()
    
    private lazy var tenPerButton: UIButton = {
        let button = ButtonFactory.build(tip: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelables)
        return button
    }()
    
    private lazy var fifteenPerButton: UIButton = {
        let button = ButtonFactory.build(tip: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelables)
        return button
    }()
    
    private lazy var twentyPerButton: UIButton = {
        let button = ButtonFactory.build(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelables)
        return button
    }()
    
    private lazy var customPerButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSite: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancelables)
        
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let hStackView: UIStackView = UIStackView(arrangedSubviews: [
            tenPerButton,
            fifteenPerButton,
            twentyPerButton])
        hStackView.distribution = .fillEqually
        hStackView.spacing = 16
        hStackView.axis = .horizontal
        
        return hStackView
    }()
    
    private lazy var buttonVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            hStack,
            customPerButton])
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var tipPublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(headerView)
        addSubview(buttonVStack)
        
        buttonVStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStack.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(hStack.snp.centerY)
            //            make.centerY.equalTo(textFieldContinerView.snp.centerY)
            //            make.trailing.equalTo(textFieldContinerView.snp.leading).offset(-24)
        }
    }
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            
            switch tip {
                
            case .none:
                break
            case .tenPercent:
                tenPerButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPerButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPerButton.backgroundColor = ThemeColor.secondary
            case .custom(value: let value):
                customPerButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "$\(value)", attributes: [.font: ThemeFont.bold(ofSite: 20)])
                text.addAttributes([.font: ThemeFont.bold(ofSite: 14)], range: NSMakeRange(0, 1))
                customPerButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancelables)
    }
    private func resetView() {
        [tenPerButton, fifteenPerButton, twentyPerButton, customPerButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(string: "Custom tip", attributes: [.font:ThemeFont.bold(ofSite: 20)])
        customPerButton.setAttributedTitle(text, for: .normal)
    }
    
    private func handleCustomTipButton() {
        let alert = UIAlertController(title: "Custom tip", message: "Enter your custom tip", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Make it rain"
            textField.keyboardType = .decimalPad
            textField.autocorrectionType = .no
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, let value = Int(text) else {return}
            self?.tipSubject.send(.custom(value: value))
        }
    
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        parentViewController?.present(alert, animated: true)
    }
    
    func reset() {
        tipSubject.send(.none)
    }
}
