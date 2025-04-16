import Foundation

public class ReferKit {
    
    // MARK: - Configuration
    
    /// Configure ReferKit with your API key
    /// - Parameters:
    ///   - apiKey: Your ReferKit API key
    ///   - environment: The environment to use (default is .production)
    public static func configure(apiKey: String, environment: ReferKitConfig.Environment = .production) {
        ReferKitConfig.shared.configure(apiKey: apiKey, environment: environment)
    }
    
    // MARK: - Affiliate Matching
    
    /// Attempt to match the current user with an affiliate
    /// - Parameter completion: Callback with optional affiliate code if matched
    public static func matchAffiliate(completion: @escaping (String?) -> Void) {
        ReferKitNetwork.shared.sendMatchRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let affiliateCode = response.affiliateCode {
                        ReferKitStorage.shared.saveAffiliateCode(affiliateCode)
                        completion(affiliateCode)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Purchase Tracking
    
    /// Track an in-app purchase
    /// - Parameters:
    ///   - amount: Purchase amount
    ///   - currency: Currency code (e.g., "USD")
    ///   - productId: Product identifier
    ///   - completion: Optional completion handler with success status
    public static func trackPurchase(
        amount: Double,
        currency: String,
        productId: String,
        completion: ((Bool) -> Void)? = nil
    ) {
        ReferKitNetwork.shared.sendPurchaseEvent(
            amount: amount,
            currency: currency,
            productId: productId
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion?(true)
                case .failure:
                    completion?(false)
                }
            }
        }
    }
    
    // MARK: - Utility
    
    /// Get the currently stored affiliate code
    /// - Returns: The affiliate code if one exists
    public static func getAffiliateCode() -> String? {
        return ReferKitStorage.shared.getAffiliateCode()
    }
    
    /// Clear all stored ReferKit data
    public static func reset() {
        ReferKitStorage.shared.clearAll()
    }
} 