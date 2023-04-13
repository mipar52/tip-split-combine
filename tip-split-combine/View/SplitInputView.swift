//
//  SplitInputView.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 01.04.2023..
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
       let hView = HeaderView()
        hView.configure(topText: "Split", bottomText: "the total")
        return hView
    }()
    
    private lazy var decButton: UIButton = {
        let button = buildDecButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in //transforms all elements into a new publisher
            Just(self.splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancelables)
        
        return button
    }()
    
    private lazy var incButton: UIButton = {
        let button = buildDecButton(text: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] _ in //transforms all elements into a new publisher
            Just(self.splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancelables)
        
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSite: 20), backgroundColor: .white)
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [decButton, quantityLabel, incButton])
        hStack.axis = .horizontal
        hStack.spacing = 0
        return hStack
    }()
    
    private let splitSubject: CurrentValueSubject<Int,Never> = .init(1)
    var splitPublisher: AnyPublisher<Int, Never> {
        return splitSubject.eraseToAnyPublisher()
    }
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        obeserve()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(headerView)
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incButton, decButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(hStackView.snp.centerY)
            make.trailing.equalTo(hStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
}

extension SplitInputView {
    
    private func obeserve() {
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.stringValue
        }.store(in: &cancelables)
    }
    private func buildDecButton(text: String, corners: CACornerMask) -> UIButton {
        
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.backgroundColor = ThemeColor.primary
        button.titleLabel?.font = ThemeFont.bold(ofSite: 20)
        button.addRoundedCorners(corners: corners, radius: 8.0)
        return button
    }
    
    func reset() {
        splitSubject.send(1)
    }
}
