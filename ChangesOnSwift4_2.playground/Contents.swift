import UIKit

var str = "Hello, playground"

// SE-0195 Introduce User-defined "Dynamic Member Lookup" Types
// https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md
@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member : String) -> String {
        let properties = ["name" : "Taylor",
                          "city" : "Nashville"]
        return properties[member, default: ""]
    }
}

let person = Person()
let name = person.name
let city = person.city
let hoge = person.hoge

//struct Product {
//    subscript(dynamicMember member : String) -> Any {
//        let properties = ["name" : "Noodle",
//                          "price": 500]
//        return properties[member, default: ""]
//    }
//}
//
//let product = Product()
//let name = product.name
//let price = product.price

//struct Product {
//    subscript(dynamicMember member : String) -> String {
//        let properties = ["name" : "Noodle"]
//        return properties[member, default: ""]
//    }
//    subscript(dynamicMember member : String) -> Int {
//        let properties = ["price": 500]
//        return properties[member, default: 0]
//    }
//}
//
//let product = Product()
//let name = product.name
//let price = product.price

let randomInt = Int.random(in: 1...10)

