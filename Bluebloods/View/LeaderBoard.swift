//
//  LeaderBoard.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/7/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import AAViewAnimator
import DropDown
import SwiftyJSON
import RealmSwift
import RealmSwift

class LeaderBoard: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var incentiveLbl: UILabel!
    @IBOutlet weak var recurungNameLbl: UILabel!
    @IBOutlet weak var timePeriodLbl: UILabel!
    
    @IBOutlet weak var leaderbordTable: UITableView!
    
    @IBOutlet weak var storeManagerTab: UIView!
    
    
    @IBOutlet weak var filterBarLogoLB: UIImageView!
    
    @IBOutlet weak var storeUiView: UIView!
    @IBOutlet weak var individualUiView: UIView!
    
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var individualButton: UIButton!
    
    @IBOutlet weak var navigationBarUiView: UIView!
    @IBOutlet weak var filterbarUIView: UIView!
    
    @IBOutlet weak var gradianentView: UIView!
    
    let storeCellReuseIdentifier = "LeaderBordStoreCell"
    var gradientLayer: CAGradientLayer!
    let picker_values = ["val 1", "val 2", "val 3", "val 4"]

    
    
    var incentives : Results<Incentive>?
    var Recurrings : Results<Recurring>?
    var TimePeriodss : Results<TimePeriods>?
    let incentivePicker = DropDown()
    let recuringPicker = DropDown()
    let timePeriodPicker = DropDown()
    var incentiveArry:[String] = []
    var incentiveidArry:[Int] = []
    
    var recuringidArry:[Int] = []
    var recuringTypeArry:[String] = []
    var recuringNameArry:[String] = []
    var kpiDataArry:JSON = []
    var selectedincentiveId = 0
    var selectedRecuringId = 0
    var selectedRecuringType = ""
    var selectedTimePeriod = ""
    var selectedTimeStart = ""
    var selectedTimend = ""
    
    var userRole = ""
    var storeName = ""
    var salesId = ""
    var storeType = false
    
    var leaderBordTableData:JSON = []
    var leaderBordTableIndividualData:JSON = []
    var leaderBordTableStoreData:JSON = []
    
    var timePeriodArry:[String] = []
    var timePeriodstartArry:[String] = []
    var timePeriodendArry:[String] = []
    var leaderBordDataArry:JSON = []
    
    var userData : Results<UserModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterBarLogoLB.layer.cornerRadius = filterBarLogoLB.frame.height / 2
        filterBarLogoLB.clipsToBounds = true
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let organizationTheme = realm.objects(OrganizationTheme.self)
       let storeLogoPath  = organizationTheme[0].logoSmall
        filterBarLogoLB.sd_setImage(with: URL(string: storeLogoPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5

        storeButton.setTitleColor(UIColor().colourHex1(), for: .normal)
        individualButton.setTitleColor(UIColor().colourHex1(), for: .normal)
       loadIncentive()
        storeButton.layer.borderColor = UIColor().colour1()
        colourSwitcher()
        
        incentivePicker.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.selectedincentiveId = (self.incentiveidArry[index])
            
            self.incentiveLbl.text = self.incentiveArry[index]
            self.loadRecuring()
        }
        
        
        recuringPicker.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.selectedRecuringId = (self.recuringidArry[index])
            self.selectedRecuringType = self.recuringTypeArry[index]
            self.recurungNameLbl.text = self.recuringNameArry[index]
            self.loadRecuring()
        }
        
        
        timePeriodPicker.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            self.timePeriodLbl.text = self.timePeriodArry[index]
            self.selectedTimePeriod = self.timePeriodArry[index]
            self.selectedTimeStart = self.timePeriodstartArry[index]
            self.selectedTimend = self.timePeriodendArry[index]
            self.getLeaderBordData()
        }
        
        
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            userRole = alluserData.userRole
            salesId = alluserData.salesId
            storeName = alluserData.storeName
        }
        
        if(userRole == "STORE_MANAGER"){
           
            storeManagerTab.isHidden = false
            storeButton.setTitle(storeName,for: .normal)
            
        }else{
            
            storeManagerTab.isHidden = true
            self.individualUiView.frame.origin.y = 198
            self.storeUiView.frame.origin.y = 198
            
            salesId = ""
        }
    }
    
    
    
    @IBAction func selectIncentive(sender: AnyObject) {
        
        incentivePicker.anchorView = incentiveLbl
        incentivePicker.dataSource = incentiveArry
        incentivePicker.topOffset = CGPoint(x: 0, y:-(incentivePicker.anchorView?.plainView.bounds.height)!)
        incentivePicker.show()
    }
    
    @IBAction func selectRecuringe(sender: AnyObject) {
        
        recuringPicker.anchorView = recurungNameLbl
        recuringPicker.dataSource = recuringNameArry
        incentivePicker.topOffset = CGPoint(x: 0, y:-(recuringPicker.anchorView?.plainView.bounds.height)!)
        recuringPicker.show()
    }
    
    @IBAction func pickTimePeriod(sender: AnyObject) {
        
        timePeriodPicker.anchorView = timePeriodLbl
        timePeriodPicker.dataSource = timePeriodArry
        timePeriodPicker.topOffset = CGPoint(x: 0, y:-(timePeriodPicker.anchorView?.plainView.bounds.height)!)
        timePeriodPicker.show()
    }
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        return leaderBordTableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaderBordStoreCell = tableView.dequeueReusableCell(withIdentifier: "LeaderBordStoreCell") as! LeaderBordStoreCell
        cell.positionLbl.text = leaderBordTableData[indexPath.row]["position"].stringValue
        cell.nameLbl.text = leaderBordTableData[indexPath.row]["SalesRep"].stringValue
        cell.pointsLbl.text = leaderBordTableData[indexPath.row]["total"].stringValue
        return cell
        }
    
    ///////////
   
    
    @IBAction func storeButtonClick(sender: AnyObject) {
        
         individualButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5
        storeButton.layer.borderColor = UIColor().colour1()
        self.storeUiView.isHidden = false
        self.individualUiView.isHidden = true
        leaderBordTableData = leaderBordTableStoreData
        leaderbordTable.reloadData()
        storeType = true
    }
    
    @IBAction func individualButtonClick(sender: AnyObject) {
        
        storeButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        individualButton.backgroundColor = .clear
        individualButton.layer.cornerRadius = 18
        individualButton.layer.borderWidth = 1.5
        individualButton.layer.borderColor = UIColor().colour1()
         self.individualUiView.isHidden = false
        self.storeUiView.isHidden = true
        leaderBordTableData = leaderBordTableIndividualData
        leaderbordTable.reloadData()
        storeType = false
        
    }
 
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = gradianentView.bounds
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
        self.gradianentView.layer.addSublayer(gradientLayer)
    }
    
  
   
    func getIncentiveFilter() {
        
        
         RestClient.makeGetRequstWithToken(url: APPURL.getFilter, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
    }
    
    func loadIncentive(){
        incentives  = try! Realm().objects(Incentive.self)
        
        for allIncentives in incentives!  {
            print(allIncentives.incentiveName)
            incentiveArry.append(allIncentives.incentiveName)
            incentiveidArry.append(allIncentives.incentiveId)
        }
        selectedincentiveId = self.incentiveidArry[0]
        incentiveLbl.text = incentiveArry[0]
        loadRecuring()
    }
    
    
    
    func loadRecuring(){
        
        Recurrings  = try! Realm().objects(Recurring.self).filter("incentiveId = \(self.selectedincentiveId)")
        recuringidArry.removeAll()
        recuringTypeArry.removeAll()
        recuringNameArry.removeAll()
        for allRecurrings in Recurrings!  {
            recuringidArry.append(allRecurrings.recuringid)
            recuringTypeArry.append(allRecurrings.RecurringType)
            recuringNameArry.append(allRecurrings.recuringname)
            
        }
        
        if(recuringNameArry.count > 0){
            recurungNameLbl.text = recuringNameArry[0]
            selectedRecuringId = recuringidArry[0]
            self.selectedRecuringType = recuringTypeArry[0]
        }
        loadTimePeriod()
    }
    
    
    
    func loadTimePeriod(){
        
        TimePeriodss  = try! Realm().objects(TimePeriods.self).filter("recuringid = \(self.selectedRecuringId)")
        timePeriodArry.removeAll()
        
        for allTimePeriodss in TimePeriodss!  {
            timePeriodArry.append(allTimePeriodss.periodName)
            timePeriodstartArry.append(allTimePeriodss.StartDate)
                       timePeriodendArry.append(allTimePeriodss.EndDate)
            
        }
        
        timePeriodLbl.text = timePeriodArry[0]
        self.selectedTimePeriod = timePeriodArry[0]
        self.selectedTimeStart = self.timePeriodstartArry[0]
              self.selectedTimend = self.timePeriodendArry[0]
        getLeaderBordData()
    }
    
    func getLeaderBordData() {
        
       
        let uri = "\(APPURL.fetchLeaderBordData)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&moduleType=rep&tableDisplay=true"
        
        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchLeaderbord), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
        
        
    }
    
    func getLeaderBordStoreData(salsesId:String) {
        
        
        let uri = "\(APPURL.fetchLeaderBordData)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&moduleType=rep&tableDisplay=true"
        
        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchStoreLeaderBord), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
        
        
    }
    
    
    @objc func requestFinishedFetchLeaderbord(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            leaderBordTableIndividualData = userObj["response"]["dataArr"]["TableBody"]
           
            
            
            if(userRole == "STORE_MANAGER"){
               // loadStoreKpiData(salsesId:salesId)
            }
            
            if(storeType){
                
            }else{
                leaderBordTableData = leaderBordTableIndividualData
            }
            leaderbordTable.reloadData()
           
            
            
            
            
            
    
        } catch let error {
            print(error)
        }
        
    }
    
    
    @objc func requestFinishedFetchStoreLeaderBord(response:ResponseSwift){
        
        do {
            let userObj = JSON(response.responseObject!)
            
            let code = userObj["response"]["code"].intValue
            
            if(code == 200){
                leaderBordTableStoreData =  userObj["response"]["dataArr"]["TableBody"]
                
            
                
                
                if(storeType){
                    leaderBordTableData = leaderBordTableStoreData
                    leaderbordTable.reloadData()
                }else{
                    
                }
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    @objc func requestFinishedFetch(response:ResponseSwift){
    
    do {
        let userObj = JSON(response.responseObject!)
        let incentiveJson = userObj["response"]["Periods"]
        
        print("my008 \(userObj)")
        
        
        
        
        var IncentiveDBs:[Incentive] = []
        var RecurringDBs:[Recurring] = []
        var TimePeriodsDBs:[TimePeriods] = []
        
      
        
        let realm = try! Realm()
                                try! realm.write {

                                 
                                    
                                    
        
                                }
       
        
        for (_, subJson) in incentiveJson {
            if let incentiveName = subJson["incentiveName"].string {
              
            let incentiveId = subJson["incentiveId"].intValue
            let uri = subJson["url"].stringValue
            let timePeriodArr = subJson["timePeriodArr"]
                let IncentiveDB = Incentive()
                IncentiveDB.incentiveId = incentiveId
                IncentiveDB.incentiveName = incentiveName
                IncentiveDB.url = uri
                
                
                IncentiveDBs.append(IncentiveDB)
                
                for (_, subtimeJson) in timePeriodArr {
                           if let RecurringType = subtimeJson["RecurringType"].string {
                               let recuringname = subtimeJson["name"].stringValue
                               let recuringid = subtimeJson["id"].intValue
                               let dropDownList = subtimeJson["dropDownList"]
                            let RecurringDB = Recurring()
                            RecurringDB.incentiveId = incentiveId
                            RecurringDB.recuringid = recuringid
                            RecurringDB.recuringname = recuringname
                            RecurringDB.RecurringType = RecurringType
                           
                            RecurringDBs.append(RecurringDB)
                            ////
                            for (_, dropDownJson) in dropDownList {
                        let TimePeriodsDB = TimePeriods()
                                TimePeriodsDB.incentiveId = incentiveId
                                TimePeriodsDB.recuringid = recuringid
                                TimePeriodsDB.periodName = dropDownJson.stringValue
                                TimePeriodsDBs.append(TimePeriodsDB)
                            }
                            ///
                            
                            
                           }
                       }
                
                
                
            }
            
        }
   
     
                          try! realm.write {
                            
                                    TimePeriodsDBs.removeAll()
                            realm.add(IncentiveDBs, update: true)
                            realm.add(RecurringDBs, update: true)
                            realm.add(TimePeriodsDBs)
                                                     
                                                   }
        
        } catch let error {
                 print(error)
             }
             
         }
    
    @objc func requestFailedSync(response:ResponseSwift){
           
       }

}
