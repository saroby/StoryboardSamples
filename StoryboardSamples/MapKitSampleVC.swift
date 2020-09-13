//
//  MapKitSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/11.
//

import UIKit
import MapKit

class MapKitSampleVC: UIViewController, CLLocationManagerDelegate {

    var mapView: MKMapView!
    
    var locationMgr:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MKMapView().then {
            $0.frame = view.bounds
//            $0.showsUserLocation = true
//            $0.showsCompass = true

             view.addSubview($0)
        }
        
//        let nearMe = MKUserTrackingButton(mapView: mapView)
//        nearMe.frame.size = CGSize(width: 24, height: 24)
//        nearMeParent.addSubview(nearMe!)
//        let compass = MKCompassButton(mapView: mapView)
//        compassParent.addSubview(compass)

        
        locationMgr = CLLocationManager().then {
            // 사용자의 활동유형 지정(기본값 other). 위치 업데이트가 자동으로 일시 중지 될 수 있는 시기를 결정하는 데 영향을 줌.
//            $0.activityType = .fitness
            // 위치 업데이트를 자동으로 끌 수 있는지 결정 (기본값 true)
//            $0.pausesLocationUpdatesAutomatically = false
            
            $0.delegate = self
        }
        
        
        // 핀
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402)
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }
    
    // 위치에 민감한 정보를 사용해야 할 때를 가정. 예를들어, 목적지까지 안내를 해야 할 때.
    @IBAction func startNavigation(_ sender: Any) {
        
        switch locationMgr.accuracyAuthorization {
        case .reducedAccuracy:
            // purposeKey는 plist 파일의 NSLocationTemporaryUsageDescriptionDictionary에 기입된 string을 가져오기 위한 key이다.
            // 앱을 재시동하면 다시 reducedAccuracy 상태로 돌아간다.
            locationMgr.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "WantToNavigation") { (error) in
                // 참고: https://developer.apple.com/documentation/corelocation/cllocationmanager/3600217-requesttemporaryfullaccuracyauth
                // 에러가 발생하는 이유는:
                // 1. plist에 요청한 purposeKey가 존재하지 않을 때.
                // 2. 이미 fullAccuracy 상태일 때.
                // 3. 앱이 백그라운드에 있을 때.
                // 에러 이유가 어찌됐든 현재의 accuracyAuthorization만 보면 되므로, 에러 핸들링 코드보다는 아래 코드처럼 비교문을 넣는 것이 좋을 것 같다.
                // guard error == nil else { return }
                if self.locationMgr.accuracyAuthorization == .reducedAccuracy {
                    print("사용자가 취소하였습니다.")
                    return
                }
                
                self.beginNavigation()
            }
        case .fullAccuracy:
            beginNavigation()
        @unknown default:
            break
        }
    }
    
    private func beginNavigation() {
        locationMgr.allowsBackgroundLocationUpdates = true // 주의: Background Mode를 체크하지 않으면 크러시.
        
        //TODO: 네비게이션 로직을 구성해야 함.
        
        endNavigation()
    }
    
    private func endNavigation() {
        locationMgr.allowsBackgroundLocationUpdates = false
    }
    
    //MARK: CLLocationManagerDelegate
    
    // 주의: iOS14 부터.기존의 didChangeAuthorization는 더이상 작동하지 않고, locationManagerDidChangeAuthorization로 교체됨.
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(locationMgr.desiredAccuracy)
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined:
                // delegate만 할당하면, 액션없이도 locationManagerDidChangeAuthorization가 호출된다. 따라서 함수 안에 request 로직을 넣을 수 있다.
                manager.requestWhenInUseAuthorization()
            case .restricted:
                break
            case .denied:
                break
            case .authorizedAlways:
                startNavigation(self)
                
            
            case .authorizedWhenInUse:
                
                // 유저에게 requestWhenInUseAuthorization를 먼저 물어본 후에, requestAlwaysAuthorization를 호출해야 만 정상동작을 한다.
                // 만약 requestWhenInUseAuthorization로 허락을 받지 않고. requestAlwaysAuthorization를 먼저 호출하면 CCLocationManager.authorizationStatus는 authorizedAlways 상태로 나오겠지만, 기기 세팅에는 앱을 사용하는 동안만으로 제한되어 있을 것이다 (Version 12.0 beta 6에서 확인. 이후 버전에서 재확인 요망)
                // 선택지: "사용하는 동안만 유지", "항상 허용으로 변경"
                manager.requestAlwaysAuthorization()
            default:
                break
            }
        }
    }
    
    //주의: requestLocation()을 호출하기 위해서는 이 메소드가 정의되어 있어야 한다. 아니면 크러시.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    //주의: requestLocation()을 호출하기 위해서는 이 메소드가 정의되어 있어야 한다. 아니면 크러시.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
