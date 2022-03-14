//
//  ViewController.swift
//  RealM
//
//  Created by 이준영 on 2022/03/14.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var cnt = 0
    var load:[Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField, tableView의 delegate, dataSource 연결
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableViewCell의 Xib 연결
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "Cell")
    }

    @IBAction func AddAction(_ sender: Any) {
        
        // 라벨에 아무것도 없을 때 Alert창을 띄움
        if textField.text == "" {
            alertA(msg: "이름을 입력해주세요")
            return
        }
        
        guard let name = textField.text else{ return }
        
        // 지금 시간을 가져오는 dataFormatter()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let nowDate = dateFormatter.string(from: date)
        
        //데이터 추가
        let realm = try! Realm()
        
        cnt = cnt + 1
        try! realm.write{
            let realmData = Content()
            realmData.id = cnt
            realmData.name = name
            realmData.date = nowDate
            realm.add(realmData)
        }
        
        alertA(msg: "데이터가 추가 되었습니다.")
    }
    
    @IBAction func DelAction(_ sender: Any) {

        let realm = try! Realm()
        
//        // 데이터 전체 삭제
//        let del = realm.objects(Content.self)
//        try? realm.write{
//            realm.deleteAll(del)
//        }
//        alertA(msg: "데이터가 삭제 되었습니다.")
        
        if let delete = realm.objects(Content.self).filter(NSPredicate(format: "name = %@", textField.text ?? "")).first{
            try! realm.write{
                realm.delete(delete)
            }
            alertA(msg: "삭제되었습니다.")
        }
        alertA(msg: "삭제 할 이름이 없습니다.")
    }
    
    @IBAction func LoadAction(_ sender: Any) {
        let realm = try! Realm()
        let result = realm.objects(Content.self)
        self.load = Array(result)
        
        tableView.reloadData()
    }
    @IBAction func updateAction(_ sender: Any) {
        let realm = try! Realm()
        if let update = realm.objects(Content.self).filter(NSPredicate(format: "name = %@", textField.text ?? "")).first{
            try! realm.write{
                update.name = "update"
            }
            alertA(msg: "update로 변경됐습니다.")
        } else{
            alertA(msg: "변경 할 이름이 없습니다.")
        }
    }
    
    func alertA (msg: String) {
        let alert = UIAlertController(title: "오류", message: msg, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
   }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return load.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.idLabel.text = String(load[indexPath.row].id)
        cell.nameLabel.text = load[indexPath.row].name
        cell.dateLabel.text = load[indexPath.row].date
        return cell
    }
    
    
}

