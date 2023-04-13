//
//  AmountView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 02.04.2023..
//

import UIKit

class AmountView: UIView {
    
    private let title: String
    private let textAligment: NSTextAlignment
    
    private lazy var titleLabel: UILabel = {
        LabelFactory.build(text: title, font: ThemeFont.regular(ofSite: 18), textColor: ThemeColor.text, textAligment: textAligment)
    }()
    
    private lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = textAligment
        label.textColor = ThemeColor.primary
        let text = NSMutableAttributedString(string: "0€", attributes: [.font: ThemeFont.bold(ofSite: 24)])
        
        text.addAttributes([.font: ThemeFont.semibold(ofSite: 16)], range: NSMakeRange(text.string.count - 1, 1))
        label.attributedText = text
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        amountLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    init(title: String, textAligment: NSTextAlignment) {
        self.title = title
        self.textAligment = textAligment
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(amount: Double) {
        let text = NSMutableAttributedString(string: amount.currencyFormatted, attributes: [.font: ThemeFont.bold(ofSite: 24)])
        text.addAttributes([.font: ThemeFont.bold(ofSite: 16)], range: NSMakeRange(text.string.count - 1, 1))
        amountLabel.attributedText = text
    }
}
