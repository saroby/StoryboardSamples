//
//  JsonSampleVC.swift
//  StoryboardSamples
//
//  Created by 신희욱 on 2020/09/08.
//

import UIKit


class JsonSampleVC: UIViewController {
    
    // 온라인으로 uuid 생성: https://www.uuidgenerator.net/version4
    // 참고: https://www.hackingwithswift.com/articles/162/how-to-use-raw-strings-in-swift
    let dataStr = #"{"menu": { "id": "01eb1591-98a3-4c1d-82a0-582fb7c5e908", "value": "File", "popup": { "menuitem": [ {"value": "New", "onclick" :"CreateNewDoc()"}, {"value": "Open", "onclick": "OpenDoc()"}, {"value": "Close", "onclick": "CloseDoc()"} ] } }}"#
    
    
    struct JsonSample: Codable {
        struct Menu: Codable {
            struct Popup: Codable {
                var menuitem: [[String:String]]
            }
            var id: UUID
            var value: String
            var popup: Popup
        }
        var menu: Menu
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("1. 타입을 사용하여 인토딩/디코딩하는 방법")
        do {
            var jsonSampleObj = try JSONDecoder().decode(JsonSample.self, from: dataStr.data(using: .utf8)!)
            print("jsonSampleObj: \(jsonSampleObj)")
            
            // 수정
            jsonSampleObj.menu.id = UUID()
            jsonSampleObj.menu.popup.menuitem = []
            
            let encodedData = try JSONEncoder().encode(jsonSampleObj)
            let encodedStr = String(data: encodedData, encoding: .utf8)!
            print("encodeStr: \(encodedStr)")
        } catch {
            print("\(error)")
        }
        
        
        print("2. JSONSerialization를 사용하는 방법")
        // 아래 링크를 숙지해야 함.
        // https://stackoverflow.com/questions/40057854/what-do-jsonserialization-options-do-and-how-do-they-change-jsonresult
        do {
            // make sure this JSON is in the format we expect
            let jsonSampleData = dataStr.data(using: .utf8)!
            if let jsonObj = try JSONSerialization.jsonObject(with: jsonSampleData, options: [.mutableContainers]) as? [String: Any] {
                if let menu = jsonObj["menu"] as? NSMutableDictionary/* [String: Any]*/ {
                    print(menu["id"]!)
                    
                    //NOTICE:
                    // options: [] 일때는 수정되지 않는것을 확인
                    // options: [.fragmentsAllowed] 일때도 수정되지 않는것을 확인
                    // options: [.mutableLeaves] 일때도 수정되지 않는것을 확인
                    // [String: Any]로 struct화 했을 때도 수정되지 않는 것을 확인
                    // jsonObj["menu"]["id"] = "dummy id" 이렇게는 접근이 안되므로 수정이 불가능하다.
                    
                    menu["id"] = "dummy id" // 수정 시도
                    
                    
                    print(menu["value"]!)
                    if let popup = menu["popup"] as? NSMutableDictionary/* [String: Any]*/ {
                        if let menuitem = popup["menuitem"] as? [[String:String]] {
                            print(menuitem)
                            
                            popup["menuitem"] = [] // 수정 시도
                        }
                    }
                    
                }
                
                let modifiedData = try JSONSerialization.data(withJSONObject: jsonObj, options: [])
                print(String(data: modifiedData, encoding: .utf8)!)
            }
            
        } catch let error as NSError {
            print("\(error)")
        }
    }

}
