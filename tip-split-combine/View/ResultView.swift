//
//  ResultView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit

class ResultView: UIView {
    
    private let personLabel: UILabel = {
        LabelFactory.build(text: "Total p/person", font: ThemeFont.semibold(ofSite: 18))
    }()
    
    private let tipResultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(string: "0€", attributes: [.font: ThemeFont.bold(ofSite: 40)])
        text.addAttributes([.font: ThemeFont.bold(ofSite: 20)], range: NSMakeRange(text.string.count - 1, 1))
        label.attributedText = text
        label.textColor = .black
        return label
    }()

    
    private let totalBillLabel: AmountView = {
        let view = AmountView(title: "Total bill", textAligment: .left)
        return view
    }()
    
    
    private let totalTipLabel: AmountView = {
        let view = AmountView(title: "Total tip", textAligment: .right)
        return view
    }()
        
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [
        personLabel,
        tipResultLabel,
        horizontalLineView,
        buildSpacerView(height: 0),
        hStackView
        ])
        vStack.backgroundColor = .white
        vStack.spacing = 8
        vStack.axis = .vertical
        return vStack
    }()
    
    private lazy var hStackView: UIStackView = {
        let hStack: UIStackView = UIStackView(arrangedSubviews: [
            totalBillLabel,
        UIView(),
            totalTipLabel
        ])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        return hStack
    }()
    
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func configureResult(result: Result) {
         let text = NSMutableAttributedString(string: result.amountPerPerson.currencyFormatted, attributes: [.font: ThemeFont.bold(ofSite: 48)])
            text.addAttributes([.font: ThemeFont.bold(ofSite: 24)], range: NSMakeRange(text.string.count - 1, 1))
         
        tipResultLabel.attributedText = text
        tipResultLabel.adjustsFontSizeToFitWidth = true
         
        totalTipLabel.configure(amount: result.totalTip)
        totalBillLabel.configure(amount: result.totalBill)
    }
    
    private func layout() {
        backgroundColor = .white
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(off: CGSize(width: 0, height: 3), color: .black, radius: 12.0, opacity: 0.1)
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
}
