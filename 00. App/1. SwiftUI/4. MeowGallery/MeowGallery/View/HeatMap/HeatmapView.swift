//
//  HeatmapView.swift
//  MeowGallery
//
//  Created by 김동현 on 3/24/25.
//

import SwiftUI

struct HeatmapData: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    var colorLevel: Int {
        switch count {
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 3...4: return 3
        default: return 4
        }
    }
}

struct HeatmapView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.fixed(20)), count: 16)
    let colors: [Color] = [
        Color.green.opacity(0.1),  // Level 0
        Color.green.opacity(0.3),  // Level 1
        Color.green.opacity(0.5),  // Level 2
        Color.green.opacity(0.7),  // Level 3
        Color.green.opacity(0.9)   // Level 4
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("활동 기록")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Array(repeating: .init(.fixed(20)), count: 7), spacing: 4) {
                    ForEach(profileViewModel.getHeatmapData()) { data in
                        Rectangle()
                            .fill(colors[data.colorLevel])
                            .frame(width: 20, height: 20)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .tooltip("\(formatDate(data.date))\n업로드: \(data.count)장")
                    }
                }
                .padding(.horizontal)
            }
            
            // 범례
            HStack(spacing: 16) {
                ForEach(0..<5) { level in
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(colors[level])
                            .frame(width: 16, height: 16)
                            .cornerRadius(4)
                        Text(legendText(for: level))
                            .font(.caption)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func legendText(for level: Int) -> String {
        switch level {
        case 0: return "0"
        case 1: return "1"
        case 2: return "2"
        case 3: return "3-4"
        case 4: return "5+"
        default: return ""
        }
    }
}

// 툴팁 수정자
struct TooltipModifier: ViewModifier {
    let tooltip: String
    @State private var isShowing = false
    
    func body(content: Content) -> some View {
        content
            .onHover { hovering in
                isShowing = hovering
            }
            .overlay(
                Group {
                    if isShowing {
                        Text(tooltip)
                            .padding(6)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .offset(y: -30)
                    }
                }
            )
    }
}

extension View {
    func tooltip(_ tooltip: String) -> some View {
        modifier(TooltipModifier(tooltip: tooltip))
    }
}

#Preview {
    HeatmapView(profileViewModel: ProfileViewModel())
}

/*
struct HeatmapView: View {
    
    // 전체 너비에서 패딩을 뺀 사용 가능한 너비 계산
    let columnsCount = 16
    let rowsCount = 7
    let spacing: CGFloat = 2
    let horizontalPadding: CGFloat = 30
    
    var body: some View {
        // 화면 너비를 UIScreen.main.bounds를 통해 가져옴
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - (horizontalPadding * 2)
        let totalSpacing = spacing * CGFloat(columnsCount - 1)
        let cellSize = (availableWidth - totalSpacing) / CGFloat(columnsCount)
        
        let columns: [GridItem] = Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columnsCount)
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<112, id: \.self) { _ in
                Rectangle()
                    .fill(.green)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 20)
    }
}
 */

//#Preview {
//    HeatmapView()
//}
