import Foundation
import SwiftUI

struct SingleLabel: View {
    
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
        
        let backgroundColor = switch taskPriority {
        case .low: "ColorGreen"
        case .medium: "ColorYellow"
        case .high: "Red"
        }
        
        Text(title)
            .b3()
            .foregroundColor(Color("Neutral900"))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(backgroundColor))
            .cornerRadius(8)
            .frame(height: 32)
    }
}
