import UIKit

public struct DateTaskModel {
    public let identifier: String
    public let title: String
    public let subtitle: String
    public let dateString: String
    public let day: String
    public let month: String
    
    public let createdAt: Date
    public let targetDate: Date
    public let completedDate: Date
}

