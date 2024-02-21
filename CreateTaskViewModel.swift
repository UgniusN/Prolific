import Foundation
import CoreData


class CreateTaskViewModel: ObservableObject {
    
    let container = PersistenceController.shared.container
    
    @Published var currentDate: Date = Date()
    @Published var nextDate: Date = Date()
    
    func addProject(name: String, project: Project, priority: TaskPriority, date: Date) {
        if let exisingProject = container.viewContext.object(with: project.objectID) as? Project {
            let newTask = PlannedTask(context: container.viewContext)
            newTask.title = name
            newTask.priority = priority.rawValue
            newTask.date = date
            exisingProject.addToTasks(newTask)
            
            PersistenceController.shared.save()
        } else {
            
        }
    }
}
