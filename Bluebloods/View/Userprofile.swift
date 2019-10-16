//
//  Userprofile.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 10/3/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import RealmSwift

class Userprofile: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var navigationUiView: UIView!
    var gradientLayer: CAGradientLayer!
    let nameArry = ["Name","Email","Mobile Phone","Home Store","Sales ID"]
    var valueArry:[String] = []
    var userData : Results<UserModel>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourSwitcher()
        
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            valueArry.append("\(alluserData.firstName) \(alluserData.lastName)")
            valueArry.append(alluserData.email)
            valueArry.append(alluserData.mobileNo)
            valueArry.append(alluserData.mobileNo)
            valueArry.append(alluserData.currentStatus)
            valueArry.append(alluserData.salesId)
     
            
        }
    }
    

    
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true)
        
        
    }
    
    @IBAction func signout(_ sender: Any) {
        let alert = UIAlertController(title: "Are You sure you want to logout?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
            UserDefaults.standard.set(false, forKey: "isLogin")
            Switcher.updateRootVC()
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
        
    }
    func colourSwitcher() {
        navigationUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
       // self.bottomGradientView.insertSublayer(gradientLayer, atIndex: 0)
        self.bottomGradientView.layer.addSublayer(gradientLayer)
    }
    
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        return nameArry.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as! UserProfileCell
        cell.nameLbl.text = nameArry[indexPath.row]
        cell.valueLbl.text = valueArry[indexPath.row]
        return cell
    }
    
    ///////////

}
