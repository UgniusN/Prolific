import Foundation
import CoreData

class ProjectsViewModel: ObservableObject {
    
    let container  = PersistenceController.shared
    
    @Published var creationActive: Bool = false
    @Published var title: String = ""

    
    func addProject(name: String) {
        let newProject = Project(context: container.container.viewContext)
        newProject.name = name
        newProject.project_id = UUID()
        PersistenceController.shared.save()
        
        onCancelClick()
    }
    
    func onCancelClick() {
        creationActive = false
        title = ""
    }
}
