import UIKit

public struct TimerTaskModel {
    public let identifier: String
    public let title: String
    public let subtitle: String
    public let seconds: Double
    public let createdAt: Date
    public let completedDate: Date
    public let work: String
    public let other: String
    public let critical: String
    public let highPriority: String
    public let mediumPriority: String
    public let lowPriority: String
}
