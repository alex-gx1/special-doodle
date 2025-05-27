import Foundation
import CoreData

@objc(LocationNotificationMO)
public class LocationNotificationMO: BaseNotificationMO {
    
    public override func toDTO() -> (any DTODescription)? {
        return LocationNotificationDTO.fromMO(self)
    }
    
    public override func apply(dto: any DTODescription) {
        guard let locationDTO = dto as? LocationNotificationDTO
        else {
            print("[MODTO]", "apply failed: dto is type of \(type(of: dto))")
            return
        }
        super.apply(dto: locationDTO)
        self.x = locationDTO.x
        self.y = locationDTO.y
        self.radius = locationDTO.radius
        self.url = locationDTO.url
    }
}
