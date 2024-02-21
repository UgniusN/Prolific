//
//  TaskEntity+CoreDataProperties.swift
//  Prolific
//
//  Created by Ugnius Naujokas on 10/2/23.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var priority: String?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var project: ProjectItemEntity?

}
