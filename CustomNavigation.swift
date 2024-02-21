import Foundation
import SwiftUI

struct CustomNavigation: View {
    @Binding var tabSelection: Int
    
    let tabItems = [
        NavigationIcon(iconName: "NavHomeIcon"),
        NavigationIcon(iconName: "NavAnalysisIcon"),
        NavigationIcon(iconName: "NavCalendarIcon"),
        NavigationIcon(iconName: "NavProjectIcon"),
        NavigationIcon(iconName: "NavProfileIcon")
    ]
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(0..<5) { index in
                Button {
                    tabSelection = index + 1
                } label: {
                    VStack() {
                        let icon = tabItems[index].getIcon(selected: index == tabSelection - 1)
                        Image(icon)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 72)
        .background(Color("NavbarColor"))
    }
    
}

struct NavigationIcon {
    let iconName: String
    
    init(iconName: String) {
        self.iconName = iconName
    }
    
    func getIcon(selected: Bool) -> String {
        return if(!selected) {
            iconName
        }
        else{
            iconName + "Selected"
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigation(tabSelection: .constant(1))
            .previewLayout(.sizeThatFits)
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
