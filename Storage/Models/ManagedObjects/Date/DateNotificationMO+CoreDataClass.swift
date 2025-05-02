import Foundation
import CoreData

@objc(DateNotificationMO)
public class DateNotificationMO: BaseNotificationMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return DateNotificationDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let dateDTO = dto as? DateNotificationDTO
        else {
            print("[MODTO]", "apply failed: dto is type of \(type(of: dto))")
            return
        }
        super.apply(dto: dto)
        self.targetDate = dateDTO.targetDate
    }
}

