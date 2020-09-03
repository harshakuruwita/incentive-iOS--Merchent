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
import NVActivityIndicatorView

class LeaderBoard: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var incentiveLbl: UILabel!
    @IBOutlet weak var recurungNameLbl: UILabel!
    @IBOutlet weak var timePeriodLbl: UILabel!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var noDataView: UIView!
    
    
    @IBOutlet weak var leaderbordTable: UITableView!
    
    @IBOutlet weak var storeManagerTab: UIView!
    
    
    @IBOutlet weak var filterBarLogoLB: UIImageView!
    
    @IBOutlet weak var storeUiView: UIView!
  
    
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
     var timePeriodendIdArry:[Int] = []
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
     var selectedTimPeriod_ID = 0
    
    var leaderBordTableJSONData:JSON = []
    var leaderBordTableIndividualData:JSON = []
    var leaderBordTableStoreData:JSON = []
    var colourJsonArry:JSON = []
    
    var timePeriodArry:[String] = []
    var timePeriodstartArry:[String] = []
    var timePeriodendArry:[String] = []
    var leaderBordDataArry:JSON = []
    var storeID = 0
    var userData : Results<UserModel>?
    var scrolingPosition = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterBarLogoLB.layer.cornerRadius = filterBarLogoLB.frame.height / 2
        filterBarLogoLB.clipsToBounds = true
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let organizationTheme = realm.objects(OrganizationTheme.self)
       let storeLogoPath  = organizationTheme[0].logoSmall
        filterBarLogoLB.sd_setImage(with: URL(string: storeLogoPath), placeholderImage: UIImage(named: "placeholder.png"))
        noDataView.isHidden = true
        individualButton.backgroundColor = .clear
        individualButton.layer.cornerRadius = 18
        individualButton.layer.borderWidth = 1.5

      //  storeButton.setTitleColor(UIColor().colourHex1(), for: .normal)
     //   individualButton.setTitleColor(UIColor().colourHex1(), for: .normal)
        individualButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor
        loadIncentive()
        
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
            self.loadTimePeriod()
        }
        
        
        timePeriodPicker.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            self.timePeriodLbl.text = self.timePeriodArry[index]
            self.selectedTimePeriod = self.timePeriodArry[index]
            self.selectedTimeStart = self.timePeriodstartArry[index]
            self.selectedTimend = self.timePeriodendArry[index]
            self.selectedTimPeriod_ID = self.timePeriodendIdArry[index]
            self.getLeaderBordIndividualData()
        }
        
        
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            userRole = alluserData.userRole
            salesId = alluserData.salesId
            storeID = alluserData.storeId
            storeName = alluserData.storeName
        }
        
        if(userRole == "STORE_MANAGER"){
           
            storeManagerTab.isHidden = false
            individualButton.isHidden = false
            storeButton.isHidden = false
            storeButton.setTitle("Store",for: .normal)
            
        }else{
            //ABX
            storeManagerTab.isHidden = false
            individualButton.isHidden = true
            storeButton.isHidden = true
            self.storeUiView.frame.origin.y = 198
            
          //  salesId = ""
        }
        
        
        if(leaderBordTableIndividualData.count > 0){
                   
                   noDataView.isHidden = true
               }else{
               
                   noDataView.isHidden = false
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
    
    
    @IBAction func jumpToMyStore(sender: AnyObject) {
       
        if(scrolingPosition > 2){
            let pathToLastRow = IndexPath.init(row: scrolingPosition, section: 0)
             leaderbordTable.scrollToRow(at: pathToLastRow, at: .none, animated: true)
        }
        
 
     
    
    }
    
    
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = .none
        print("Table data count==\(leaderBordTableJSONData)")
        return leaderBordTableJSONData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LeaderBordStoreCell = tableView.dequeueReusableCell(withIdentifier: "LeaderBordStoreCell") as! LeaderBordStoreCell
        cell.positionLbl.text = leaderBordTableJSONData[indexPath.row]["Position"].stringValue
        cell.nameLbl.text = leaderBordTableJSONData[indexPath.row]["User Id"].stringValue
        print()
        cell.pointsLbl.text = leaderBordTableJSONData[indexPath.row]["Point"].stringValue
        
        
//       print("Pints value -------\(leaderBordTableJSONData[indexPath.row]["Points"])")
//         print("salesId-\(leaderBordTableJSONData[indexPath.row]["User Id"].stringValue)")
//
//        print("storeID-\(storeID)")
//                print("storeID-\(leaderBordTableJSONData[indexPath.row]["StorePrimaryId"].int)")
        
        if(salesId == leaderBordTableJSONData[indexPath.row]["User Id"].stringValue || storeID == leaderBordTableJSONData[indexPath.row]["StorePrimaryId"].int ){
            scrolingPosition = indexPath.row
              let colourJson = colourJsonArry.stringValue
            if (colourJson == "" || colourJson == "{}"){
            cell.roundUiView.backgroundColor = UIColor().colourHex(hexColour: "#8f6917")
            
            }else{
               let result_1 = colourJson.split(separator: "#")
                let result_2 = result_1[2].split(separator: "\"")
               
                cell.roundUiView.backgroundColor = UIColor().colourHex(hexColour: "#\(result_2[0])")
            }
            
        }else{
            let colourJson = colourJsonArry.stringValue
            if (colourJson == "" || colourJson == "{}"){
                       cell.roundUiView.backgroundColor = UIColor().colourHex(hexColour: "#9BD6D1")
                       
                       }else{
                           let result_1 = colourJson.split(separator: "#")
                           let result_2 = result_1[1].split(separator: "\"")
                           cell.roundUiView.backgroundColor = UIColor().colourHex(hexColour: "#\(result_2[0])")
                       }
        }
        
        
        
        return cell
        }
    
    ///////////
   
    
    @IBAction func storeButtonClick(sender: AnyObject) {
        
         individualButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5
        storeButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor
   
        leaderBordTableJSONData = leaderBordTableStoreData
        
        if(leaderBordTableJSONData.count > 0){
            noDataView.isHidden = true
         
             leaderbordTable.reloadData()
        }else{
            noDataView.isHidden = false
            leaderbordTable.reloadData()
        }
       
       
        
        storeType = true
    }
    
    @IBAction func individualButtonClick(sender: AnyObject) {
        
        storeButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        individualButton.backgroundColor = .clear
        individualButton.layer.cornerRadius = 18
        individualButton.layer.borderWidth = 1.5
        individualButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor

        leaderBordTableJSONData = leaderBordTableIndividualData
      
      
         if(leaderBordTableJSONData.count > 0){
                   noDataView.isHidden = true
                    leaderbordTable.reloadData()
               }else{
                   noDataView.isHidden = false
            leaderbordTable.reloadData()
               }
        storeType = false
        
    }
 
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.gradianentView.frame.width + 200, height: self.gradianentView.frame.height)
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
        self.gradianentView.layer.addSublayer(gradientLayer)
    }
    
  
   
    func getIncentiveFilter() {
        
        
         RestClient.makeGetRequstWithToken(url: APPURL.getFilter, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
    }
    
    func loadIncentive(){
        incentives  = try! Realm().objects(Incentive.self)
        
        for allIncentives in incentives!  {
           
            incentiveArry.append(allIncentives.incentiveName)
            incentiveidArry.append(allIncentives.incentiveId)
        }
        if(self.incentiveidArry.count > 0){
            selectedincentiveId = self.incentiveidArry[0]
            incentiveLbl.text = incentiveArry[0]
            loadRecuring()
        }
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
        
        TimePeriodss  = try! Realm().objects(TimePeriods.self).filter("recuringid = \(self.selectedRecuringId) AND incentiveId = \(selectedincentiveId)")
        
        timePeriodArry.removeAll()
        timePeriodstartArry.removeAll()
        timePeriodendArry.removeAll()
        timePeriodendIdArry.removeAll()
        
        for allTimePeriodss in TimePeriodss!  {
            timePeriodArry.append(allTimePeriodss.periodName)
            timePeriodstartArry.append(allTimePeriodss.StartDate)
            timePeriodendArry.append(allTimePeriodss.EndDate)
            timePeriodendIdArry.append(allTimePeriodss.timeperiodid)
            
        }
          if(timePeriodArry.count > 0){
        timePeriodLbl.text = timePeriodArry[0]
        self.selectedTimePeriod = timePeriodArry[0]
        self.selectedTimeStart = self.timePeriodstartArry[0]
        self.selectedTimend = self.timePeriodendArry[0]
        self.selectedTimPeriod_ID = self.timePeriodendIdArry[0]
        getLeaderBordIndividualData()
        }
    }
    
    func getLeaderBordIndividualData() {
        
        activityIndicator.startAnimating()
        let uri = "\(APPURL.fetchIndividualLeaderBordData)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&PeriodId=\(selectedTimPeriod_ID)&moduleType=rep&tableDisplay=false"
        
        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchLeaderbord), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
        print("09=url: \(uri)")
         
        
    }
    
    func getLeaderBordStoreData() {
        
        activityIndicator.startAnimating()
        let uri = "\(APPURL.fetchStoreLeaderBordData)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&PeriodId=\(selectedTimPeriod_ID)&moduleType=rep&tableDisplay=false"

        print("10=url: \(uri)")
        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchStoreLeaderBord), requestFailed: #selector(self.requestFailedSync), tag: 1)
        
        
        
    }
    
    
    @objc func requestFinishedFetchLeaderbord(response:ResponseSwift){
        
        do {
            activityIndicator.stopAnimating()
            getLeaderBordStoreData()
            let userObj = JSON(response.responseObject!)
            leaderBordTableIndividualData = userObj["response"]["dataArr"]
           colourJsonArry = userObj["response"]["incentive"][0]["ColorSettings"]
            print("Table Data -- \(leaderBordTableIndividualData)")
            
          leaderBordTableJSONData = leaderBordTableIndividualData
        
            if(leaderBordTableJSONData.count > 0){
                noDataView.isHidden = true
               
            }else{
                noDataView.isHidden = false
            }
            
            leaderbordTable.reloadData()
            
            
            
    
        } catch let error {
            print(error)
            activityIndicator.stopAnimating()
            noDataView.isHidden = false
        }
        
    }
    
    
    @objc func requestFinishedFetchStoreLeaderBord(response:ResponseSwift){
        
        do {
            activityIndicator.stopAnimating()
            let userObj = JSON(response.responseObject!)
            
            let code = userObj["response"]["code"].intValue
            
            if(code == 200){
                leaderBordTableStoreData =  userObj["response"]["dataArr"]
                
            
                
                
                if(storeType){
                    leaderBordTableJSONData = leaderBordTableStoreData
                    if(leaderBordTableJSONData.count > 0){
                                   noDataView.isHidden = true
                                  
                               }else{
                                   noDataView.isHidden = false
                               }
                    leaderbordTable.reloadData()
                }else{
                    
                }
            }
            
        } catch let error {
            activityIndicator.stopAnimating()
            print(error)
        }
        
    }
    
    
    @objc func requestFinishedFetch(response:ResponseSwift){
    
    do {
        activityIndicator.stopAnimating()
        let userObj = JSON(response.responseObject!)
        let incentiveJson = userObj["response"]["Periods"]
        
        
        
        
        
        
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
        activityIndicator.stopAnimating()
           
       }

}
