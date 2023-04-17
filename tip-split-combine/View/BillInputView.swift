//
//  BillInputView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit
import Combine
import CombineCocoa

class BillInputView: UIView {
        
    private let headerView: HeaderView = {
        let headerView = HeaderView()
        headerView.configure(topText: "Enter", bottomText: "your bill")
        return headerView
        
    }()
    
    private let textFieldContinerView: UIView = {
        let textView: UIView = UIView()
        textView.addCornerRadius(radius: 12)
        textView.backgroundColor = .white
        return textView
    }()
    
    private let currencyDenomLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSite: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.semibold(ofSite: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        textField.accessibilityIdentifier = ScreenIdentifier.BillInputView.textField.rawValue
        
//        toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dnBtnPressed))
        toolBar.items = [UIBarButtonItem(systemItem: .flexibleSpace, primaryAction: nil), doneBtn]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        return textField
    }()
    
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    
    var billPublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        textField.textPublisher.sink { [unowned self] text in
            billSubject.send(text?.doubleValue ?? 0.0)
        }.store(in: &cancellables)
    }
    
    private func layout() {
        [headerView, textFieldContinerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(24)
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContinerView.snp.centerY)
            make.trailing.equalTo(textFieldContinerView.snp.leading).offset(-24)
        }
        
        textFieldContinerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContinerView.addSubview(currencyDenomLabel)
        textFieldContinerView.addSubview(textField)
        
        currencyDenomLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContinerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenomLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContinerView.snp.trailing).offset(-16)
        }
    }
    
    func reset() {
        textField.text = nil
        billSubject.send(0)
    }
    
    @objc private func dnBtnPressed() {
        textField.endEditing(true)
    }
}
