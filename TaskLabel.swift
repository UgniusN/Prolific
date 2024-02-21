import Foundation
import SwiftUI

struct TaskLabelSelectable: View {
    
    var taskPriority: TaskPriority
    @Binding var selectedLabel: TaskPriority
    
    var body: some View {
        let selected = taskPriority == selectedLabel
        
        let title = switch taskPriority {
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
        let color = switch taskPriority {
        case .low:
            "ColorGreen"
        case .medium:
            "ColorYellow"
        case .high:
            "Red"
        }
        let backgroundColor = if(selected) {
            color
        } else {
            "ColorUnselectedLabel"
        }
        let titleColor = if(selected) {
            "Neutral900"
        } else {
            "Neutral500"
        }
        
        Text(title)
            .b1Regular()
            .foregroundColor(Color(titleColor))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(backgroundColor))
            .cornerRadius(8)
            .frame(height: 32)
    }
}

struct TaskLabel: View {
    
    var taskPriority: TaskPriority
    
    var body: some View {

        
        let title = switch taskPriority {
        case .low:
            "Low"
        case .medium:
            "Medium"
        case .high:
            "High"
        }
        let color = switch taskPriority {
        case .low:
            "ColorGreen"
        case .medium:
            "ColorYellow"
        case .high:
            "Red"
        }
        let backgroundColor = color
        Text(title)
            .b3()
            .foregroundColor(Color("Neutral900"))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(color))
            .cornerRadius(8)
            .frame(height: 32)
    }
}

enum TaskPriority: String, Identifiable {
    
    var id: Self {
        return self
    }
    
    init(_ str: String) { self = TaskPriority(rawValue: str) ?? .low}
    case low = "low"
    case medium = "medium"
    case high = "high"
}
