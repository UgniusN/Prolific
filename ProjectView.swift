import Foundation
import SwiftUI

struct ProjectView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        NavigationLink(destination: ProjectInfoScreen(project: project)) {
            VStack(alignment: .leading) {
                Text(project.wrappedName)
                    .h2()
                    .foregroundColor(Color("Neutral50"))
                Spacer().frame(height: 8)
                Text("May 6 - 19, 2023")
                    .b2()
                    .foregroundColor(Color("Purple200"))
                Spacer().frame(height: 32)
                Text("\(project.completedTasks)/\(project.tasksAmount)")
                    .b1Bold()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(16)
            .background(Color("Purple500"))
            .cornerRadius(24)
        }
    }
}
