import Foundation

class TaskEngagementViewModel: ObservableObject {
    
    let container = PersistenceController.shared.container
    
    func onCompleteClick(task: PlannedTask) {
        task.completed = true
        do {
           try container.viewContext.save()
        } catch {
            
        }
    }
}
