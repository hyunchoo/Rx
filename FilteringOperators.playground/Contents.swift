
import RxSwift

let disposeBag = DisposeBag()

print("------ignoreElements-------")

let sleeping๐ด = PublishSubject<String>()

sleeping๐ด
    .ignoreElements()
    .subscribe { _ in
        print("โ๏ธ")
    }
    .disposed(by: disposeBag)

sleeping๐ด.onNext("๐")
sleeping๐ด.onNext("๐")
sleeping๐ด.onNext("๐")
sleeping๐ด.onCompleted()
// ignoreElements๋ onNext ๋ฅผ ๋ฌด์ํ๋ค


print("------elementAt-------")

let abc = PublishSubject<String>()  // abc= ๋๋ฒ ์ธ๋ฆฌ๋ฉด ๊นจ๋์ฌ๋
    abc
    .element(at: 2)  // ํน์  ์ธ๋ฑ์ค ์์๋ง ๋ฐฉ์ถํ๋ค
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
abc.onNext("๐") // index0
abc.onNext("๐") // index1
abc.onNext("๐") // index2    index2 ์ด๊ธฐ ๋๋ฌธ์ ์ด๊ฒ๋ง ๋ฐฉ์ถํ๋ค.
abc.onNext("๐") // index3


print("------Filter-------")

Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter{ $0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------skip-------") // ๋ง ๊ทธ๋๋ก ๋ฌด์ํ๋ค
Observable.of("1","2","3","4","5","6","7","8","9")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipwhile-------") //
Observable.of("1","2","3","4","5","6","7","8","9","10")
    .skip(while: {
        $0 != "5"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipUntil-------") //

let guest = PublishSubject<String>()
let openTime = PublishSubject<String>()

guest  //ํ์ฌ Observable
    .skip(until: openTime) // ๋ค๋ฅธ Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

guest.onNext("์๋1")
guest.onNext("์๋2")
guest.onNext("์๋3")
guest.onNext("์๋4")

openTime.onNext("๋!") // ๋ฌธ์ ์ด์ง ์์๊ธฐ๋๋ฌธ์ ์์๋ ๋ฐฉ์ถํ ์๊ฐ ์๋ค.

guest.onNext("์๋5")


print("------take-------") // Take๋  skip์ ๋ฐ๋ ํํ์ด๋ค.

Observable.of("๊ธ๋ฉ๋ฌ","์๋ฉ๋ฌ","๋๋ฉ๋ฌ","์ถ๊ตฌ์ ์","์ผ๊ตฌ์ ์")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeWhile-------") // ์คํต์์ผ๊ณผ ๋ฐ๋ ํํ์ด๋ค.
Observable.of("๊ธ๋ฉ๋ฌ","์๋ฉ๋ฌ","๋๋ฉ๋ฌ","์ถ๊ตฌ์ ์","์ผ๊ตฌ์ ์")
    .take(while: {
        $0 != "๋๋ฉ๋ฌ"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------enumrated-------")

Observable.of("๊ธ๋ฉ๋ฌ","์๋ฉ๋ฌ","๋๋ฉ๋ฌ","์ถ๊ตฌ์ ์","์ผ๊ตฌ์ ์")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeUntil-------")

let gg = PublishSubject<String>() //gg = ์๊ฐ์ ์ฒญ
let hh = PublishSubject<String>() // hh = ์ ์ฒญ๋ง๊ฐ

    gg
    .take(until: hh)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
gg.onNext("์ ์!")
gg.onNext("๋๋!")
hh.onNext("๋!")
gg.onNext("๋ ๋ฆ์์ด ")

print("------distincUntilChanged-------") //์ฐ๋ฌ์ ๊ฐ์๊ฐ์ ์ค๋ณต๋๊ฑธ ์ง์์ค๋ค.
Observable.of("์ ๋","์ ๋","์ต๋ฌด์","์ต๋ฌด์","์ต๋ฌด์","์๋๋ค","์๋๋ค","์๋๋ค","์๋๋ค","์ผ๊น์?","์ ๋","์ต๋ฌด์","์ผ๊น์?","์ผ๊น์?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
