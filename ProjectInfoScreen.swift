import Foundation
import SwiftUI

struct ProjectInfoScreen: View {
    
    @ObservedObject
    var project: Project
    
    @ObservedObject
    private var viewModel = ProjectInfoViewModel()
    @EnvironmentObject var navigationVisibilityManager: NavigationVisibilityManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationView {
            VStack {
                Header(
                    editMode: $viewModel.editMode,
                    project: project,
                    onEditClick: {
                        viewModel.editMode = true
                    },
                    onEditCancelClick: {
                        viewModel.editMode = false
                    },
                    onBackClick: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    onDeleteClick: {
                        do {
                            try viewModel.onDeleteClick(project: project)
                        } catch {
                            
                        }
                    }
                )
                TaskList(project: project).offset(y: -50)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
    }
    
    struct Header: View {
        
        var project: Project
        @Binding var editMode: Bool
        private var onEditClick: () -> Void
        private var onEditCancelClick: () -> Void
        private var onBackClick: () -> Void
        private var onDeleteClick: () -> Void
        
        init(
            editMode: Binding<Bool>,
            project: Project,
            onEditClick: @escaping () -> Void,
            onEditCancelClick: @escaping () -> Void,
            onBackClick: @escaping () -> Void,
            onDeleteClick: @escaping () -> Void
        ) {
            self._editMode = editMode
            self.onEditClick = onEditClick
            self.onEditCancelClick = onEditCancelClick
            self.onBackClick = onBackClick
            self.project = project
            self.onDeleteClick = onDeleteClick
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Color.clear // This is to simulate the space for the status bar
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                Spacer().frame(height: 24)
                if(editMode) {
                    HeaderControlEditStateRow(
                        onDeleteClick: { onDeleteClick() },
                        onEditCancelClick: { onEditCancelClick() }
                    )
                } else {
                    HeaderControlRow(
                        onEditClick: { onEditClick() },
                        onBackClick: { onBackClick() }
                    )
                }
                Spacer().frame(height: 16)
                Text(project.wrappedName)
                    .h2()
                    .foregroundColor(Color("Neutral50"))
                    .padding([.leading,.trailing],16)
                Spacer().frame(height: 12)
                Text("\(project.completedTasks)/\(project.tasksAmount)")
                    .h2()
                    .foregroundColor(Color("Neutral50"))
                    .padding([.leading,.trailing],16)
                HStack(alignment: .bottom) {
                    Text("May 6 - 19, 2023")
                        .b2()
                        .foregroundColor(Color("Purple200"))
                    Spacer()
                    let button = if(editMode) { "ButtonCheckMarkWhite" } else { "ButtonPlusWhite" }
                    NavigationLink(destination: CreateTaskScreen().environmentObject(project)) {
                        Image(button)
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 32)
                Spacer().frame(height: 16)
            }
            .background(Color("Purple500"))
            .clipShape(RoundedCorners(tl: 0, tr: 0, bl: 30, br: 30))
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    struct HeaderControlRow: View {
        
        private var onEditClick: () -> Void
        private var onBackClick: () -> Void
        
        init(onEditClick: @escaping () -> Void, onBackClick: @escaping () -> Void) {
            self.onEditClick = onEditClick
            self.onBackClick = onBackClick
        }
        
        var body: some View {
            HStack {
                Spacer().frame(width: 16)
                Button {
                    onBackClick()
                } label: {
                    Image("ButtonBack")
                }
                Spacer()
                Button {
                    onEditClick()
                } label: {
                    Text("Edit")
                        .b1Bold()
                        .foregroundColor(Color("Neutral50"))
                }
                Spacer().frame(width: 32)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
    }
    
    struct HeaderControlEditStateRow: View {
        
        private var onDeleteClick: () -> Void
        private var onEditCancelClick: () -> Void
        
        init(onDeleteClick: @escaping () -> Void, onEditCancelClick: @escaping () -> Void) {
            self.onDeleteClick = onDeleteClick
            self.onEditCancelClick = onEditCancelClick
        }
        
        var body: some View {
            HStack() {
                Button {
                    onEditCancelClick()
                } label: {
                    Text("Cancel")
                        .b1Bold()
                        .foregroundColor(Color("Neutral50"))
                }
                Spacer()
                Button {
                    onDeleteClick()
                } label: {
                    Text("Delete task")
                        .b1Bold()
                        .foregroundColor(Color("Red"))
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .sidesPadding()
        }
    }
    
    struct TaskList: View {
        
        @ObservedObject
        var project: Project
        
        @State var isExpanded: Bool = false
        
        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(project.tasksArray.filter { task in !task.completed}) { task in
                        TaskView(task: task)
                    }
                }
                if(!project.tasksArray.isEmpty) {
                    Spacer(minLength: 32)
                    HStack {
                        Text("Completed tasks")
                            .b1Bold()
                            .foregroundColor(Color("Neutral400Neutral500"))
                        Spacer()
                        Button {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        } label: {
                            if isExpanded {
                                Image("IconArrowUp")
                            } else {
                                Image("IconArrowDown")
                            }
                        }
                    }
                    if(isExpanded) {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(project.tasksArray.filter { task in task.completed }) { task in
                                CompletedTask(task: task)
                            }
                        }.transition(.opacity)
                    }
                }
            }
            .sidesPadding()
        }
    }
}

struct CompletedTask: View {
    
    var task: PlannedTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.wrappedTitle)
                    .b1Bold()
                Spacer().frame(height: 8)
                Text(format(date: task.wrappedDate))
                    .b3()
                    .foregroundColor(Color("DateTextColor"))
            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color("TaskColor"))
        .cornerRadius(16)
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let project = Project(context: PersistenceController.shared.container.viewContext)
        ProjectInfoScreen(project: project)
    }
}
