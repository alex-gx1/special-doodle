import UIKit

enum FilterItem: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
    case date = "Date"
    case location = "Location"
    case timer = "Timer"
    case work = "Work"
    case other = "Other"
    case critical = "Critical"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}
