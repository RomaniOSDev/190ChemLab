import Foundation

enum AppLinks: String {
    case privacyPolicy = "https://www.termsfeed.com/live/77f9323a-a91b-4163-a3e6-c8ff9df8e335"
    case termsOfUse = "https://www.termsfeed.com/live/dc5f9cf2-6e79-498a-8bbe-c5666e0084a8"

    var url: URL? {
        URL(string: rawValue)
    }
}
