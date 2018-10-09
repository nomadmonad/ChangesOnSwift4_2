import UIKit

// SE-0079 Allow using optional binding to upgrade self from a weak to strong reference
class SomePrinter {
    var name = "foo"
    
    func printAsync() {
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

let sp = SomePrinter()
sp.printAsync()
let name = sp.name


// SE-0054 Abolish ImplicitlyUnwrappedOptional type
func switchIUO(_ input: String?) -> String {
    switch input {
    case .none:
        return "input is nil"
    default:
        return input!
    }
}

switchIUO("some String")
switchIUO(nil)

let someStr = "To be or not to be"
someStr.first(where: { print($0) })
someStr.lastIndex(of: "e")
someStr.lastIndex(where: { $0 == "e" })

