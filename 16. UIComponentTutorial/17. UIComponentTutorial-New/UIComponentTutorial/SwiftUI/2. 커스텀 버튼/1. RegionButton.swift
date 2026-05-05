//
//  RegionButton.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/27/25.
//

import SwiftUI

struct RegionButtonView: View {
    @StateObject private var viewModel = RegionViewModel()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            RegionButton(text: viewModel.selectedRegion?.region ?? "지역") {
                showSheet.toggle()
            }
        }
        .sheet(isPresented: $showSheet) {
            RegionSheet(viewModel: viewModel)
                .presentationDetents([.medium])
        }
    }
}

// MARK: - DTO
struct RegionListDTO: Decodable, Hashable {
    let region: String
    let districts: [String]
    
    func toModel() -> RegionList{
        return RegionList(region: region, districts: districts)
    }
}

// MARK: - Entity
struct RegionList: Identifiable, Hashable {
    var id: String { region }
    let region: String
    let districts: [String]
}

// MARK: - Button
struct RegionButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text(text)
                    .foregroundStyle(.primary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        
    }
}

// MARK: - Sheet
struct RegionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RegionViewModel
    
    let backFont: Font = .system(size: 17, weight: .bold)
    let titlefont: Font = .system(size: 24, weight: .medium)
    let buttonFont: Font = .system(size: 21, weight: .regular)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("지역")
                    .font(titlefont)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                        .font(backFont)
                }
            }
            
            HStack(spacing: 0) {
                // 좌측: 지역 목록
                List(viewModel.regions) { region in
                    Button {
                        viewModel.selectedRegion = region
                        viewModel.selectedDistrict = region.districts.first
                    } label: {
                        HStack {
                            Text(region.region)
                                .foregroundStyle(viewModel.selectedRegion == region ? .blue : .primary)
                                .font(buttonFont)
                            Spacer()
                        }
                    }
                    .listRowBackground(viewModel.selectedRegion == region ? Color.gray : Color.clear)
                }
                .frame(width: 120)
                .listStyle(.plain)
                
                Divider()
                
                // 우측: 구 목록
                if let selected = viewModel.selectedRegion {
                    List(selected.districts, id: \.self) { district in
                        Button {
                            viewModel.selectedDistrict = district
                            dismiss()
                        } label: {
                            Text(district)
                                .foregroundStyle(viewModel.selectedDistrict == district ? .blue : .primary)
                                .font(buttonFont)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.top, 30)
        }
        .padding(.top, 20)
        .padding(.horizontal, 15)
        .presentationDragIndicator(.visible)
    }
}

#Preview {
//    RegionButton(text: "지역") {
//         
//    }
    
//     RegionSheet(viewModel: RegionViewModel())
    
    RegionButtonView()
}


final class RegionViewModel: ObservableObject {
    @Published var regions: [RegionList] = []
    @Published var selectedRegion: RegionList?
    @Published var selectedDistrict: String?
    
    init() {
        Task {
            await fetchRegions()
        }
    }
    
    func fetchRegions() async {
        // ⏳ 네트워크 대신 목업 데이터 (비동기 시뮬레이션)
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 지연
        
        let mockData: [RegionListDTO] = [
            RegionListDTO(region: "서울", districts: ["전체", "강남구", "성동구", "송파구", "종로구"]),
            RegionListDTO(region: "부산", districts: ["전체"]),
            RegionListDTO(region: "인천", districts: ["전체"]),
            RegionListDTO(region: "경기", districts: ["전체"])
        ]
        
        let mapped = mockData.map { $0.toModel() }
        
        await MainActor.run {
            self.regions = mapped
            if let first = mapped.first {
                self.selectedRegion = first
                self.selectedDistrict = first.districts.first
            }
        }
    }
}
