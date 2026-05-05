//
//  VoiceRecorderViewModel.swift
//  VoiceMemo
//
//  Created by 김동현 on 1/8/25.
//

import AVFoundation

// MARK: - NSObject 채택하는 이유
/*
 ObservableObject - AudioRecordManager라는 서비스 객체를 만들어 이 객체를 뷰에 얹어서 사용하기 위함
 AVAudioPlayerDelegate - 음성메모를 위해 내장된 delegate메서드사용을 위함
 NSObject - 상속받는이유: AVAudioPlayerDelegate는 내부적으로 NSObject프로토콜을를 채택하고있다
            이 프로토콜은 Core Foundation 속성을 가진 타입이라 이 객체들이 실행되는 런타임 시에 런타임 메커니즘이 해당 프로토콜을 기반으로 동작한다
            avaudioplayerdelegate를 채택하여 객체를 구현하기 위해서는 NSObjectplayer프로토콜을 채택하거나 NSObject를 상속받아서 해당 avaudioplayerdelegate가 간접적으로
            이 런타임 메커니즘을 사용할 수 있게 만들 수 있다
 */
final class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isDisplayRemoveVoiceRecorderAlert: Bool  // 삭제시 나타나는 알림
    @Published var isDisplayAlert: Bool                // 파일을 가져오거나 녹음 실패시 알림
    @Published var alertMessage: String                // 에러시 문자열
    
    // MARK: - 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    // MARK: - 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval // 얼마나 플레이 되었는지
    private var progressTimer: Timer?
    
    // MARK: - 음성메모된 파일
    var recordedFiles: [URL]
    
    // MARK: - 현재 선택된 음성메모 파일
    @Published var selectedRecordFile: URL?
    
    init(
        isDisplayRemoveVoiceRecorderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecordFile: URL? = nil
    ) {
        self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
        self.isDisplayAlert = isDisplayErrorAlert
        self.alertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecordFile = selectedRecordFile
    }
}

// MARK: - 음성메모 뷰에서 일어날 수 있는 로직
extension VoiceRecorderViewModel {
    // 레코드 셀을 눌렀을때 어떤 녹음파일인지 선택
    func voiceRecordCellTapped(_ recordedFile: URL) {
        if selectedRecordFile == recordedFile {
            // 동일한 파일을 다시 터치하면 선택 해제 및 재생 정지
            stopPlaying()
            selectedRecordFile = nil
        } else {
            // 다른 파일을 선택하면 기존 파일의 재생을 정지하고 새 파일 선택
            stopPlaying()
            selectedRecordFile = recordedFile
        }
    }
    
    /*
    MARK: 문제점: 기존걸 터치하면 다시 안작아짐
    func voiceRecordCellTapped(_ recordedFile: URL) {
        // 만약 현재 선택되어있는 셀이 아니라면 재생을 멈춰야함
        if selectedRecordFile != recordedFile {
            // MARK: - 재생정지 메서드 호출
            stopPlaying()
            selectedRecordFile = recordedFile
        }
    }
     */
    
    // 삭제 버튼 누를 때
    func removeBtnTapped() {
        // TODO: - 삭제 얼럿 노출을 위한 상태 변경 메서드 호출
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    // 삭제 버튼 눌러서 나오는 얼럿에서 삭제를 누를 때 나오는 호출
    func removeSelectedVoiceRecord() {
        // selectedRecordFile이 nil이 아니어야 하고 (let fileToRemove로 언래핑 성공)
        // recordedFiles.firstIndex(of: fileToRemove)이 nil이 아니어야 함 (let indexToRemove로 언래핑 성공)
        guard let fileToRemove = selectedRecordFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            // MARK: - 선택된 음성메모를 찾을 수 없다는 에러 노출
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordFile = nil
            
            // MARK: - 재생 정지 메서드 호출
            stopPlaying()
            
            // MARK: - 삭제 성공 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭재했습니다.")
           
        } catch {
            // MARK: - 삭제 실패 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    // 얼럿 노출 상태값을 위함
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecorderAlert = isDisplay
    }
    
    // 에러 얼럿 메시지 설정
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    // 에러 얼럿 설정
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    // 에러 얼럿 메시지를 담아주고 띄어주는 메서드로 통함
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
    func recordBtnTapped() {
        // 현재 선택된 레코더 파일을 nil로 바꿔즌다(이유: 다시 재생을 하기위해 선택된게 없게 하기 위해)
        selectedRecordFile = nil
        
        if isPlaying {
            // MARK: - 재생 정지 메서드 호출
            stopPlaying()
            // MARK: - 재생 시작 메서드 호출
            startRecording()
        } else if isRecording {
            // MARK: - 녹음 정지 메서드 호출
            stopRecording()
        } else {
            // MARK: - 녹음 시작 메서드 호출
            startRecording()
        }
    }
    
    // 녹음 시작
    private func startRecording() {
        let fileURL = getDocumentDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count+1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    // 녹음 중지
    private func stopRecording() {
        audioRecorder?.stop()
        self.recordedFiles.append(self.audioRecorder!.url)
        self.isRecording = false
    }
    
    // 문서 디렉토리 가져오는 메서드
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            // AVAudioPlayer 초기화
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            // 상태 업데이트
            self.isPlaying = true
            self.isPaused = false
            
            // 프로그레스 타이머 설정
            self.progressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                // MARK: - 현재 시간 업데이트 메서드 호출
                self.updateCurrentTime()
            }
        } catch {
            displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    // 현재 시간 업데이트
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    // 중지
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    // 일시 정지
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    // 일시 정지에서 재개
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    // 잘끝났는지 확인
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    // 파일 정보를 시간과 타임 인터벌로 반환해서 가져오는 메서드
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?

        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
        }

        return (creationDate, duration)
    }
}









