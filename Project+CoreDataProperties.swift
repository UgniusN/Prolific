import Foundation
import CoreData


extension Project {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var project_id: UUID?
    @NSManaged public var tasks: NSSet?
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var tasksArray: [PlannedTask] {
        let tasksSet = tasks as? Set<PlannedTask> ?? []
        return tasksSet.sorted { $0.wrappedTitle < $1.wrappedTitle }
    }
    
    public var tasksAmount: Int {
        return tasksArray.count
    }
    
    public var completedTasks: Int {
        tasksArray.filter { $0.completed == true }.count
    }
    
    public var progress: CGFloat {
        if tasksAmount == 0 {
            return 0
        } else if(completedTasks == 0) {
            return 0
        } else {
            let resultatas = CGFloat(completedTasks) / CGFloat(tasksAmount)
            return resultatas
        }
    }
    
    private static var projectsFetchRequest: NSFetchRequest<Project> {
        NSFetchRequest(entityName: "Project")
    }
    
    static func all() -> NSFetchRequest<Project> {
        let request: NSFetchRequest<Project> = projectsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Project.name, ascending: true)
        ]
        return request
    }
}


// MARK: Generated accessors for tasks
extension Project {
    
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: PlannedTask)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: PlannedTask)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}

extension Project : Identifiable {
    
}
