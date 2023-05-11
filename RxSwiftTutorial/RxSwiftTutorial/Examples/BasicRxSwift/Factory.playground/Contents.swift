import UIKit
import RxSwift

func factory() {
    let bag = DisposeBag()
    
    var flip = true
    
    /// `deferre`: để tạo ra Observable nhưng sẽ trì hoãn nó lại, và nó sẽ dc return trong closure
    let factory = Observable<Int>.deferred {
        flip.toggle()
        
        if flip {
            return Observable.of(1)
        } else {
            return Observable.of(0)
        }
    }
    
    for _ in 0...10 {
        factory.subscribe(
            onNext: { print($0, terminator: "") })
            .disposed(by: bag)
    
        print()
    }
}

factory()
