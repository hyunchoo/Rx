
import RxSwift

let disposeBag = DisposeBag()

print("------ignoreElements-------")

let sleeping😴 = PublishSubject<String>()

sleeping😴
    .ignoreElements()
    .subscribe { _ in
        print("☀️")
    }
    .disposed(by: disposeBag)

sleeping😴.onNext("🔊")
sleeping😴.onNext("🔊")
sleeping😴.onNext("🔊")
sleeping😴.onCompleted()
// ignoreElements는 onNext 를 무시한다


print("------elementAt-------")

let abc = PublishSubject<String>()  // abc= 두번 울리면 깨는사람
    abc
    .element(at: 2)  // 특정 인덱스 에서만 방출한다
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
abc.onNext("🔊") // index0
abc.onNext("🔊") // index1
abc.onNext("😊") // index2    index2 이기 때문에 이것만 방출한다.
abc.onNext("🔊") // index3


print("------Filter-------")

Observable.of(1, 2, 3, 4, 5, 6, 7, 8) // [1, 2, 3, 4, 5, 6, 7, 8]
    .filter{ $0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------skip-------") // 말 그대로 무시한다
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

guest  //현재 Observable
    .skip(until: openTime) // 다른 Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

guest.onNext("손님1")
guest.onNext("손님2")
guest.onNext("손님3")
guest.onNext("손님4")

openTime.onNext("떙!") // 문을 열지 않았기때문에 위에는 방출할수가 없다.

guest.onNext("손님5")


print("------take-------") // Take는  skip의 반대 표현이다.

Observable.of("금메달","은메달","동메달","축구선수","야구선수")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeWhile-------") // 스킵와일과 반대 표현이다.
Observable.of("금메달","은메달","동메달","축구선수","야구선수")
    .take(while: {
        $0 != "동메달"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------enumrated-------")

Observable.of("금메달","은메달","동메달","축구선수","야구선수")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeUntil-------")

let gg = PublishSubject<String>() //gg = 수강신청
let hh = PublishSubject<String>() // hh = 신청마감

    gg
    .take(until: hh)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
gg.onNext("저요!")
gg.onNext("나도!")
hh.onNext("끝!")
gg.onNext("넌 늦엇어 ")

print("------distincUntilChanged-------") //연달아 같은값의 중복된걸 지워준다.
Observable.of("저는","저는","앵무새","앵무새","앵무새","입니다","입니다","입니다","입니다","일까요?","저는","앵무새","일까요?","일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
