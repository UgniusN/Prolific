import Foundation
import SwiftUI

struct EditTaskScreen: View {
    
    @EnvironmentObject
    var task: PlannedTask
    
    @EnvironmentObject
    var project: Project
    
    @ObservedObject
    private var viewModel = EditTaskViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedTaskPriority: TaskPriority = TaskPriority.high
    
    @State private var textInput: String = ""
    
    @State private var currentDate = Date()
    @State private var weekDates: [Date] = []
    @State private var selectedDate = Date.now
    
    var body: some View {
        
        let labelList: [TaskPriority] = [
            TaskPriority.high,
            TaskPriority.medium,
            TaskPriority.low
        ]
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                @State var title: State<String> = State(initialValue: "")
                Spacer().frame(height: 24)
                
                Header(
                    onBackClick: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    onDeleteTaskClick: {
                        do {
                            try viewModel.onDeleteTaskClick(task: task)
                        } catch {
                            
                        }
                    }
                )
                Spacer().frame(height: 32)
                TextField(
                    text: $textInput,
                    prompt: Text("Task name")
                        .font(.custom("InterTight-Regular",size: 16))
                        .foregroundColor(Color("Neutral500"))
                ){
                    Text("Amogus")
                        .font(.custom("InterTight-Bold",size: 24))
                        .foregroundColor(Color("Purple300"))
                }
                .font(.custom("InterTight-Regular",size: 16))
                .foregroundColor(Color("InputTextColor"))
                .onSubmit {}
                .padding(16)
                .background(Color("InputFieldBackground"))
                .cornerRadius(16)
                Spacer().frame(height: 32)
                VStack(alignment: .leading) {
                    Text("Task priority")
                        .b1Bold()
                    Spacer().frame(height: 16)
                    HStack(spacing: 16) {
                        ForEach(labelList) { label in
                            Button {
                                selectedTaskPriority = label
                            } label: {
                                TaskLabelSelectable(
                                    taskPriority: label,
                                    selectedLabel: $selectedTaskPriority
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                Spacer().frame(height: 32)
                HStack {
                    Text("Task date").b1Bold()
                    Spacer()
                    Button {
                        guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
                        currentDate = nextWeek
                        updateWeekDates()
                    } label: {
                        Image("ArrowLeftSmall")
                    }
                    Spacer().frame(width: 12)
                    Button {
                        guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
                        currentDate = nextWeek
                        updateWeekDates()
                    } label: {
                        Image("ArrowRightSmall")
                    }
                }
                Spacer().frame(height: 16)
                
                GeometryReader { geometry in
                    let width = (geometry.size.width - 8 * 6) / 7
                    VStack {
                        HStack {
                            weekDayText(day: "Mon", width: width)
                            weekDayText(day: "Tue", width: width)
                            weekDayText(day: "Wed", width: width)
                            weekDayText(day: "Thu", width: width)
                            weekDayText(day: "Fri", width: width)
                            weekDayText(day: "Sat", width: width)
                            weekDayText(day: "Sun", width: width)
                        }
                        Spacer().frame(height: 12)
                        HStack(spacing: 8) {
                            ForEach(weekDates, id: \.self) { date in
                                let selected = datesEqual(date1: date, date2: selectedDate)
                                let backgroundColor = if(selected) {
                                    "Purple500"
                                } else {
                                    "Neutral100Neutral800"
                                }
                                let textColor = if(selected) {
                                    Color("Neutral50")
                                } else {
                                    Color("Neutral900Neutral50")
                                }
                                Button {
                                    selectedDate = date
                                } label: {
                                    ZStack {
                                        Text(dayOfMonthFormatterr.string(from: date))
                                            .b1Bold()
                                            .foregroundColor(textColor)
                                            .padding(.vertical,(geometry.size.width - 10 * 6) / 7 / 2)
                                    }
                                    .frame(width: (geometry.size.width - 8 * 6) / 7)
                                    .background(Color(backgroundColor))
                                    .cornerRadius(16)
                                }
                            }
                        }
                        Spacer().frame(height: 48)
                        Button() {
                            viewModel.updateTask(
                                name: textInput,
                                task: task,
                                priority: selectedTaskPriority,
                                date: selectedDate
                            )
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                                .b1Bold()
                                .padding(16)
                                .foregroundColor(Color("Neutral50"))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color("Purple500"))
                                .cornerRadius(16)
                        }
                        Spacer().frame(height: 16)
                        Button() {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .b1Bold()
                                .padding(16)
                                .foregroundColor(Color("Purple500"))
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .cornerRadius(16)
                        }
                        Spacer()
                    }
                    
                }.onAppear(perform: updateWeekDates)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal,16)
        }
        .navigationBarHidden(true)
        .onAppear {
            selectedDate = task.wrappedDate
            textInput = task.wrappedTitle
            selectedTaskPriority = TaskPriority(task.priority ?? "")
        }
    }
    
    private func weekDayText(day: String, width: CGFloat) -> some View {
        return Text(day)
            .b1Bold()
            .frame(width: width, alignment: .leading)
    }
    
    private func updateWeekDates() {
        weekDates = generateWeekDates(from: currentDate)
    }
    
    private func generateWeekDates(from date: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        // Find the most recent Monday
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        // Generate the week's dates
        for i in 0..<7 {
            if let weekDate = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(weekDate)
            }
        }
        return dates
    }
    
    struct Labelis {
        var labelis: TaskPriority
    }
    
    struct InputSection: View {
        @Binding var title: String
        
        var body: some View {
            TextField(
                text: $title,
                prompt: Text("Task name")
                    .font(.custom("InterTight-Regular",size: 16))
                    .foregroundColor(Color("Neutral500"))
            ){
                Text("Amogus")
                    .font(.custom("InterTight-Bold",size: 24))
                    .foregroundColor(Color("Purple300"))
            }
            .font(.custom("InterTight-Regular",size: 16))
            .foregroundColor(Color("InputTextColor"))
            .onSubmit {
                
            }
            .padding(16)
            .background(Color("InputFieldBackground"))
            .cornerRadius(16)
        }
    }
    
    struct Header: View {
        var onBackClick: () -> Void
        var onDeleteTaskClick: () -> Void
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        onBackClick()
                    } label: {
                        Image("ArrowBackTheme")
                    }
                    Spacer()
                    Button {
                        onDeleteTaskClick()
                    } label: {
                        Text("Delete task")
                            .b1Bold()
                            .foregroundColor(Color("Red"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 16)
                Text("Edit task")
                    .title()
            }
        }
    }
    
}

struct EditTaskScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        let task = PlannedTask(title: "Amogusas", context: PersistenceController.shared.container.viewContext)
        EditTaskScreen().environmentObject(task)
    }
}
