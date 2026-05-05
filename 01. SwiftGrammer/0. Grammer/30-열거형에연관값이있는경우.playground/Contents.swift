/*
 
 열거형에 연관값이 있는 경우
 */


enum Computer {
    case cpu(core: Int, ghz: Double)
    case ram(Int, String)
    case hardDisk(gb: Int)
}

var chip = Computer.cpu(core: 8, ghz: 3.1)


switch chip {                          // 수십가지로도 처리 가능 (필요한 처리 확장 가능)
case .cpu(core: 8, ghz: 3.1):
    print("CPU 8코어 3.1GHz입니다.")
case .cpu(core: 8, ghz: 2.6):
    print("CPU 8코어 2.6GHz입니다.")
case .cpu(core: 4, ghz: let ghz):       // let ghz = 연관값  (cpu가 4코어인 경우, ghz에 저장된 연관값을 꺼내서 바인딩)
    print("CPU 4코어 \(ghz)HGz입니다.")
case .cpu(core: _, ghz: _):
    print("CPU 칩 입니다.")
case .ram(32, _):
    print("32기가램 입니다.")
case .ram(_, _):
    print("램 입니다.")
case let .hardDisk(gb: gB):            // let gB = 연관값
    print("\(gB)기가 바이트 하드디스크 입니다.")
default:
    print("그 외에 나머지는 관심이 없습니다. 그렇지만 칩이긴 합니다.")
}
