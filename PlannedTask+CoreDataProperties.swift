import Foundation
import CoreData

extension PlannedTask {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlannedTask> {
        return NSFetchRequest<PlannedTask>(entityName: "PlannedTask")
    }
    
    private static var tasksFetchRequest: NSFetchRequest<PlannedTask> {
        NSFetchRequest(entityName: "PlannedTask")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var priority: String?
    @NSManaged public var task_id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var project: Project?
    @NSManaged public var completed: Bool
    
    public var wrappedTitle: String {
        title ?? ""
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    override public func awakeFromInsert() {
        task_id = UUID()
        date = Date()
        completed = false
    }
    
    public var wrappedPriority: String {
        return priority ?? ""
    }
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
    }
    
    static func all() -> NSFetchRequest<PlannedTask> {
        let request: NSFetchRequest<PlannedTask> = tasksFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PlannedTask.title, ascending: true)
        ]
        return request
    }
}

extension PlannedTask : Identifiable {
    
}
