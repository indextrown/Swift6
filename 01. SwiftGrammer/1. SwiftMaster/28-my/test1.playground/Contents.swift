//import UIKit
//
//var num = 10
//
//switch num {
//case 0..<5:
//    print("0에서 4사이")
//case 5..<10:
//    print("5에서 9사이")
//default:
//    break
//}
//
//
//// 가위 = 0   바위 = 1   보 = 2
//
//var randomNum = Int.random(in: 0...2)
//var myChoice = 0
//
//switch randomNum {
//case 0:
//    print("컴퓨터의 선택은 가위 입니다. ")
//case 1:
//    print("컴퓨터의 선택은 바위 입니다. ")
//case 2:
//    print("컴퓨터의 선택은 보 입니다. ")
//default:
//    break
//}
//
//switch myChoice {
//case 0:
//    print("당신의 선택은 가위 입니다. ")
//case 1:
//    print("당신의 선택은 바위 입니다. ")
//case 2:
//    print("당신의 선택은 보 입니다. ")
//default:
//    break
//}
//
//
//if (myChoice == 0) {            // 내가 가위를 선택한 경우
//    if (randomNum == 0) {
//        print("무승부 입니다. ")
//    }
//    else if (randomNum == 1) {
//        print("당신은 졌습니다. ")
//    }
//    else {
//        print("당신은 이겼습니다. ")
//    }
//} else if (myChoice == 1) {     // 내가 바위를 선택한 경우
//    if (randomNum == 0) {
//        print("당신은 이겼습니다. ")
//    } else if (randomNum == 1) {
//        print("무승부 입니다. ")
//    } else {
//        print("당신은 졌습니다. ")
//    }
//} else {                        // 내가 보를 선택한 경우
//    if (randomNum == 0) {
//        print("당신은 졌습니다. ")
//    } else if (randomNum == 1) {
//        print("당신은 이겼습니다. ")
//    } else {
//        print("무승부 입니다. ")
//    }
//}
// 
//
//var myPick = 5
//var randomBingo = Int.random(in: 1...10)
//
//if myPick > randomBingo {
//    print("Down")
//} else if myPick < randomBingo {
//    print("Up")
//} else {
//    print("Bingo")
////}
