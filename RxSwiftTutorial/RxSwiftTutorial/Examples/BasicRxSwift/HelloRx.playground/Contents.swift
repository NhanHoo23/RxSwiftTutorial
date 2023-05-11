import UIKit
import RxSwift

let helloRx = Observable.just("Hello RxSwift")
helloRx.subscribe { (value) in
    print(value)
}
