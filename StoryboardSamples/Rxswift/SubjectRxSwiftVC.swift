//
//  SubjectRxSwiftVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/13.
//

// 참고: https://jinshine.github.io/2019/01/05/RxSwift/3.Subject%EB%9E%80/
// 요약: Subject는 Observable + Observer
//      실시간으로 Observable에 값을 추가하고, Subscriber에게 방출 할 때 사용.
//      Relay는 RxCocoa에 들어있다.
// 종류:
// PublishSubject: 초기값이 없음. 구독자는 구독 후에 방출된 데이터만 전달받을 수 있다.
// BehaviorSubject: 초기값이 존재. 구독자는 구독 직후 현재 subject가 저장하고 있는 값을 전달 받는다. 그 이후는 PublishSubject와 같다. (Variable가 deprecate되고 이 subject로 교체됨)
// ReplaySubject: 초기값 없음. 구독을 시작하면, 구독자는 이전에 subject가 발행한 모든 데이터들 중에 subject의 buffer만큼  전달받는다. 이후는 PublishSubject와 같다.
// AsyncSubject: 초기값 없음. 구독자는 subject가 complete될 때, 저장된 마지막 데이터를 전달 받는다. 즉, subject는 complete 때 이외에는 데이터를 발행하지 않는다.

import UIKit
import RxSwift
import RxCocoa

class SubjectRxSwiftVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("PublishSubject():")
        testPublishSubject()
        
        print()
        
        print("BehavierSubject():")
        testBehavierSubject()
        
        print()
        
        print("ReplaySubject():")
        testReplaySubject()
        
        print()
        
        print("AsyncSubject():")
        testAsyncSubject()
    }
    
    private func testPublishSubject() {
        let subject = PublishSubject<Int>()
        subject.onNext(0)

        let subscriptionOne = subject
            .subscribe(onNext: { num in
                print("1)  \(num)")
            })
        subject.on(.next(1))
        subject.onNext(2)

        let subscriptionTwo = subject
            .subscribe({ event in
                print("2)", event.element ?? event)
            })

        subject.onNext(3)

        subscriptionOne.dispose()

        subject.onNext(4)
        subject.onCompleted()
        subject.onNext(5)

        subscriptionTwo.dispose()

        let disposeBag = DisposeBag()

        subject
            .subscribe {
                print("3)", $0.element ?? $0)
            }
            .disposed(by: disposeBag)

        subject.onNext(9999)
    }
    
    private func testBehavierSubject() {
        let subject = BehaviorSubject<Int>(value: 999)
        subject.onNext(0)

        let subscriptionOne = subject
            .subscribe(onNext: { num in
                print("1)  \(num)")
            })
        subject.on(.next(1))
        subject.onNext(2)

        let subscriptionTwo = subject
            .subscribe({ event in
                print("2)", event.element ?? event)
            })

        subject.onNext(3)

        subscriptionOne.dispose()

        subject.onNext(4)
        subject.onCompleted()
        subject.onNext(5)

        subscriptionTwo.dispose()

        let disposeBag = DisposeBag()

        subject
            .subscribe {
                print("3)", $0.element ?? $0)
            }
            .disposed(by: disposeBag)

        subject.onNext(9999)
    }
    
    private func testReplaySubject() {
        let subject = ReplaySubject<Int>.create(bufferSize: 1)
        subject.onNext(0)

        let subscriptionOne = subject
            .subscribe(onNext: { num in
                print("1)  \(num)")
            })
        subject.on(.next(1))
        subject.onNext(2)

        let subscriptionTwo = subject
            .subscribe({ event in
                print("2)", event.element ?? event)
            })

        subject.onNext(3)

        subscriptionOne.dispose()

        subject.onNext(4)
        subject.onCompleted()
        subject.onNext(5)

        subscriptionTwo.dispose()

        let disposeBag = DisposeBag()

        subject
            .subscribe {
                print("3)", $0.element ?? $0)
            }
            .disposed(by: disposeBag)

        subject.onNext(9999)
    }
    
    private func testAsyncSubject() {
        let subject = AsyncSubject<Int>()

        let subscriptionOne = subject
            .subscribe(onNext: { num in
                print("1)  \(num)")
            })
        subject.on(.next(1))
        subject.onNext(2)

        let subscriptionTwo = subject
            .subscribe { event in
                print("2)", event.element ?? event)
            }

        subject.onNext(3)

        // 당연한 이야기지만, dispose된 구독자1은 이벤트를 받지 못한다.
        subscriptionOne.dispose()

        subject.onNext(4)
        subject.onCompleted()
        subject.onNext(5)

        subscriptionTwo.dispose()

        let disposeBag = DisposeBag()

        subject
            .subscribe {
                print("3)", $0.element ?? $0)
            }
            .disposed(by: disposeBag)

        subject.onNext(9999)
    }
    
}
