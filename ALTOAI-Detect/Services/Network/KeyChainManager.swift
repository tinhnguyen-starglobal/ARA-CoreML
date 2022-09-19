//
//  KeychainManager.swift
//  ALTOAI-Detect
//
//  Created by Volodymyr Grek on 27.07.2021.
//

import Foundation
import SimpleKeychain

class KeyChainManager {
    
    enum Key: String {
        case onDeviceAPIKey
        case onDeviceSecretKey
        case onDeviceToken
        case isOnDeviceSignedIn
        
        case outDeviceAPIKey
        case outDeviceSecretKey
        case outDeviceToken
        case isOutDeviceSignedIn
    }
    
    static let shared: KeyChainManager = {
        return KeyChainManager()
    }()
    
    func getUserOnDevice() -> (apiKey: String?, secretKey: String?) {
        let apiKey = A0SimpleKeychain().string(forKey: Key.onDeviceAPIKey.rawValue)
        let secretKey = A0SimpleKeychain().string(forKey: Key.onDeviceSecretKey.rawValue)
        return (apiKey, secretKey)
    }
    
    func getUserOutDevice() -> (apiKey: String?, secretKey: String?) {
        let apiKey = A0SimpleKeychain().string(forKey: Key.outDeviceAPIKey.rawValue)
        let secretKey = A0SimpleKeychain().string(forKey: Key.outDeviceSecretKey.rawValue)
        return (apiKey, secretKey)
    }
    
    func setUserOnDevice(apiKey: String, secretKey: String) {
        A0SimpleKeychain().setString(apiKey, forKey: Key.onDeviceAPIKey.rawValue)
        A0SimpleKeychain().setString(secretKey, forKey: Key.onDeviceSecretKey.rawValue)
    }
    
    func setUserOutDevice(apiKey: String, secretKey: String) {
        A0SimpleKeychain().setString(apiKey, forKey: Key.outDeviceAPIKey.rawValue)
        A0SimpleKeychain().setString(secretKey, forKey: Key.outDeviceSecretKey.rawValue)
    }
    
    func getTokenOnDevice() -> String? {
        return A0SimpleKeychain().string(forKey: Key.onDeviceToken.rawValue)
    }
    
    func getTokenOutDevice() -> String? {
        return A0SimpleKeychain().string(forKey: Key.outDeviceToken.rawValue)
    }
    
    func setTokenOnDevice(token: String) {
        A0SimpleKeychain().setString(token, forKey: Key.onDeviceToken.rawValue)
    }
    
    func setTokenOutDevice(token: String) {
        A0SimpleKeychain().setString(token, forKey: Key.outDeviceToken.rawValue)
    }
    
    func signInUserOnDevice() {
        A0SimpleKeychain().setString("true", forKey: Key.isOnDeviceSignedIn.rawValue)
    }
    
    func signInUserOutDevice() {
        A0SimpleKeychain().setString("true", forKey: Key.isOutDeviceSignedIn.rawValue)
    }
    
    func signOutUserOnDevice() {
        A0SimpleKeychain().setString("false", forKey: Key.isOnDeviceSignedIn.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.onDeviceToken.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.onDeviceAPIKey.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.onDeviceSecretKey.rawValue)
    }
    
    func signOutUserOutDevice() {
        A0SimpleKeychain().setString("false", forKey: Key.isOutDeviceSignedIn.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.outDeviceToken.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.outDeviceAPIKey.rawValue)
        A0SimpleKeychain().deleteEntry(forKey: Key.outDeviceSecretKey.rawValue)
    }
    
    func isUserSignedInOnDevice() -> Bool {
        return A0SimpleKeychain().string(forKey: Key.isOnDeviceSignedIn.rawValue) == "true"
    }
    
    func isUserSignedInOutDevice() -> Bool {
        return A0SimpleKeychain().string(forKey: Key.isOutDeviceSignedIn.rawValue) == "true"
    }
    
    func signInOnDevice(apiKey: String, secretKey: String, token: String) {
        setUserOnDevice(apiKey: apiKey, secretKey: secretKey)
        setTokenOnDevice(token: token)
        signInUserOnDevice()
    }
    
    func signInOutDevice(apiKey: String, secretKey: String, token: String) {
        setUserOutDevice(apiKey: apiKey, secretKey: secretKey)
        setTokenOutDevice(token: token)
        signInUserOutDevice()
    }
}
