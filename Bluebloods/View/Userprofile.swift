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
    
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var navigationUiView: UIView!
    var gradientLayer: CAGradientLayer!
    let nameArry = ["Name","Email","Mobile Phone","Store name","Store ID","Primary SalesID","Secondary Sales ID"]
    var valueArry:[String] = []
    var userData : Results<UserModel>?
    var secondrySaleIds :[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourSwitcher()
        let nc = NotificationCenter.default
        userTable.allowsSelection = false
        nc.addObserver(self, selector: #selector(updateui), name: Notification.Name("UserLoggedIn"), object: nil)
        
        userTable.flashScrollIndicators()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let indexPath = IndexPath(item: 4, section: 0)
             self.userTable.scrollToRow(at: indexPath, at: .top, animated: true)
          self.userTable.flashScrollIndicators()
        }
        
        fetchUserData()
    }
    
    func fetchUserData() {
          let access_token = UserDefaults.standard.string(forKey: "token")
          let uri = APPURL.fetchUserData
          RestClient.makeGetRequst(url: uri,access_token: access_token!, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedSync), tag: 1)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
           guard let data = UserDefaults.standard.value(forKey: "salesIdArry") as? Data else { return }
             
             let json = JSON(data)
             if let items = json.array {
                 for item in items {
                     if let title = item.string {
                       
                         self.secondrySaleIds.append(title)
                     }
                 }
             }
        var new =  "\(secondrySaleIds)".replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
        
            
            
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            valueArry.append("\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)")
            valueArry.append(alluserData.email)
            valueArry.append((UserDefaults.standard.string(forKey: "mobilenumber")!) )
            valueArry.append(alluserData.storeName)
            valueArry.append(String(alluserData.storeId))
            valueArry.append(alluserData.salesId)
            valueArry.append("\(new)")
            
            
        }
        userTable.reloadData()
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.dismiss(animated: true)
        
        
    }
    
    @objc public func updateui(){
        fetchUserData()
        secondrySaleIds.removeAll()
        guard let data = UserDefaults.standard.value(forKey: "salesIdArry") as? Data else { return }
                 
                 let json = JSON(data)
                 if let items = json.array {
                     for item in items {
                         if let title = item.string {
                           
                             self.secondrySaleIds.append(title)
                         }
                     }
                 }
        var new =  "\(secondrySaleIds)".replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
             
        valueArry.removeAll()
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            valueArry.append("\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)")
            valueArry.append(alluserData.email)
            valueArry.append((UserDefaults.standard.string(forKey: "mobilenumber")!) )
            valueArry.append(alluserData.storeName)
            valueArry.append(String(alluserData.storeId))
            valueArry.append(alluserData.salesId)
            valueArry.append("\(new)")
            
            
        }
        userTable.reloadData()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        valueArry.removeAll()
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            valueArry.append("\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)")
            valueArry.append(alluserData.email)
            valueArry.append(alluserData.mobileNo)
            valueArry.append(alluserData.storeName)
            valueArry.append(String(alluserData.storeId))
            valueArry.append(alluserData.salesId)
            valueArry.append(alluserData.salesId_second)
            
            
        }
        userTable.reloadData()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //    {
    //        if segue.destination is ProfileEdit
    //        {
    //
    //            self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    //
    //        }
    //    }
    
    @IBAction func contactUsTap(_ sender: Any) {
        self.dismiss(animated: true)
        var window: UIWindow?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window?.rootViewController as! AppNavigator
        tabBarController.selectedIndex = 3
        
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
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as! UserProfileCell
        cell.nameLbl.text = nameArry[indexPath.row]
        cell.valueLbl.text = valueArry[indexPath.row]
        return cell
    }
    
    ///////////
    @objc func requestFinishedFetch(response:ResponseSwift){
          
          do {
              let userObj = JSON(response.responseObject!)
              
              if(userObj["response"]["code"].int == 200){
                 
                 
                  if(userObj["response"]["code"].int == 200){
                      
                      let user = userObj["response"]["data"]["user"]
                      let salesIds = userObj["response"]["data"]["salesIds"]
                      let organization = userObj["response"]["data"]["org"]
                      let organizationTheam = userObj["response"]["data"]["org"]["OrganizationTheme"]
                      var theamJson = JSON.init(parseJSON:organizationTheam.stringValue)
                      
                    
                      
                      UserDefaults.standard.set(user["firstName"].stringValue, forKey: "firstName")
                      UserDefaults.standard.set(user["lastName"].stringValue, forKey: "lastName")
                      UserDefaults.standard.set(user["mobileNo"].stringValue, forKey: "mobilenumber")
                      
                      guard let rawData = try? salesIds.rawData() else { return }
                      UserDefaults.standard.setValue(rawData, forKey: "salesIdArry")
                    

                      secondrySaleIds.removeAll()
                      guard let data = UserDefaults.standard.value(forKey: "salesIdArry") as? Data else { return }
                               
                               let json = JSON(data)
                               if let items = json.array {
                                   for item in items {
                                       if let title = item.string {
                                         
                                           self.secondrySaleIds.append(title)
                                       }
                                   }
                               }
                      var new =  "\(secondrySaleIds)".replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
                           
                    
                    valueArry.removeAll()
                           userData  = try! Realm().objects(UserModel.self)
                           for alluserData in userData!  {
                               valueArry.append("\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)")
                               valueArry.append(alluserData.email)
                               valueArry.append((UserDefaults.standard.string(forKey: "mobilenumber")!) )
                               valueArry.append(alluserData.storeName)
                               valueArry.append(String(alluserData.storeId))
                               valueArry.append(alluserData.salesId)
                               valueArry.append("\(new)")
                               
                               
                           }
                           userTable.reloadData()
                    print("fffffffffff\(user["firstName"].stringValue)")
                      
                  }
                  
              }else {
                  
                  
                  
                  
                 
    
              }
              
          } catch let error {
              print(error)
          }
          
      }
    
    @objc func requestFailedSync(response:ResponseSwift){
           
       }
       
}
