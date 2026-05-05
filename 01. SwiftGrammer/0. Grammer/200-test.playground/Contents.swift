import UIKit

struct Rectangle: Equatable {
    var width: Double
    var height: Double
    
    static func ==(lhs: Rectangle, rhs: Rectangle) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

let rectangle1 = Rectangle(width: 5.0, height: 10.0)
let rectangle2 = Rectangle(width: 5.0, height: 10.0)
let rectangle3 = Rectangle(width: 7.0, height: 8.0)

//print(rectangle1 == rectangle2)
//print(rectangle1 != rectangle3)


struct Product: Comparable {
    let name: String
    let price: Double
    
    static func < (lhs: Product, rhs: Product) -> Bool {
        return lhs.price < rhs.price
    }
}

func findCheaperProduct(_ product1: Product, _ product2: Product) -> Product {
    if product1 < product2 {
        return product1
    }
    return product2
}

let product1 = Product(name: "제품 1", price: 10.99)
let product2 = Product(name: "제품 2", price: 8.99)
let cheaperProduct = findCheaperProduct(product1, product2)
print("더 저렴한 제품: \(cheaperProduct.name), 가격: \(cheaperProduct.price)")

