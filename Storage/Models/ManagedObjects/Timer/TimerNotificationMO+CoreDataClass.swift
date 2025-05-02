import Foundation
import CoreData

@objc(TimerNotificationMO)
public class TimerNotificationMO: BaseNotificationMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return TimerNotificationDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let timerDTO = dto as? TimerNotificationDTO
        else {
            print("[MODTO]", "apply failed: dto is type of \(type(of: dto))")
            return
        }
        super.apply(dto: timerDTO)
        self.seconds = timerDTO.seconds
    }
}
