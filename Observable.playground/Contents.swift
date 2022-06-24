import Foundation
import RxSwift

print("----just----")
Observable<Int>.just(1)
    .subscribe(onNext:{
        print($0)
    })

print("----of----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext:{
        print($0)
    })


print("----of2----")
Observable.of([1, 2, 3, 4, 5]) // 사실상 이건 just와 같다
    .subscribe(onNext:{
        print($0)
    })


print("----from----")
Observable.from([1, 2, 3, 4, 5])  // 배열만 받을수 있다 순차적으로 1개씩 나온다
    .subscribe(onNext:{
        print($0)
    })

print("----subscribe1----")
Observable.of(1, 2, 3)
    .subscribe({
        print($0)
    })


print("----subscribe2----")
Observable.of(1, 2, 3)
    .subscribe{
if let element = $0.element {
    print(element)
 }
}

print("----subscribe3----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })


print("----empty----") // 1. 즉시종료할수있는 Observable을 리턴할떄  2. 의도적으로 0개의 값을 가지는 Observable 표현하고 싶을때
Observable<Void>.empty()
    .subscribe {
        print($0)
    }


print("----never----")
Observable.never()
    .debug("never")
    .subscribe(onNext: {
        print($0)
    },
               onCompleted: {
        print("Completed")
    })



print("----range----") // 범위에 있는 어레이를 스타트 부터 카운트 크기만큼의 값을 가지도록 만들어주는것
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0) = \(2*$0)")
    })


print("----dispose----") // 완료시킨다.
Observable.of(1, 2, 3)
    .subscribe{
        print($0)
    }
    .dispose()

print("----disposeBag----")
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)


print("----create1----")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}

.subscribe {
    print($0)
}
.disposed(by: disposeBag)


print("----error----")
enum MyError: Error {
  case anError
    
}
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    
    return Disposables.create()
        

}
.subscribe(onNext: {
    print($0)
    },
           onError: {
    print($0.localizedDescription)
    },
           onCompleted: {
    print("completed")
    },
           onDisposed: {
    print("disposed")
    })
.disposed(by: disposeBag) // 반드시 넣어야함  메모리 누수를 안함


print("----deffered1----")

Observable.deferred {
    Observable.of(1,2,3)
}
.subscribe{
    print(1)
}
.disposed(by: disposeBag)


print("----deffered1----")

var a: Bool = false

let factory: Observable<String> = Observable.deferred {
    a = !a
    if a {
        return Observable.of("b")
    } else {
        return Observable.of("c")
    }
}

for cc in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
        .disposed(by: disposeBag)
}
