//
//  ProjectItemEntity+CoreDataProperties.swift
//  Prolific
//
//  Created by Ugnius Naujokas on 10/2/23.
//
//

import Foundation
import CoreData


extension ProjectItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectItemEntity> {
        return NSFetchRequest<ProjectItemEntity>(entityName: "ProjectItemEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension ProjectItemEntity {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: TaskEntity)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: TaskEntity)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension ProjectItemEntity : Identifiable {

}
