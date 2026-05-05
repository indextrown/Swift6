//
//  GeometryReaderView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 11/3/25.
//

import SwiftUI

struct GeometryReaderView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text("geometry 정보")
                    .font(.title)
                Text("size: ").bold() + Text("\(geo.size)")
                Text("frame: ").bold() + Text("\(geo.frame(in: .local).dictionaryRepresentation)")
                Text("safeAreaInsetsL ").bold() + Text("\(geo.safeAreaInsets)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .border(.blue, width: 3)
    }
}

#Preview {
    GeometryReaderView()
}
