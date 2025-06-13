import Foundation
import Storage

enum BackupErrors: Error {
    case notSupportedBackupType
}

struct BackupModel: Codable {
    
    let dto: any DTODescription
    
    enum CodingKeys: CodingKey {
        //base
        case id
        case date
        case title
        case subtitle
        case completedDate
        case work
        case other
        case critical
        case highPriority
        case mediumPriority
        case lowPriority
        case type
        //date
        case targetDate
        //timer
        case seconds
        //location
        case x
        case y
        case radius
        case url
    }
    
    init(dto: any DTODescription) {
        self.dto = dto
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //main
        let type = try container.decode(String.self, forKey: .type)
        let id = try container.decode(String.self, forKey: .id)
        let dateTimerInterval = try container.decode(Double.self, forKey: .date)
        let title = try container.decode(String.self, forKey: .title)
        let subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        let completedDateTimeInterval = try container.decodeIfPresent(Double.self, forKey: .completedDate)
        let work = try container.decodeIfPresent(String.self, forKey: .work)
        let other = try container.decodeIfPresent(String.self, forKey: .other)
        let critical = try container.decodeIfPresent(String.self, forKey: .critical)
        let highPriority = try container.decodeIfPresent(String.self, forKey: .highPriority)
        let mediumPriority = try container.decodeIfPresent(String.self, forKey: .mediumPriority)
        let lowPriority = try container.decodeIfPresent(String.self, forKey: .lowPriority)
        
        if type == "date" {
            
            let targetDateTimeInterval = try container.decode(Double.self, forKey: .targetDate)
            
            let dateDTO = DateNotificationDTO(
                id: id,
                title: title,
                subtitle: subtitle,
                date: Date(timeIntervalSince1970: dateTimerInterval),
                completedDate: Date(completedDateTimeInterval),
                targetDate: Date(timeIntervalSince1970: targetDateTimeInterval),
                work: work,
                other: other,
                critical: critical,
                highPriority: highPriority,
                mediumPriority: mediumPriority,
                lowPriority: lowPriority
            )
            
            self.dto = dateDTO
            return
        } else if type == "timer" {
            
            let seconds = try container.decode(Double.self, forKey: .seconds)
            
            let timerDTO = TimerNotificationDTO(
                id: id,
                title: title,
                subtitle: subtitle,
                date: Date(timeIntervalSince1970: dateTimerInterval),
                completedDate: Date(completedDateTimeInterval),
                seconds: seconds,
                work: work,
                other: other,
                critical: critical,
                highPriority: highPriority,
                mediumPriority: mediumPriority,
                lowPriority: lowPriority
            )
            
            self.dto = timerDTO
            return
        } else if type == "location" {
            
            let x = try container.decode(Double.self, forKey: .x)
            let y = try container.decode(Double.self, forKey: .y)
            let radius = try container.decode(Double.self, forKey: .radius)
            let url = try container.decode(String.self, forKey: .url)
            
            let locationDTO = LocationNotificationDTO(
                id: id,
                title: title,
                subtitle: subtitle,
                date: Date(timeIntervalSince1970: dateTimerInterval),
                completedDate: Date(completedDateTimeInterval),
                x: x,
                y: y,
                radius: radius,
                url: url,
                work: work,
                other: other,
                critical: critical,
                highPriority: highPriority,
                mediumPriority: mediumPriority,
                lowPriority: lowPriority
            )
            
            self.dto = locationDTO
            return
        }
        
        throw BackupErrors.notSupportedBackupType
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        //base
        try container.encode(dto.id, forKey: .id)
        
        try container.encode(dto.date, forKey: .date)
        
        try container.encode(dto.title, forKey: .title)
        
        try container.encode(dto.subtitle, forKey: .subtitle)
        
        if let completedDate = dto.completedDate {
            try container.encode(
                completedDate.timeIntervalSince1970,
                forKey: .completedDate
            )
        }
        
        try container.encode(dto.work, forKey: .work)
        
        try container.encode(dto.other, forKey: .other)
        
        try container.encode(dto.critical, forKey: .critical)
        
        try container.encode(dto.highPriority, forKey: .highPriority)
        
        try container.encode(dto.mediumPriority, forKey: .mediumPriority)
        
        try container.encode(dto.lowPriority, forKey: .lowPriority)
        
        if let dateDTO = dto as?  DateNotificationDTO {
            
            try container.encode(dateDTO.targetDate.timeIntervalSince1970, forKey: .targetDate)
            try container.encode("date", forKey: .type)
        }   else if let timerDTO = dto as? TimerNotificationDTO {
            
            try container.encode(timerDTO.seconds, forKey: .seconds)
            try container.encode("timer", forKey: .type)
        } else if let locationDTO = dto as? LocationNotificationDTO {
            
            try container.encode(locationDTO.x, forKey: .x)
            try container.encode(locationDTO.y, forKey: .y)
            try container.encode(locationDTO.radius, forKey: .radius)
            try container.encode(locationDTO.url, forKey: .url)
            try container.encode("location", forKey: .type)
        }
        
    }
    
    func buildDict() -> [String: Any]? {
        guard
            let data = try? JSONEncoder().encode(self),
            let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        else { return nil }
        
        return dict as? [String: Any]
    }
}
