//
//  TextFieldView.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import UIKit
import Combine
import SnapKit

@objc protocol TextFieldViewDelegate: NSObjectProtocol {
    
    @objc optional func textFieldShouldBeginEditing(_ textFieldView: TextFieldView) -> Bool
    @objc optional func textFieldDidBeginEditing(_ textFieldView: TextFieldView)
    @objc optional func textFieldShouldEndEditing(_ textFieldView: TextFieldView) -> Bool
    @objc optional func textFieldDidEndEditing(_ textFieldView: TextFieldView)
    @objc optional func textFieldDidEndEditing(_ textFieldView: TextFieldView, reason: UITextField.DidEndEditingReason)
    @objc optional func textField(_ textFieldView: TextFieldView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textFieldDidChangeSelection(_ textFieldView: TextFieldView)
    @objc optional func textFieldShouldClear(_ textFieldView: TextFieldView) -> Bool
    @objc optional func textFieldShouldReturn(_ textFieldView: TextFieldView) -> Bool
}

final class TextFieldView: UIView {
    
    private let style: TextFieldStyle
    private var state: TextFieldState

    weak var delegate: TextFieldViewDelegate?

    var isSecureTextEntry: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = self.isSecureTextEntry
            self.setState(self.state)
        }
    }

    var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }

    var title: String? {
        get {
            return self.titleLabel.text
        }

        set {
            self.titleLabel.text = newValue
        }
    }

    var placeholder: String? {
        didSet {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                                      attributes:[NSAttributedString.Key.foregroundColor: self.style.getDecoration(state:
                                                                          self.state).placeholderColor])
        }
    }

    var keyboardType: UIKeyboardType {
        get {
            return self.textField.keyboardType
        }
        set {
            self.textField.keyboardType = newValue
        }
    }

    private var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardToolbar.isHidden = true
        textField.font = UIFont(name: "AvenirNext-Regular", size: 16)
        return textField
    }()

    private let contentStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.spacing = Dimension.TextFieldView.SpaceValue.zero
        return stv
    }()

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()

    let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()

    private let textFieldView: UIView = {
        let tfv = UIView()
        return tfv
    }()

    private let message: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()

    var textPublisher: AnyPublisher<String, Never> {
        textSubject.eraseToAnyPublisher()
    }

    var textDidEndEditPublisher: AnyPublisher<String, Never> {
        textDidEndEditSubject.eraseToAnyPublisher()
    }

    var returnPublisher: AnyPublisher<Void, Never> {
        returnSubject.eraseToAnyPublisher()
    }

    private let textSubject = CurrentValueSubject<String, Never>("")
    private let textDidEndEditSubject = CurrentValueSubject<String, Never>("")
    private let returnSubject = PassthroughSubject<Void, Never>()

    private var cancellable = [AnyCancellable]()

    required init(style: TextFieldStyle = .normal(), state: TextFieldState = .normal) {
        self.style = style
        self.state = state
        super.init(frame: .zero)
        self.configUI()
        self.setState(state)
        self.setupPublisher()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateConstraintForTitle()
        self.updateConstraintForDescription()
    }

    private func setupPublisher() {
        self.textField.textPublisher
            .map { $0.unwrapValue() }
            .sink { [weak self] textValue in
                self?.textSubject.send(textValue)
            }
            .store(in: &cancellable)

        self.textField.textDidEndEditPublisher
            .map { $0.unwrapValue() }
            .sink { [weak self] valueText in
                self?.textDidEndEditSubject.send(valueText)
            }
            .store(in: &cancellable)

        self.textField.returnPublisher
            .sink { [weak self] _ in
                self?.returnSubject.send()
            }
            .store(in: &cancellable)
    }

    private func updateConstraintForTitle() {
        self.contentStackView.setCustomSpacing(titleLabel.text != nil ?
            Dimension.TextFieldView.SpaceValue.four :
            Dimension.TextFieldView.SpaceValue.zero,
            after: titleLabel)
    }

    private func updateConstraintForDescription() {
        if self.contentStackView.contains(message) {
            self.contentStackView.setCustomSpacing(descriptionLabel.text != nil ?
                Dimension.TextFieldView.SpaceValue.four :
                Dimension.TextFieldView.SpaceValue.zero,
                after: message)
        } else {
            self.contentStackView.setCustomSpacing(descriptionLabel.text != nil ? Dimension.TextFieldView.SpaceValue.four :
                Dimension.TextFieldView.SpaceValue.zero,
                after: textFieldView)
        }
    }

    private func quickAnimation() {
        UIView.transition(with: self, duration: Constant.TimeInterval.quickAnimation, options: .transitionCrossDissolve, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    private func removeSomeAnimation() {
        self.textField.subviews.forEach { $0.layer.removeAllAnimations() }
        self.textField.rightView?.subviews.forEach { $0.layer.removeAllAnimations() }
        self.textField.rightView?.layer.removeAllAnimations()
        self.textField.layer.removeAllAnimations()
        self.layer.removeAllAnimations()
    }

    private func removeErrorMessage() {
        self.setNeedsLayout()
        self.message.removeFromSuperview()
    }

    private func configUI() {
        self.textField.delegate = self
        self.layoutContentStackView()
        self.layoutTextField()
    }

    private func updateUI(with state: TextFieldState) {
        self.textFieldView.layer.cornerRadius = self.style.getDecoration(state: state).cornerRadius
        self.textFieldView.layer.borderWidth = self.style.getDecoration(state: state).unfocusedBorderWidth
        self.textField.font = self.style.getDecoration(state: state).font
        self.descriptionLabel.font = self.style.getDecoration(state: state).descriptionFont
        self.titleLabel.font = self.style.getDecoration(state: state).titleFont
        self.message.font = self.style.getDecoration(state: state).textErrorFont
        self.titleLabel.textColor = self.style.getDecoration(state: state).titleColor
        self.descriptionLabel.textColor = self.style.getDecoration(state: state).descriptionColor

        self.removeErrorMessage()
        if self.textField.isFirstResponder {
            self.textFieldView.layer.borderColor = self.style.getDecoration(state: self.state).stateColor.cgColor
            self.textFieldView.layer.borderWidth = self.style.getDecoration(state: self.state).focusedBorderWidth
        } else {
            self.textFieldView.layer.borderColor = self.style.getDecoration(state: self.state).unfocusedBorderColor.cgColor
            self.textFieldView.layer.borderWidth = self.style.getDecoration(state: self.state).unfocusedBorderWidth
        }
        self.textFieldView.backgroundColor = self.style.getDecoration(state: self.state).backgroundColor
        self.textField.isUserInteractionEnabled = true
        self.textField.textColor = self.style.getDecoration(state: self.state).textColor
        self.customRightView(with: self.style.getDecoration(state: self.state).rightViewImage)
        self.customLeftView(with: self.style.getDecoration(state: self.state).leftViewImage)
    }

    private func layoutContentStackView() {
        self.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubview(self.titleLabel)
        self.contentStackView.addArrangedSubview(self.textFieldView)
        self.contentStackView.addArrangedSubview(self.descriptionLabel)

        self.contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    private func layoutTextField() {
        self.textFieldView.addSubview(self.textField)

        self.textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Dimension.TextFieldView.SpaceValue.four)
            make.leading.equalToSuperview().offset(Dimension.TextFieldView.SpaceValue.twelve)
            make.height.equalTo(self.style.getDecoration(state: self.state).height)
        }
    }

    private func customRightView(with image: UIImage?) {
        autoreleasepool {
            if self.isSecureTextEntry {
                self.addRightViewWithSecureTextEntry(with: image)
            } else {
                self.addRightViewNoneSecureTextEntry(with: image)
            }
        }
    }

    private func customLeftView(with image: UIImage?) {
        autoreleasepool {
            self.addLeftView(with: image)
        }
    }

    private func addLeftView(with image: UIImage?) {
        guard image != nil else {
            self.textField.leftView = nil
            return
        }
        self.textField.leftViewMode = .always
        let leftViewContainer = UIView(frame: CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                                     y: Dimension.TextFieldView.FrameValue.zero,
                                                     width: Dimension.TextFieldView.FrameValue.width28,
                                                     height: self.style.getDecoration(state: self.state).height))
        let imageView = UIImageView(frame: CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                                  y: Dimension.TextFieldView.FrameValue.zero,
                                                  width: Dimension.Spacing.spacing16,
                                                  height: self.style.getDecoration(state: self.state).height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        leftViewContainer.addSubview(imageView)
        textField.leftViewMode = .always
        self.textField.leftView = leftViewContainer
    }

    private func addRightViewWithSecureTextEntry(with image: UIImage?) {
        self.textField.textColor = isSecureTextEntry ?
            self.style.getDecoration(state: self.state).placeholderColor :
            self.style.getDecoration(state: self.state).textColor
        self.textField.rightViewMode = .always
        let paddingView = UIView(frame: CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                               y: Dimension.TextFieldView.FrameValue.zero,
                                               width: Dimension.TextFieldView.FrameValue.thirty,
                                               height: self.style.getDecoration(state: self.state).height))
        let visiableBtn = UIButton(type: .custom)
        visiableBtn.contentMode = .center
        visiableBtn.frame = CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                   y: Dimension.TextFieldView.FrameValue.zero,
                                   width: Dimension.TextFieldView.FrameValue.thirty,
                                   height: self.style.getDecoration(state: self.state).height)
        visiableBtn.setImage(textField.isSecureTextEntry ? UIImage(named: "ic_eye_slash") : UIImage(named: "ic_eye"), for: .normal)
        visiableBtn.addTarget(self, action: #selector(self.visiable(sender:)), for: .touchUpInside)
        paddingView.addSubview(visiableBtn)

        switch state {
        case .success, .error:
            paddingView.frame.size.width = Dimension.TextFieldView.FrameValue.thirty * 2
            let correctBtn = UIButton(type: .custom)
            correctBtn.setImage(image, for: .normal)
            correctBtn.frame = CGRect(x: Dimension.TextFieldView.FrameValue.thirty,
                                      y: Dimension.TextFieldView.FrameValue.zero,
                                      width: Dimension.TextFieldView.FrameValue.thirty,
                                      height: self.style.getDecoration(state: self.state).height)
            correctBtn.contentMode = .center
            correctBtn.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
            paddingView.addSubview(correctBtn)
        default:
            break
        }
        self.textField.rightView = paddingView
    }

    private func addRightViewNoneSecureTextEntry(with image: UIImage?) {
        switch state {
        case .normal:
            self.textField.rightViewMode = .whileEditing
        default:
            self.textField.rightViewMode = .always
        }
        let paddingView = UIView(frame: CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                               y: Dimension.TextFieldView.FrameValue.zero,
                                               width: Dimension.TextFieldView.FrameValue.thirty,
                                               height: self.style.getDecoration(state: self.state).height))
        let clearButton = UIButton(type: .custom)
        clearButton.contentMode = .center
        paddingView.addSubview(clearButton)
        clearButton.frame = CGRect(x: Dimension.TextFieldView.FrameValue.zero,
                                   y: Dimension.TextFieldView.FrameValue.zero,
                                   width: Dimension.TextFieldView.FrameValue.thirty,
                                   height: self.style.getDecoration(state: self.state).height)
        clearButton.setImage(image, for: .normal)
        clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
        self.textField.rightView = paddingView
    }

    @objc private func visiable(sender: UIButton) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        if textField.isSecureTextEntry {
            sender.setImage(UIImage(named: "ic_eye_slash"), for: .normal)
            self.textField.textColor = self.style.getDecoration(state: self.state).placeholderColor
        } else {
            sender.setImage(UIImage(named: "ic_eye"), for: .normal)
            self.textField.textColor = self.style.getDecoration(state: self.state).textColor
        }
    }

    @objc private func clear(sender: UIButton) {
        switch self.state {
        case .normal:
            self.textField.text = ""
            self.textField.sendActions(for: .editingChanged)
        default:
            break
        }
    }
}

