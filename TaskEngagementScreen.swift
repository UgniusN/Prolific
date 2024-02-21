import Foundation
import SwiftUI

struct TaskEngagementScreen: View {
    
    var task: PlannedTask
    
    @ObservedObject
    private var viewModel = TaskEngagementViewModel()
    
    @EnvironmentObject var navigationVisibilityManager: NavigationVisibilityManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("Purple500")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 32)
                Text("Develop brand positioning")
                    .h2()
                    .foregroundColor(Color("Neutral50"))
                Spacer().frame(height: 8)
                Text("May 8, 2023")
                    .b2()
                    .foregroundColor(Color("Purple200"))
                Spacer().frame(height: 72)
                Text("07:32")
                    .h2()
                    .foregroundColor(Color("Neutral50"))
                Spacer().frame(height: 8)
                Text("Next: 5 minute break")
                    .b2()
                    .foregroundColor(Color("Purple200"))
                Spacer().frame(height: 24)
                Button {
                    viewModel.onCompleteClick(task: task)
                    navigationVisibilityManager.isCustomNavigationVisible = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    DoneButton()
                }
                Spacer()
                Button {
                    navigationVisibilityManager.isCustomNavigationVisible = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .b1Bold()
                        .foregroundColor(Color("Purple200"))
                }
                Spacer().frame(height: 36)
            }
            .navigationBarHidden(true)
            .onAppear {
                navigationVisibilityManager.isCustomNavigationVisible = false
            }
        }
    }
}

struct CompletedTaskView: View {
    
    var body: some View {
        VStack {
            Image("ImageThumbsUp")
        }
    }
}

struct DoneButton: View {
    var body: some View {
        HStack {
            Image("IconSuccess")
            Spacer(minLength: 8)
            Text("Done")
                .b1Bold()
                .foregroundColor(Color("Purple500"))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color("Neutral50"))
        .cornerRadius(16)
    }
}

struct SkipBreakButton: View {
    var body: some View {
        HStack {
            Text("Skip break")
                .b1Bold()
                .foregroundColor(Color("Purple500"))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color("Neutral50"))
        .cornerRadius(16)
    }
}

struct NiceButton: View {
    var body: some View {
        HStack {
            Text("Nice")
                .b1Bold()
                .foregroundColor(Color("Purple500"))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color("Neutral50"))
        .cornerRadius(16)
    }
}

struct TaskEngagement_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let task = PlannedTask(title: "Amogus", context: context)
        TaskEngagementScreen(task: task)
    }
}
