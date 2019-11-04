import Foundation

struct AppUser {
    let userId: String
    
    init(data: [String: Any]) {
        userId = data["userId"] as! String
    }
}
