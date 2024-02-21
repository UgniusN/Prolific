import Foundation

class ProjectInfoViewModel: ObservableObject {
    
    let container = PersistenceController.shared.container
    
    @Published var editMode: Bool = false
    
    func onDeleteClick(project: Project) throws {
        let context = container.viewContext
        let existingProject = try context.existingObject(with: project.objectID)
        context.delete(existingProject)
        try context.save()
    }
}
