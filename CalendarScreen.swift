import Foundation
import SwiftUI

struct CalendarScreen: View {
    
    @ObservedObject
    private var viewModel = CalendarViewModel()
    
    @FetchRequest(fetchRequest: PlannedTask.all()) private var plannedTasks
    
    @State private var currentDate = Date()
    @State private var weekDates: [Date] = []
    @State private var selectedDate = Date.now
    @State private var scrollToItemId: UUID?
    @State private var isUserInteractionEnabled = true
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: HorizontalAlignment.leading) {
                            Spacer().frame(height: 24)
                            Text("Calendar")
                                .title()
                            Spacer().frame(height: 24)
                            HStack {
                                VStack {
                                    Text(viewModel.selectedDate.formatted(.dateTime.month().year()))
                                        .h2()
                                        .foregroundColor(Color("ColorTitle"))
                                        .id(viewModel.dates)
                                        .transition(.opacity.animation(.linear))
                                }
                                Spacer()
                                Button {
                                    viewModel.onPreviousMonthClick()
                                } label: {
                                    Image("ArrowLeftSmall")
                                }
                                Spacer().frame(width: 12)
                                Button {
                                    viewModel.onNextMonthClick()
                                } label: {
                                    Image("ArrowRightSmall")
                                }
                            }
                            Spacer().frame(height: 24)
                            
                            let paddingVertical = (geometry.size.width - 10 * 6) / 7 / 2
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.dates, id: \.self) { column in
                                    HStack(spacing: 8) {
                                        ForEach(column, id: \.self) { row in
                                            let selected = datesEqual(date1: row.date, date2: selectedDate)
                                            
                                            let bgColor = if(selected) {
                                                Color("Purple500")
                                            } else if(datesEqual(date1: currentDate, date2: row.date)) {
                                                Color("Purple200Purple700")
                                            } else {
                                                Color("Neutral100Neutral800")
                                            }
                                            
                                            let textColor = if(selected) {
                                                Color("Neutral50")
                                            } else {
                                                Color("Neutral900Neutral50")
                                            }
                                            Button {
                                                withAnimation {
                                                    selectedDate = row.date
                                                }
                                            } label: {
                                                ZStack(alignment: .bottom) {
                                                    Text("\(row.day)")
                                                        .b1Bold()
                                                        .foregroundColor(textColor)
                                                        .padding(.vertical,paddingVertical)
                                                    if(hasTasks(date: row.date)) {
                                                        let capsuleColor = if(selectedDate == row.date) {
                                                          Color("Purple500")
                                                        } else if(datesEqual(date1: Date(), date2: row.date)) {
                                                            Color("Purple500")
                                                        } else if(!isDateLaterThanToday(row.date)) {
                                                            Color("Purple200")
                                                        } else {
                                                            Color("Purple500")
                                                        }
                                                        VStack {
                                                            Capsule()
                                                                .frame(width: 20, height: 4)
                                                                .foregroundColor(capsuleColor)
                                                            Spacer().frame(height: 8)
                                                        }
                                                    }
                                                }
                                                .frame(width: (geometry.size.width - 8 * 6) / 7)
                                                .background(bgColor)
                                                .cornerRadius(16)
                                            }
                                        }
                                    }
                                }
                                .id(viewModel.dates)
                                .transition(.opacity.animation(.linear))
                            }
                            Spacer().frame(height: 32)
                            Text("Your tasks").h2()
                            let filteredEntities = plannedTasks.filter { task in
                                guard let date = task.date else {
                                    return false
                                }
                                return datesEqual(date1: date, date2: selectedDate)
                            }
                            
                            VStack(spacing: 16) {
                                ForEach(filteredEntities, id: \.self) { task in
                                    Task(task: task)  .id(task.task_id)
                                }.onChange(of: selectedDate) { _ in
                                    // Ensure we allow a slight delay after scrolling to stabilize the UI
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjusted delay
                                        withAnimation(.easeInOut) {
                                            if let firstTaskId = filteredEntities.first?.task_id {
                                                scrollView.scrollTo(firstTaskId, anchor: .top)
                                                isUserInteractionEnabled = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Re-enable interaction after delay
                                                    isUserInteractionEnabled = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Spacer(minLength: 42)
                        }
                    }
                }
            }
        }.sidesPadding()
    }
    
    func hasTasks(date: Date) -> Bool  {
        return plannedTasks.contains { task in
            datesEqual(date1: task.wrappedDate, date2: date)
        }
    }
    
    func isDateLaterThanToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        // Compare the given date to today, considering only year, month, and day components
        let comparisonResult = calendar.compare(date, to: today, toGranularity: .day)
        
        // Return true if the given date is later than today
        return comparisonResult == .orderedDescending
    }
}

struct CalendarScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScreen()
    }
}
