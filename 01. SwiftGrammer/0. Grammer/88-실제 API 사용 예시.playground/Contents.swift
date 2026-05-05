import UIKit

// 실제 API에서 중첩 타입을 사용하는 경우
// DataFormatter: swift에서 날짜를 다룰때 관련 형식을 변환하는것과 관련
let fomatter = DateFormatter()

// dateStype변수의 타입 확인해보기
fomatter.dateStyle = .full// .열거형타입이겠구나
fomatter.dateStyle = DateFormatter.Style.none

/**==========================================================
 - var dateStyle: Style { get set }                 (타입확인)
 - var dateStyle: DateFormatter.Style { get set }   (내부정의)
============================================================**/


struct K {
    // 타입 저장속성(데이터 영역)
    static let appName = "MySuperApp"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

// 문자열 대신에 아래처럼 사용할 수 있음 ⭐️ (문자열 실수는 치명적인 에러를 발생시킴)
let app = K.appName      // "MySuperApp"
let color = K.BrandColors.blue    // "BrandLightBlue"


// 어떤 메신저에서 메세지를 모델로 설계한다면
// 가정 1) 보낸 사람, 2) 받는 사람 3) 메세지 보낸 시간 4)

class Message {
    // 상태를 중첩타입으로 (외부에서 접근못하게 하려면, private으로 선언가능)
    private enum Status {
        case sent
        case received
        case read
    }
    
    // 보낸 사람, 받는 사람
    let sender: String, recipient: String, content: String
    
    // 보낸 시간
    let timeStamp: Date
    
    // 메세지 상태 정보 (보냄/받음/읽음)
    private var status: Message.Status = Message.Status.sent
    
    init(sender: String, recipient: String, content: String) {
        self.sender = sender
        self.recipient = recipient
        self.content = content
        
        self.timeStamp = Date()   // 현재시간 생성 ===> 시간은 유저가 주는 정보 아님
    }
    
    func getBasicInfo() -> String {
        return "보낸사람: \(sender), 받는사람: \(recipient), 메세지 내용: \(content), 보낸 시간: \(timeStamp.description), "
    }
    
    // 메세지 상태에 따라서, 색깔 바뀜
    func statusColor() -> UIColor {
        switch status {
        case .sent:
            return UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        case .received:
            return UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        case .read:
            return UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        }
    }
}


let message1 = Message(sender: "홍길동", recipient: "임꺽정", content: "뭐해?")
print(message1.getBasicInfo())

sleep(1)

let message2 = Message(sender: "임꺽정", recipient: "홍길동", content: "그냥있어")
print(message2.getBasicInfo())


