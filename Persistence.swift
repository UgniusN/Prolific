//
//  Persistence.swift
//  Prolific
//
//  Created by Ugnius Naujokas on 9/28/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container = NSPersistentContainer(name: "ProjectContainer")
    
    func save() {
        let context = container.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
    }
    
    init(inMemory: Bool = false) {
        container.loadPersistentStores { description, error in
            if let error = error  {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
