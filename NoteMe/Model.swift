import Foundation
import UIKit

struct UserData: Identifiable {
    var id: String = UUID().uuidString
    let email: String
    let password: String
    var name: String? = nil
     
}
