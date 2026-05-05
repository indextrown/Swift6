//
//  SwiftUIListView.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import SwiftUI

struct SwiftUIListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("텍스트필드") {
                    NavigationLink("기본 텍스트필드") {
                        
                    }
                }
                
                Section("버튼") {
                    NavigationLink("정렬 버튼") {
                        SortButtonView()
                    }
                    
                    NavigationLink("지역 버튼") {
                        RegionButtonView()
                    }
                }
                
                Section("시트") {
                    NavigationLink("커스텀 시트1") {
                        CustomSheetView()
                    }
                    
                    NavigationLink("커스텀 시트2") {
                        SizeView()
                    }
                    
                    NavigationLink("커스텀 시트3") {
                        DragglableView()
                    }
                    
                    NavigationLink("커스텀 시트4") {
                        SearchBar()
                    }
                }
                
                Section("GeometryReader") {
                    NavigationLink("GeometryReader") {
                        GeometryReaderView()
                    }
                    
                    NavigationLink("DynamicSheetHeightView") {
                        DynamicSheetHeightView()
                    }
                    
                    NavigationLink("무한스크롤") {
                        ScrollToTopView()
                    }
                }
                
                Section("지도") {
                    NavigationLink("MapView") {
                        MapView()
                    }
                }
                
                Section("로그") {
                    NavigationLink("LogView") {
                        LogView()
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIListView()
}
