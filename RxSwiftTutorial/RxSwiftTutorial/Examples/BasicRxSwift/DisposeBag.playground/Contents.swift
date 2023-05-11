import UIKit
import RxSwift

func dispose() {
    let observable = Observable<String>.of("A", "B", "C", "D", "E", "F")
    
    let subscription = observable.subscribe { event in
        print(event)
    }
    
    subscription.dispose()
}

func disposeBag() {
    let bag = DisposeBag()
    
    Observable<String>.of("A", "B", "C", "D", "E", "F")
        .subscribe { event in
            print(event)
        }
        .disposed(by: bag)
}

func create() {
    enum MyError: Error {
      case anError
    }
    
    let bag = DisposeBag()
    
    Observable<String>.create { observer -> Disposable in
        observer.onNext("1")
        
        observer.onNext("2")
        
        observer.onNext("3")
        
        observer.onNext("4")
        
//        observer.onError(MyError.anError)
        
        observer.onNext("5")
        
//        observer.onCompleted()
        
        observer.onNext("6")
        
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
        )
    .disposed(by: bag)
}

//dispose()
//disposeBag()
create()
