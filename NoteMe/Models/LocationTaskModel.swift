import UIKit

public struct LocationTaskModel {
    public let identifier: String
    public let title: String
    public let subtitle: String
    public let url : String
    public let createdAt: Date
 
    public let completedDate: Date
    public let x: Double
    public let y: Double
    public let radius: Double
}
