import UIKit
import RxSwift




/// `Single`: chỉ emit ra 1 element hoặc 1 error
func single() {
    let bag = DisposeBag()
    
    enum FileError: Error {
        case pathError
    }
    
    func readFile(path: String?) -> Single<String> {
        return Single.create { single -> Disposable in
            if let path = path  {
                single(.success("Success!"))
            } else {
                single(.failure(FileError.pathError))
            }
            
            return Disposables.create()
        }
    }
    
    readFile(path: nil)
        .subscribe({ event in
            switch event {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        })
    
    .disposed(by: bag)
}

/// `Completable`: chỉ emit ra chỉ complete hoặc 1 error
func completable() {
    let bag = DisposeBag()
    
    enum FileError: Error {
        case pathError
        case failedCaching
    }
    
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            // Store some data locally
            //...
            //...
            
            let success = true
            
            guard success else {
                completable(.error(FileError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    cacheLocally()
        .subscribe { completable in
            switch completable {
            case .completed:
                print("Completed with no error")
            case .error(let error):
                print("Completed with an error: \(error)")
            }
    }
    .disposed(by: bag)
    
    cacheLocally()
        .subscribe(onCompleted: {
            print("Completed with no error")
        },
                   onError: { error in
                    print("Completed with an error: \(error)")
        })
        .disposed(by: bag)
}


/// `Maybe`: Có thể phát ra duy nhất một element, phát ra một error hoặc cũng có thể không phát ra bất cứ evenet nào và chỉ complete
func maybe() {
    
    let bag = DisposeBag()
    
    enum MyError: Error {
        case anError
    }
    
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success("RxSwift"))
            
            // OR
            
            maybe(.completed)
            
            // OR
            
            maybe(.error(MyError.anError))
            
            return Disposables.create {}
        }
    }
    
    generateString()
        .subscribe { maybe in
            switch maybe {
            case .success(let element):
                print("Completed with element \(element)")
            case .completed:
                print("Completed with no element")
            case .error(let error):
                print("Completed with an error \(error.localizedDescription)")
            }
    }
    .disposed(by: bag)
    
    generateString()
        .subscribe(onSuccess: { element in
            print("Completed with element \(element)")
        }, onError: { error in
            print("Completed with an error \(error.localizedDescription)")
        }, onCompleted: {
            print("Completed with no element")
        })
        .disposed(by: bag)
}

//single()
//completable()
maybe()
