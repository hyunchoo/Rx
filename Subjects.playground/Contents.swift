import RxSwift

var disposedBag = DisposeBag()

print("------publishSubject-------")

let publishSubject = PublishSubject<String>()
 
publishSubject.onNext("1. 여러분 안녕하세요")

let a = publishSubject  //a = 구독자 1
    .subscribe(onNext: {
      print("첫번째 구독자: \($0)")
    })


publishSubject.onNext("2. 들리세요?")

publishSubject.on(.next("3. 안들려요?")) // 위에와 같은 표현임
a.dispose()

let b = publishSubject  // b = 구독자2
    .subscribe(onNext: {
        print("두번째 구독자: \($0)")
    })

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()
publishSubject.onNext("5. 끝낫나요?")

b.dispose()


publishSubject
    .subscribe {
        print("세번째 구독:" ,$0.element ?? $0)
    }
    .disposed(by: disposedBag)

publishSubject.onNext("6. 찍힐까?") // onCompleted 이후에 onNext는 받아드릴수 없다.




print("------BehaviorSubject-------")

enum subjectError: Error {
    case error1
}

// BehaviorSubject 반드시 초기값을 가진다
let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")

behaviorSubject.onNext("1. 첫번째 값")

behaviorSubject.subscribe {
    print("첫번째구독:", $0.element ?? $0)
    
}
.disposed(by: disposedBag)
//behaviorSubject.onError(subjectError.error1)

behaviorSubject.subscribe {
    print("두번째구독:", $0.element ?? $0)
}
.disposed(by: disposedBag)

let value = try? behaviorSubject.value()  //거의 사용되지 않음
print(value)



print("------ReplaySubject-------")


let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 추현")
replaySubject.onNext("2. 힘내자")
replaySubject.onNext("3. 고민하자")

replaySubject.subscribe {
    print("첫번째구독:" , $0.element ?? $0)
}
.disposed(by: disposedBag)

replaySubject.subscribe {
    print("두번째구독:", $0.element ?? $0)
}
.disposed(by: disposedBag)

replaySubject.onNext("4. 할수있다 생각하자")
replaySubject.onError(subjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째구독:", $0.element ?? $0)
}
.disposed(by: disposedBag)
