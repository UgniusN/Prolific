import Foundation
import SwiftUI

struct HomeScreen: View {
    
    @FetchRequest(fetchRequest: PlannedTask.all()) private var plannedTasksers
    
    var body: some View {
        
        let filteredEntities = plannedTasksers.filter { task in
            guard let date = task.date else {
                return false
            }
            return datesEqual(date1: date, date2: Date())
        }
        let completedCount = filteredEntities.filter { task in task.completed }.count
        let taskPlannedCount = filteredEntities.count
        let plannedTasks = filteredEntities.filter { task in !task.completed}
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 24)
                    VStack(alignment: .leading, spacing: 32) {
                        Header()
                        HStack {
                            InfoBlock(title: "Tasks planned", value: "\(taskPlannedCount)")
                            Spacer().frame(width: 16)
                            InfoBlock(title: "Completed tasks", value: "\(completedCount)")
                        }
                        VStack(spacing: 16) {
                            ForEach(
                                plannedTasks,
                                id: \.self
                            ) { task in TaskView(task: task) }
                        }
                    }
                    Spacer(minLength: 32)
                    Spacer()
                }
                .sidesPadding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
            }
        }
    }
    
    struct Info: View {
        var body: some View {
            HStack {
                InfoBlock(title: "Tasks planned", value: "2")
                Spacer().frame(width: 16)
                InfoBlock(title: "Completed tasks", value: "0")
            }
        }
    }
    
    struct Header: View {
        var body: some View {
            HStack {
                Image("Avataras")
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                Spacer().frame(width: 12)
                VStack(alignment: .leading) {
                    Text("Hey, Micheal Scott!")
                        .h2()
                        .foregroundColor(Color("ColorTitle"))
                    Spacer().frame(height: 8)
                    Text("May 8, Monday")
                        .b3()
                        .foregroundColor(Color("DateTextColor"))
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
