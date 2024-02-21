import Foundation

class EditTaskViewModel: ObservableObject {
    
    let container = PersistenceController.shared.container
    
    @Published var currentDate: Date = Date()
    @Published var nextDate: Date = Date()
    
    func updateTask(name: String, task: PlannedTask, priority: TaskPriority, date: Date) {
        let context = container.viewContext
        task.title = name
        task.priority = priority.rawValue
        task.date = date
    
        do {
            try task.managedObjectContext?.save()
        } catch {
            
        }
    }
    
    func onDeleteTaskClick(task: PlannedTask) throws {
        let context = container.viewContext
        let existingTask = try context.existingObject(with: task.objectID)
        context.delete(existingTask)
        try context.save()
    }
}
