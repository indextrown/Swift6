/*
 (3주차 실시간 강의)
 copy-on-write 최적화
 - 코드상에서 값을 복사해서 담는다 하더라도, 실제 값이 바뀌기 전까지는 그냥 하나의 메모리 값을 공유해서 사용
 - 유동적이지만 힙이라는 데이터애 저장해서 쓸 수 있다
 - swift는 특이하게 stack영역에서 공유가 안되도록 해놓았다->개속 복사가 된다
 
 */


//let memberData = [Member] = [
//    Member...
//]

// 메모리 공유하는게 아니라 메모리를 복사해서 담는다: swift배열, 딕셔너리 세트, 문자열... --> 구조체로 구현됨
// 새로운 메모리 공간을 만들고 새로운 데이터가 존재하는것임
// 메모리가 낭비될 가능성 존재
// 여기서 swift특성상 copy-on-write로 내부적으로 복사가 아니라 메모리를 공유해서 쓴다
// 데이터 값이 바뀌거나 따로 작업이 필요할 떄 복사가 이루어진다
//var newArray = memberData




/*
 시간복잡도의 개념
 어떤 입력값이 주어졌을 때, 문제를 해결하는 데 걸리는 시간과의 상관관계.
 즉, 만약에 입력값이 2배로 주어진다면, 문제를 해결하는 데 걸리는 시간은 몇 배로 늘어나는지에 판단해 보는 것.
 결국, 입력값이 늘어나도.. 걸리는 시간이 덜 늘어나는... 알고리즘이 효율적이다.
 
 
 1) 빅 오메가(Big-Ω) 표기법 - 최선의 성능이 나올 때 어느 정도의 연산량이 걸릴것인지 표시
 2) 빅 오(Big-O)표기법 - 최악의 성능이 나올 때 어느 정도의 연산량이 걸릴것인지 표시

 점근 표기법의 종류
 (예시)
 빅 오메가 표기법으로 표시하면 $Ω(1)$의 시간복잡도를 가진 알고리즘 임! ---> 필요 x
 빅 오 표기법으로 표시하면 $O(N)$의 시간복잡도를 가진 알고리즘 임!
 
 알고리즘에서 분석의 관심부분은 결국, 최악의 경우에 어느정도의 시간이 걸릴지를 따지는 것이므로  빅 오(Big-O) 표기법의 개념만 알면 됨 ⭐️

 그리고 CS에서 시간복잡도의 상수는 관심 대상이 아니므로,
 일반적으로 $O(1)$ 인지,  $O(N)$ 인지, $O(N^2)$ 인지만 따져봄
 */

var array = [4, 7, 2, 1, 8, 3, 0]

// 1번 방식    2N + 1 ==> 2N
func findMaxNumInArray(_ array: [Int]) -> Int {
    var maxNum = array[0]       // 1번의 대입 연산(cpu가 한번 일을 한다)
    
    for num in array {          // 배열의 길이(N)만큼의 아래의 연산 실행
        if num > maxNum {       // 1번의 비교 연산
            maxNum = num        // 1번의 대입 연산
        }
    }
    return maxNum
}
print(findMaxNumInArray(array))



// 2번방식 1 + N * N * 3 ==> 3N^2 + 1 ==> 3N
func findMaxNumInArray2(_ array: [Int]) -> Int {
    var maxNum = array[0]       // 1번의 대입 연산
    
    for num in array {          // 배열의 길이(N)만큼의 아래의 연산 실행
        for otherNum in array { // 배열의 길이(N)만큼의 아래의 연산 실행
            if num < otherNum && maxNum < otherNum {    // 2번의 비교 연산
                maxNum = otherNum                       // 1번의 대입 연산
            }
        }
    }
    return maxNum
}
print(findMaxNumInArray2(array))


// https://developer.apple.com/documentation/swift/array/sorted(by:)
// 3번방식 (1번이 더 효율적임) // 판단조건: 배열이 길 때 언제 빨리 끝나냐
func findMaxNumInArray3(_ array: [Int]) -> Int {
    var lastNum = array.sorted().last!  // timsort ==> nlogn
    return lastNum
}
