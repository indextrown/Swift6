/*
 
 (196강)
 문자열의 기본 다루기
 
 
 */

let singleLineString = "There are \nthe same."
print(singleLineString)




/**===========================================================
 - 문자열을 여러줄 입력하고 싶을때
 - 1) """ (쌍따옴표 3개를 연속으로 붙여서 입력) - 첫째줄/마지막줄에 입력
 - 2) 해당줄에는 문자열 입력 불가
 - 3) 문자열 내부에서 쓰여진대로 줄바꿈됨. ===> (줄바꿈 하지 않으려면 \(백슬레시) 입력)
 - 4) 특수문자는 문자 그대로 입력됨
 - 5) 마지막(""")는 들여쓰기의 기준의 역할
=============================================================**/


let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
print(quotation)



/**==============================
 [Escape character sequences]
 - \0  (null문자)
 - \\  (백슬레시)
 - \t  (탭)
 - \n  (줄바꿈 - 개행문자)
 - \r  (캐리지 리턴 - 앞줄이동)
 - \"  (쌍따옴표)
 - \'  (작은따옴표)
 - \u{유니코드값}   (1~8자리의 16진수)
=================================**/

let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
print(wiseWords)

// 샵의 갯수를 개발자 임의로 조절 가능


var name = #"Steve"#
print(name)
