//
//  HeaderView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 02.04.2023..
//

import UIKit

class HeaderView: UIView {
    
    private let topLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.bold(ofSite: 18))
    }()

    private let bottomLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.regular(ofSite: 16))
    }()
    
    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()
    
    private lazy var stackView: UIStackView = {
       let vStack = UIStackView(arrangedSubviews: [
       topSpacerView,
       topLabel,
       bottomLabel,
       bottomSpacerView])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = -4
        return vStack
    }()
    
    init() {
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
        
        topSpacerView.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacerView)
        }
        
    }
    func configure(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }

}
