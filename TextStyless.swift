import Foundation
import SwiftUI

extension Text {
    func bold(size: CGFloat) -> some View {
        self.font(.custom("InterTight-Bold",size: size))
    }
    func light(size: CGFloat) -> some View {
        self.font(.custom("InterTight-Regular",size: size))
    }
    func title() -> some View {
        self.h1().foregroundColor(Color("ColorTitle"))
    }
    func h1() -> some View {
        self.bold(size: 32)
    }
    func h2() -> some View {
        self.bold(size: 24)
    }
    func b1Bold() -> some View {
        self.bold(size: 16)
    }
    func b1Regular() -> some View {
        self.light(size: 16)
    }
    func b2() -> some View {
        self.light(size: 14)
    }
    func b3() -> some View {
        self.light(size: 12)
    }
}

