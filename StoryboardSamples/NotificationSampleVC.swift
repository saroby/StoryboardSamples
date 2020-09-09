//
//  NotificationSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/08.
//

import UIKit
import UserNotifications

class NotificationSampleVC: UIViewController {

    var permissionBtn: UIButton!
    
    var sendNowBtn: UIButton!
    
    var sendAfter5SecondsBtn: UIButton!
    
    var reserveEvery0SecondsNotiReqId: String?
    var reserveEvery0SecondsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UNUserNotificationCentet는 앱 내에서 공유되므로 delegate 위임자의 인스턴스 라이프타임을 신경써야 한다.
        UNUserNotificationCenter.current().delegate = self
        
        // 이전에 등록한 리퀘스트를 모두 지움.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        permissionBtn = UIButton()
        permissionBtn.setTitle("권한 얻기", for: .normal)
        permissionBtn.setTitleColor(.black, for: .normal)
        permissionBtn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        
        sendNowBtn = UIButton()
        sendNowBtn.setTitle("즉시 알림", for: .normal)
        sendNowBtn.setTitleColor(.black, for: .normal)
        sendNowBtn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)

        sendAfter5SecondsBtn = UIButton()
        sendAfter5SecondsBtn.setTitle("5초 후 알림", for: .normal)
        sendAfter5SecondsBtn.setTitleColor(.black, for: .normal)
        sendAfter5SecondsBtn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)

        
        reserveEvery0SecondsBtn = UIButton()
        reserveEvery0SecondsBtn.setTitle("매분 0초 마다 알림", for: .normal)
        reserveEvery0SecondsBtn.setTitleColor(.black, for: .normal)
        reserveEvery0SecondsBtn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        
        
        let vStack = UIStackView(arrangedSubviews: [permissionBtn, sendNowBtn, sendAfter5SecondsBtn, reserveEvery0SecondsBtn])
        vStack.frame = view.frame
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.distribution = .fillProportionally
        vStack.backgroundColor = .systemBackground
        
        view.addSubview(vStack)
    }
    
    @objc private func touchUpInside(_ sender: UIButton) {
        switch sender {
        case permissionBtn:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (ok, error) in
                guard error == nil else {
                    print("\(error)")
                    return
                }
            }
        case sendNowBtn:
            let notiContent = UNMutableNotificationContent()
            notiContent.title = "즉시 알림"
            notiContent.body = "즉시 알림입니다."
            notiContent.sound = .default
            
            let notiReq = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: nil)
            
            UNUserNotificationCenter.current().add(notiReq) { (error) in
                guard error == nil else {
                    print("\(error)")
                    return
                }
            }
        case sendAfter5SecondsBtn:
            let notiContent = UNMutableNotificationContent()
            notiContent.title = "알림 예약"
            notiContent.body = "5초 후 알림입니다."
            notiContent.sound = .default
            
            //NOTICE: timeInterval 0은 런타임 에러를 유발.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            
            let notiReq = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(notiReq) { (error) in
                guard error == nil else {
                    print("\(error)")
                    return
                }
            }

        case reserveEvery0SecondsBtn:
            if let reserveEvery10SecondsNotiReqId = reserveEvery0SecondsNotiReqId {
                UNUserNotificationCenter.current().getPendingNotificationRequests { (reqs) in
                    guard let req = reqs.first(where: { $0.identifier == reserveEvery10SecondsNotiReqId }) else {
                        print("the request not registered.")
                        self.reserveEvery0SecondsNotiReqId = nil
                        return
                    }
                    
                    //UNUserNotificationCenter.current().removeAllPendingNotificationRequests() //모두 지우기
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ req.identifier ])
                    self.reserveEvery0SecondsNotiReqId = nil
                }
                
            } else {
                reserveEvery0SecondsBtn.isSelected = true
                
                let notiContent = UNMutableNotificationContent()
                notiContent.title = "정각 알림"
                notiContent.body = "매분 0초 마다 알림입니다"
                notiContent.sound = .default
                
                var dateComponent = DateComponents()
                dateComponent.second = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)

                let notiReq = UNNotificationRequest(identifier: UUID().uuidString, content: notiContent, trigger: trigger)

                
                UNUserNotificationCenter.current().add(notiReq) { (error) in
                    guard error == nil else {
                        print("\(error)")
                        return
                    }
                    
                    self.reserveEvery0SecondsNotiReqId = notiReq.identifier
                }

            }
            
        default: break
        }
    }
}

extension NotificationSampleVC: UNUserNotificationCenterDelegate {

    // NOTICE:
    // 앱이 forground 상태에서 notification을 보기 위해서는, 아래와 같은 셋팅이 필요하다.
    // 현재는 delegate가 NotificationSampleViewController에 종속되어 있으므로, 다른 ViewController에서는 forground 표시가 되지 않는다.
    // 전체 앱에 적용하기 위해서는 AppDelegate와 같이 앱전체를 책임지는 instance에 delegate를 위임해야 한다.
    // https://stackoverflow.com/questions/14872088/get-push-notification-while-app-in-foreground-ios/40756206#40756206
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, /*.list ,*/ .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
}
