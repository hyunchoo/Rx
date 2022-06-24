

import RxSwift

let desposedBag = DisposeBag()

print("------toArray--------")

Observable.of("A", "B", "C")
    .toArray()  //Single로 만들어진다  .just["A","B","C"] 처럼 만들어진다
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: desposedBag)


print("------MAP--------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: desposedBag)


print("------flatMAP--------")
protocol sunsu {
    var jumsu: BehaviorSubject<Int> { get }
}

struct yanggung: sunsu {
    var jumsu: BehaviorSubject<Int>
}


let korea = yanggung(jumsu: BehaviorSubject<Int>(value: 10))
let usa = yanggung(jumsu: BehaviorSubject<Int>(value: 8))

let Olympic = PublishSubject<sunsu>()

  Olympic
    .flatMap { sunsu in
        sunsu.jumsu
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: desposedBag)

Olympic.onNext(korea)
korea.jumsu.onNext(10)

Olympic.onNext(usa)
korea.jumsu.onNext(10)
usa.jumsu.onNext(9)


print("------flatMapLatest--------") // 가장최신의 값을 자기고 싶을떄 사용한다
struct hightJump: sunsu {
    var jumsu: BehaviorSubject<Int>
}

let seoul = hightJump(jumsu: BehaviorSubject<Int>(value: 7))
let zeju = hightJump(jumsu: BehaviorSubject<Int>(value: 6))

let champion = PublishSubject<sunsu>()

champion
    .flatMapLatest { sunsu in
        sunsu.jumsu
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: desposedBag)

champion.onNext(seoul)
seoul.jumsu.onNext(9)

champion.onNext(zeju)
seoul.jumsu.onNext(10)
zeju.jumsu.onNext(8)


print("-------materialize and dematerialize-------")

enum Foul: Error {
    case falsestart
}

struct runsunsu:sunsu {
    var jumsu: BehaviorSubject<Int>
    
}
let choo = runsunsu(jumsu: BehaviorSubject<Int>(value: 0))
let park = runsunsu(jumsu: BehaviorSubject<Int>(value: 1))


let running = BehaviorSubject<sunsu>(value: choo)

running
    .flatMapLatest { sunsu in
        sunsu.jumsu
            .materialize()
    }
    .filter{
        guard let error = $0.error else {
            return  true
            
        }
        print(error)
        return false
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: desposedBag)

choo.jumsu.onNext(1)
choo.jumsu.onError(Foul.falsestart) // 여기서 끝이 난다.
choo.jumsu.onNext(2)

running.onNext(park)



print("--------전화번호 11자리--------")

 let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
        ? Observable.empty() // 닐이면 빈공간을 보내줘
        : Observable.just($0) // 닐이 아니라면 너가 같은 값을 보내줘
    }
    .map { $0! }
    .skip(while: { $0 != 0 }) // 0이 아니면 스킵한다
    .take(11) // 010-1234-1234  11개 이기 때문에
    .toArray() // 정렬해준다
    .asObservable() //toArray를 사용하면 Single로 변환하기 때문에 다시 옵저버블로 변경시켜준다
    .map {
        $0.map {"\($0)"}  // 숫자처럼 보이지만 스트링 타입으로 변경
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8)// 010-1234-
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: desposedBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)








