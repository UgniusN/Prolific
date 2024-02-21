import Foundation
import SwiftUI

struct ProjectsScreen: View {
    
    @ObservedObject
    private var viewModel = ProjectsViewModel()
    
    private var kazkas: State<String> = State(initialValue: "")
    
    @FetchRequest(fetchRequest: Project.all()) private var projectai
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    Spacer().frame(height: 24)
                    Header(
                        creationInProgress: $viewModel.creationActive,
                        onCreateClick: {
                            viewModel.creationActive = true
                        },
                        onConfirmClick: {
                            viewModel.addProject(name: kazkas.projectedValue.wrappedValue)
                        },
                        onCancelClick: { viewModel.onCancelClick() }
                    )
                    Spacer().frame(height: 24)
                    
                    if(viewModel.creationActive) {
                        CreateProject(title: kazkas)
                    }
                    ForEach(projectai) { project in
                        NavigationLink(
                            destination: ProjectInfoScreen(project: project)
                        ) {
                            VStack(alignment: .leading) {
                                Text(project.wrappedName)
                                    .h2()
                                    .foregroundColor(Color("Neutral50"))
                                Spacer().frame(height: 8)
                                let name = if(project.tasksArray.isEmpty) {
                                    " "
                                } else {
                                    "May 6 - 19, 2023"
                                }
                                Text(name)
                                    .b2()
                                    .foregroundColor(Color("Purple200"))
                                Spacer().frame(height: 32)
                                ZStack(alignment: .leading) {
                                    CustomProgressView(progress: project.progress)
                                    Text("\(project.completedTasks)/\(project.tasksAmount)")
                                        .b1Bold()
                                        .foregroundColor(Color("Purple500"))
                                        .frame(height: 24)
                                        .padding(.leading,8)
                                }
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(16)
                            .background(Color("Purple500"))
                            .cornerRadius(24)
                        }
                        Spacer().frame(height: 16)
                    }
                    
                    Spacer()
                }
                .sidesPadding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private struct Header: View {
        @Binding var creationInProgress: Bool
        private var onCreateClick: () -> Void
        private var onConfirmClick: () -> Void
        private var onCancelClick: () -> Void
        
        init(
            creationInProgress: Binding<Bool>,
            onCreateClick: @escaping () -> Void,
            onConfirmClick: @escaping () -> Void,
            onCancelClick: @escaping () -> Void
        ) {
            self._creationInProgress = creationInProgress
            self.onCreateClick = onCreateClick
            self.onConfirmClick = onConfirmClick
            self.onCancelClick = onCancelClick
        }
        
        var body: some View {
            HStack {
                Text("Projects")
                    .title()
                Spacer()
                if(creationInProgress) {
                    EditModeRow(
                        onConfirmClick: onConfirmClick,
                        onCancelClick: onCancelClick
                    )
                } else {
                    Button {
                        onCreateClick()
                    } label: {
                        Image("ButtonPlus")
                    }
                }
            }
        }
    }
    
    struct CustomProgressView: View {
        @State private var progressas: CGFloat = 0.0
        
        let progress: CGFloat
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    Rectangle()
                        .frame(width: geometry.size.width, height: 24)
                        .foregroundColor(Color("Purple300"))
                        .cornerRadius(12)
                    
                    Rectangle()
                        .frame(
                            width: min(progressas * geometry.size.width, geometry.size.width),
                            height: 24
                        )
                        .foregroundColor(Color("Neutral50"))
                        .cornerRadius(12)
                }.onAppear {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        progressas = progress
                    }
                }
            }
        }
    }
    
    private struct EditModeRow: View {
        private var onConfirmClick: () -> Void
        private var onCancelClick: () -> Void
        
        init(onConfirmClick: @escaping () -> Void, onCancelClick: @escaping () -> Void) {
            self.onConfirmClick = onConfirmClick
            self.onCancelClick = onCancelClick
        }
        
        var body: some View {
            HStack {
                Button {
                    onConfirmClick()
                } label: {
                    Image("ButtonCheckMark")
                }
                Spacer().frame(width: 16)
                Button {
                    onCancelClick()
                } label: {
                    Image("ButtonClose")
                }
            }
        }
    }
    
    private struct ProjectList: View {
        
        @Binding var isCreationActive: Bool
        var projectList: [Project]
        
        var amogus: State<String>
        
        init(
            isCreationActive: Binding<Bool>,
            projectList: [Project],
            amogus: State<String>
        ) {
            self._isCreationActive = isCreationActive
            self.projectList = projectList
            self.amogus = amogus
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                if(isCreationActive) {
                    CreateProject(title: amogus)
                }
                ForEach(projectList) { projectas in
                    ProjectView(project: projectas)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private struct CreateProject: View {
        
        @State var title: String = ""
        
        init(title: State<String>) {
            self._title = title
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                TextField(
                    text: $title,
                    prompt: Text("Project name...")
                        .font(.custom("InterTight-Bold", size: 24))
                        .foregroundColor(Color("Purple300"))
                        .underline()
                ){
                    Text("Amogus")
                        .font(.custom("InterTight-Bold", size: 24))
                        .foregroundColor(Color("Purple300"))
                }
                .font(.custom("InterTight-Bold",size: 24))
                .foregroundColor(Color("Purple300"))
                .underline()
                .onSubmit { }
                Spacer().frame(height: 96)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(16)
            .background(Color("Purple500"))
            .cornerRadius(24)
        }
    }
}

struct ProjectsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsScreen()
    }
}
