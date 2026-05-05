//
//  VoiceRecorderView.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/8/25.
//

import SwiftUI

struct VoiceRecorderView: View {
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
         ZStack {
             VStack {
                // 타이틀뷰
                TitleView()

                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    // 안내뷰
                    AnnouncementView()
                } else {
                    // 보이스 레코더 리스트 뷰
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
                  
                 Spacer()

                 // 녹음버튼 뷰
                 RecordBtnView(voiceRecorderViewModel: voiceRecorderViewModel)
                     .padding(.trailing, 20)
                     .padding(.bottom, 50)
             }
        }
         .alert(
            "선택된 음성메모를 삭제하시겠습니까?", isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
         ) {
             Button("삭제", role: .destructive) {
                 voiceRecorderViewModel.removeSelectedVoiceRecord()
             }
             Button("취소", role: .cancel) {}
         }
         .alert(
            voiceRecorderViewModel.alertMessage,
            isPresented: $voiceRecorderViewModel.isDisplayAlert
         ) {
             Button("확인", role: .cancel) {}
         }
        // todos 추가되거나 삭제될때마다 반응
        .onChange(of: voiceRecorderViewModel.recordedFiles) { oldValue, newRecordedFiles in
            homeViewModel.voiceRecorderCount(newRecordedFiles.count)
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.customBlack)
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

// MARK: - 음성메모 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            
            // MARK: - 구분선 자체도 컴포넌트로 만들어도됨
            DividerView()
            /*
            Rectangle()
                .fill(Color.customCoolGray)
                .frame(height: 1)
             */
            
            Spacer()
                .frame(height: 180)
            
            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다")
            Text("하단의 녹음 버튼을 눌러 음성메모를 시작해주세요.")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 음성메모 리스트 뷰
private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.customGray2)
                    .frame(height: 1)
                
                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordefFile in
                    // 음성메모 셀 뷰 호출
                    VoiceRecorderCellView(voiceRecorderViewModel: voiceRecorderViewModel, recordedFile: recordefFile)
                }
            }
        }
    }
}

// MARK: - 음성메모 셀 뷰
private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL           // 녹음된 파일 URL 가져오기
    private var creationDate: Date?         // 생성날짜
    private var duration: TimeInterval?
    private var progressBarValue: Float {   // 상태바 상태
        // 선택한 파일과 지금 레코드 파일이 같으면서 (시작중이거나 일시정지) 상태이면
        if voiceRecorderViewModel.selectedRecordFile == recordedFile && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
                }
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.customBlack)
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordFile != recordedFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconGray)
                         }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            
            // MARK: - 확장된 UI를 조건부로 표시
            if voiceRecorderViewModel.selectedRecordFile == recordedFile {
                VStack {
                    // 프로그래스바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        } label: {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceRecorderViewModel.removeBtnTapped()
                        } label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.customBlack)
                        }
                    }
                }
                .padding(.horizontal, 20)
                // 부드러운 전환
                // 위에서 아래로 내려오는 동시에 페이드 효과를 추가
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        
            
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
    }
}

private struct VoiceRecorderCellView_save: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL           // 녹음된 파일 URL 가져오기
    private var creationDate: Date?         // 생성날짜
    private var duration: TimeInterval?
    private var progressBarValue: Float {   // 상태바 상태
        // 선택한 파일과 지금 레코드 파일이 같으면서 (시작중이거나 일시정지) 상태이면
        if voiceRecorderViewModel.selectedRecordFile == recordedFile && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.customBlack)
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate = creationDate {
                            Text(creationDate.formattedVoiceRecorderTime)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordFile != recordedFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundColor(.customIconGray)
                         }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // MARK: - 확장된 UI를 조건부로 표시
            if voiceRecorderViewModel.selectedRecordFile == recordedFile {
                VStack {
                    // 프로그래스바
                    ProgressBar(progress: progressBarValue)
                        .frame(height: 2)
                    // 부드러운 전환 애니메이션 추가
                    // 뷰가 나타나거나 사라질 때 슬라이드 및 페이드 효과
                        //.transition(.opacity.combined(with: .slide))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.customIconGray)
                        
                        Spacer()
                        
                        if let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        } label: {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundColor(.customBlack)
                        }
                        
                        Spacer()
                        
                        Button {
                            voiceRecorderViewModel.removeBtnTapped()
                        } label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.customBlack)
                        }
                    }
                }
                .padding(.horizontal, 20)
                // .transition(.move(edge: .top).combined(with: .opacity))
                //.animation(.easeInOut(duration: 0.3), value: voiceRecorderViewModel.selectedRecordFile)
            }
        
            
            Rectangle()
                .fill(Color.customGray2)
                .frame(height: 1)
        }
        // 선택된 파일의 상태 변경에 대해 애니메이션 효과를 추가
        //.animation(.easeInOut(duration: 0.3), value: voiceRecorderViewModel.selectedRecordFile) // 애니메이션 적용
    }
}

// MARK: - 프로그래스 바
private struct ProgressBar: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.customGray2)
                Rectangle()
                    .fill(Color.customGreen)
                    .frame(width: CGFloat(self.progress) * geometry.size.width)
            }
        }
    }
}

// MARK: - 녹음 버튼 뷰
private struct RecordBtnView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    @State private var isAnimation: Bool
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        isAnimation: Bool = false
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.isAnimation = isAnimation
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                
                Spacer()
                
                
                Button {
                    voiceRecorderViewModel.recordBtnTapped()
                } label: {
                    if voiceRecorderViewModel.isRecording {
                        Image("mic_recording")
                            .scaleEffect(isAnimation ? 1.5 : 1)
                            .onAppear {
                                withAnimation(.spring().repeatForever()) {
                                    isAnimation.toggle()
                                }
                            }
                            .onDisappear {
                                isAnimation = false
                            }
                    } else {
                        Image("mic")
                    }
                }
            }
        }
    }
}

// MARK: - 구분선 컴포넌트
struct DividerView: View {
    var color: Color = .customCoolGray
    var height: CGFloat = 1

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}

#Preview {
     VoiceRecorderView()
}