// MARK: Logic UI States

extension TextFieldView {
    func setState(_ state: TextFieldState) {
        self.state = state
        self.updateUI(with: state)
        switch state {
        case let .error(mess, numberOfLines):
            if !self.contentStackView.arrangedSubviews.contains(self.message) {
                let index = self.contentStackView.arrangedSubviews.firstIndex(of: textFieldView)
                self.contentStackView.insertArrangedSubview(self.message, at: index! + 1)
                self.contentStackView.setCustomSpacing(Dimension.TextFieldView.SpaceValue.three, after: textFieldView)
                self.message.textColor = self.style.getDecoration(state: self.state).stateColor
                self.message.numberOfLines = numberOfLines
            }
            self.message.text = mess

        case .unready:
            self.textField.isUserInteractionEnabled = false
            self.textField.textColor = self.style.getDecoration(state: self.state).placeholderColor
            self.textField.rightView = nil
        default:
            return
        }
    }

    private func resetStates() {
        switch self.state {
        case .normal:
            break
        default:
            self.setState(.normal)
            self.quickAnimation()
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resetStates()
        return self.delegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldView.layer.borderColor = self.style.getDecoration(state: self.state).unfocusedBorderColor.cgColor
        self.textFieldView.layer.borderWidth = self.style.getDecoration(state: self.state).unfocusedBorderWidth
        self.delegate?.textFieldDidEndEditing?(self)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldView.layer.borderColor = self.style.getDecoration(state: self.state).focusedBorderColor.cgColor
        self.textFieldView.layer.borderWidth = self.style.getDecoration(state: self.state).focusedBorderWidth
        self.delegate?.textFieldDidBeginEditing?(self)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { self.delegate?.textFieldShouldEndEditing?(self) ?? true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) { self.delegate?.textFieldDidChangeSelection?(self)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool { self.delegate?.textFieldShouldClear?(self) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { self.delegate?.textFieldShouldReturn?(self) ?? true
    }
}

