//
//  File.swift
//  referkit-ios
//
//  Created by Zach Danielson! on 4/15/25.
//

import Foundation

internal class ReferKitStorage {
    private enum Keys {
        static let affiliateCode = "referkit_affiliate_code"
        static let installId = "referkit_install_id"
    }
    
    static let shared = ReferKitStorage()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Affiliate Code
    
    func saveAffiliateCode(_ code: String) {
        defaults.set(code, forKey: Keys.affiliateCode)
    }
    
    func getAffiliateCode() -> String? {
        return defaults.string(forKey: Keys.affiliateCode)
    }
    
    // MARK: - Install ID
    
    func saveInstallId(_ id: UUID) {
        defaults.set(id.uuidString, forKey: Keys.installId)
    }
    
    func getInstallId() -> UUID? {
        guard let idString = defaults.string(forKey: Keys.installId) else {
            return nil
        }
        return UUID(uuidString: idString)
    }
    
    func generateAndSaveInstallId() -> UUID {
        let id = UUID()
        saveInstallId(id)
        return id
    }
    
    // MARK: - Utility
    
    func clearAll() {
        defaults.removeObject(forKey: Keys.affiliateCode)
        defaults.removeObject(forKey: Keys.installId)
    }
}
