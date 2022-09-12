//
//  RadioButton.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 12/09/2022.
//

import UIKit
import Combine

final class RadioButton: UIView {
    
    // MARK: - Define Variables
    private var cancellable = Set<AnyCancellable>()

    private let style: RadioButtonStyle
    
    @Published private(set) var isSelected: Bool = false
    
    let borderView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()

    let centerCircleView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    required init(style: RadioButtonStyle) {
        self.style = style
        self.isSelected = false

        super.init(frame: .zero)
        self.setupComponents()
    }

    required init?(coder: NSCoder) {
        self.style = .unfocused
        self.isSelected = false

        super.init(coder: coder)
        self.setupComponents()
    }

    // MARK: - Setup UI
    func setupComponents() {
        self.setState(self.isSelected)

        self.snp.makeConstraints { make in
            make.width.equalTo(Dimension.RadioButton.width)
            make.height.equalTo(self.snp.width)
        }

        self.setupBorderView()
        self.setupCenterCircleView()
    }

    private func setupBorderView() {
        self.addSubview(self.borderView)
        self.borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupCenterCircleView() {
        self.borderView.addSubview(self.centerCircleView)
        self.centerCircleView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Dimension.RadioButton.circleCenterPadding)
        }
    }

    // MARK: - Override functions

    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderView.layer.cornerRadius = self.borderView.bounds.size.width / 2.0
        self.borderView.layoutIfNeeded()
        self.centerCircleView.layer.cornerRadius = self.centerCircleView.bounds.size.width / 2.0
    }

    // MARK: - Support Methods

    func addTapGesture() {
        self.gesture().sink { [weak self] _ in
            guard let self = self else { return }
            self.setState(true)
        }.store(in: &self.cancellable)
    }

    func setState(_ isSelected: Bool) {
        self.isSelected = isSelected
        self.setColor(by: style.getDecoration(isSelected))
    }

    private func setColor(by decoration: RadioButtonDecorator) {
        self.borderView.layer.borderColor = decoration.borderColor.cgColor
        self.borderView.layer.borderWidth = decoration.borderWidth
        self.centerCircleView.backgroundColor = decoration.centerCircleColor
    }

}
