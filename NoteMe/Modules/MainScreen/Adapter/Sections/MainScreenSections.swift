import UIKit

enum MainScreenSections {
    case Date
    case Timer
}

enum MainScreenInput {
    case timer([TimerTaskModel])
    case date([DateTaskModel])
}

