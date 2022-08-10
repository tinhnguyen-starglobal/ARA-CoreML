//
//  InitializeComponentCommand.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import Foundation
import IQKeyboardManagerSwift

final class InitializeComponentCommand: Command {
    
    func execute() {
        configureKeyboardManager()
    }
    
    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
