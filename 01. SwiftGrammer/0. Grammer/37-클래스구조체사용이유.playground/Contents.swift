class Book {
    var name: String
    var price: Int
    var company: String
    var author: String
    var pages: Int
    
    init(n: String, p: Int, c: String, a: String, ps: Int) {
        self.name = n
        self.price = p
        self.company = c
        self.author = a
        self.pages = ps
    }
}


var book1 = Book(n: "스위프트", p: 30000, c: "애플", a: "잡스", ps: 300)
var book2 = Book(n: "소설", p: 10000, c: "잼컴퍼니", a: "웃긴녀석들", ps: 200)


class Movie {
    var name: String
    var jenre: String
    var actor: String
    var director: String
    var day: String
    
    init(name: String, jenre: String, actor: String, dirctor: String, day: String) {
        self.name = name
        self.jenre = jenre
        self.actor = actor
        self.director = dirctor
        self.day = day
    }
}
var movie1 = Movie(name: "영화이름", jenre: "코미디", actor: "Index", dirctor: "Index", day: "20210610")


