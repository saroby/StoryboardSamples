#  RxSwift


리액티브 프로그래밍:
RX = Observable + Observer + Schedulers


장점:
<반응형 패러다임이 주는 명확함>
delegate에 의존하지 않고 선형 개발을 할 수 있다.
덕분에 로직이 파편화되지 않아, 코드가 가진 의미 파악과 관리가 쉽다.
 
 <더 적은 코딩> (개인적인 의견이라 논란이 있을 수 있음)
기존의 방식은 각종 extension을 만들거나 delegate를 선언하고 구현하는 등 다양한 추가 타이핑이 필요하다.
반면 rxswift는 체이닝을 통해 로직을 구성하는 패러다임이므로 코딩수가 적다. 


<다양한 언어에서 지원>
리액티브를 쓸 수 있는 많은 언어들이 있으므로, 배워 놓으면 다른 언어에서 러닝커브가 적다.



단점:
<RxSwift는 외워야 할 것이 많다>
각종 함수들과 액션들이 어떤 역할을 하는지 파악할고 있어야 한다.

<클로저 캡처리스트에서 메모리 누수가 일어날 수 있다>
클래스 함수를 bind 시킬 수 있지만 메모리누수의 원인이 된다.
bind는 클로져만 사용하는 것이 좋다.
클로져에서 사용하는 외부 포인터는 weak 예약어나, with형 구독함수 또는 withUnretained를 사용해야 메모리 누수가 없다.


Hot/Cold Observable
Hot: 구독 여부와 산관 없이 이벤트가 발생 (Connectable Observable이라고도 불린다)
Cold: 구독되어야 이벤트가 발생
Cold과 hot을 변경할 수 있는 연산자가 존재 (TODO: 알아봐야한다)
