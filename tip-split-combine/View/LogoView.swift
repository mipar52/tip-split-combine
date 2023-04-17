//
//  LogoView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit

class LogoView: UIView {
    
    private let imageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "icCalculatorBW"))
            logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
//        let text = NSMutableAttributedString(string: "Mr TIP", attributes: [.font: ThemeFont.semibold(ofSite: 16)])
//        text.addAttributes([.font: ThemeFont.bold(ofSite: 24)], range: NSMakeRange(3, 3))
        let text = NSMutableAttributedString(string: "TIP", attributes: [.font: ThemeFont.bold(ofSite: 24)])
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(text: "Calculator", font: ThemeFont.semibold(ofSite: 20), textAligment: .left)
    }()
    
    private lazy var vStackView: UIStackView = {
       let vStack = UIStackView(arrangedSubviews: [
       topLabel,
       bottomLabel
       ])
        vStack.axis = .vertical
        vStack.spacing = -4
        return vStack
    }()
                               
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        imageView,
        vStackView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
        }()
    
    init() {
        super.init(frame: .zero)
        accessibilityIdentifier = ScreenIdentifier.LogoView.logoView.rawValue
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}
