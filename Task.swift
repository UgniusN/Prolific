import Foundation
import SwiftUI

struct Task: View {
    
    var task: PlannedTask
    
    var body: some View {
        VStack(alignment: .leading) {
    
            HStack{
                VStack(alignment: .leading){
                    TaskLabel(taskPriority: TaskPriority(task.wrappedPriority))
                    Text(task.title ?? "")
                        .b1Bold()
                    Spacer().frame(height: 8)
                    Text(format(date: task.wrappedDate))
                        .b3()
                        .foregroundColor(Color("DateTextColor"))
                }
                Spacer()
                NavigationLink(destination: EditTaskScreen().environmentObject(task)) {
                    Image("ButtonEdit")
                }
                Spacer().frame(width: 16)
                
                Button {
                    
                } label: {
                    Image("ButtonPlayLight")
                }
            }
            
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color("TaskColor"))
        .cornerRadius(16)
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // This format specifies "Month day, year"
        return formatter.string(from: date)
    }
}
