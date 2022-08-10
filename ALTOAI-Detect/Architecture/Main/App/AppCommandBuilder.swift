//
//  AppCommandBuilder.swift
//  ALTOAI-Detect
//
//  Created by Tinh Nguyen on 11/08/2022.
//

import Foundation

protocol Command {
    func execute()
}

final class AppCommandBuilder {
    let actions: [Command] = [InitializeComponentCommand()]
}
