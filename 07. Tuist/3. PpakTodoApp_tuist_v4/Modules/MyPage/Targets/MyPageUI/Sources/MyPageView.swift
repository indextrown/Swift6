import SwiftUI

public struct MyPageView: View {
    public init() {}

    public var body: some View {
        Color.purple.opacity(0.7)
            .edgesIgnoringSafeArea(.all)
            .overlay(content: {
                Text("MyPageView")
                    .font(.system(size: 50, weight: .bold))
            })
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
