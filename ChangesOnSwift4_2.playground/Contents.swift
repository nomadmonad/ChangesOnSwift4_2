import UIKit

// Generics improvements

// SE-0143 Conditional conformances
// ある条件を満たす時、GenericsにもProtocolを適用できるように変更
protocol P {
    func doSomething()
}

struct S: P {
    func doSomething() { print("this is S") }
}

// Arrayの要素がPに適合するものなら、このメソッドが実行可能になる
extension Array: P where Element: P {
    func doSomething() {
        for value in self {
            value.doSomething()
        }
    }
}
let pAry = [S(), S()]
pAry.doSomething()

let numAry = [1, 2]
// numAry.doSomething() は候補にも出てこない

// Dynamically query and use conformance to P.
func doSomethingIfP(_ value: Any) {
    if let p = value as? P {
        p.doSomething()
    } else {
        print("Not a P")
    }
}

doSomethingIfP([S(), S(), S()]) // prints "S" three times
doSomethingIfP([1, 2, 3])       // prints "Not a P"

// Standard Library updates

// SE-0197 Adding in-place removeAll(where:) to the Standard Library
// 配列中の特定の要素を削除する場合、破壊的に操作できるようになった
var nums = [1, 2, 3, 4, 5]
// remove odd elements
let filtered = nums.filter { $0 % 2 == 0 }
print(nums)
print(filtered)

nums.removeAll { $0 % 2 != 0 }
print(nums)

// SE-0202 Random Unification
// IntやCollectionなどの型にrandom()を呼び出せるよう変更
// これまではこういう書き方を強いられていた
// #if !os(Linux)
// return Int(arc4random()) // This is inefficient as it doesn't utilize all of Int's range
// #else
// return random() // or Int(rand())
// #endif
let randomInt = Int.random(in: 1...10)

// SE-0199 Adding toggle to Bool
// こう書かなくて済む
// boolValue = !boolValue
var boolValue = true
boolValue.toggle()

// SE-0204 Add last(where:) and lastIndex(where:) Methods
// Swift 4.1以前では、reverse iteratorを使わないと最後に出現するものindexを調べられなかった
// こんな感じ a.reversed().index(where: { $0 > 25 })?.base).map({ a.index(before: $0) }
let a = [20, 30, 10, 40, 20, 30, 10, 40, 20]
a.first(where: { $0 > 25 })         // 30
a.index(where: { $0 > 25 })         // 1
a.index(of: 10)                     // 2

a.last(where: { $0 > 25 })          // 40
a.lastIndex(where: { $0 > 25 })     // 7
a.lastIndex(of: 10)                 // 6

// Additional language and compiler updates

// SE-0194 Derived Collection of Enum Cases
enum SmartPhones: CaseIterable { case iPhone, pixel, experia, essential }
let sps = SmartPhones.allCases

// SE-0054 Abolish ImplicitlyUnwrappedOptional type
// !(ImplicitlyUnwrappedOptional)は?(Optional)のSugar Syntaxに置き換えられた
// 最終的には言語仕様から削除される可能性も高いので、早いうちに無くす方が良い印象

// 背景とかメリット、実装例などはひどく長くなりそうなので次回に回す

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
let personName = person.name
let city = person.city
let hoge = person.hoge

// String以外の型は返せない
//struct Product {
//    subscript(dynamicMember member : String) -> Int {
//        let properties = ["price": 500]
//        return properties[member, default: 0]
//    }
//}
//
//let product = Product()
//let price = product.price

// Anyを返すのはNG
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

// SE-0079 Allow using optional binding to upgrade self from a weak to strong reference
class SomePrinter {
    var name = "foo"
    
    func someAsyncTask() {
        DispatchQueue.global().async { [weak self] in
//            guard let weakSelf = self else { return } と書く必要はない
            guard let self = self else {
                // この書き方も怒られる
                // self?.someErrorHandler()
                return
            }
            self.name = "bar"
        }
    }
    
    func someErrorHandler() {
        print("foo")
    }
}

// SE-0205 withUnsafePointer(to:_:) and withUnsafeBytes(of:_:) for immutable values
// Swift 4.1 までの書き方
let x = 5
var mutX = x
withUnsafePointer(to: &mutX) { pointer in
    print(pointer.pointee)
}

// Swift 4.2 以降の書き方
withUnsafePointer(to: x) { pointer in
    print(pointer.pointee)
}
