//
//  FirstViewController.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import DropDown
import SwiftyJSON
import LinearProgressBar
import NVActivityIndicatorView


class TimelineViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    @IBOutlet weak var filterbarLogo: UIImageView!
    @IBOutlet weak var navigationBarUiView: UIView!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var filterbarHolder: UIView!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var storeManagerTable: UITableView!
    
    @IBOutlet weak var storeManagerSepataror: UIView!
    @IBOutlet weak var storeManagerTabBar: UIView!
    
    @IBOutlet weak var storeButton: UIButton!
    
    @IBOutlet weak var individulButton: UIButton!
    
    
    @IBOutlet weak var kpiView: UIView!
    @IBOutlet weak var storemanagerView: UIView!
    @IBOutlet weak var incentiveLbl: UILabel!
    @IBOutlet weak var recurungNameLbl: UILabel!
    @IBOutlet weak var timePeriodLbl: UILabel!
    @IBOutlet weak var timelineTable: UITableView!
    @IBOutlet weak var filterbarUIView: UIView!
    var gradientLayer: CAGradientLayer!
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
    
    var storeManagerDataArry:JSON = []
    
    var kpitTableData:JSON = []
    var kpitTableIndividualData:JSON = []
    var kpitTableStoreData:JSON = []
    
    var leaderBordDataArry:JSON = []
    var selectedincentiveId = 0
    var selectedRecuringId = 0
    var selectedRecuringType = ""
    var selectedTimePeriod = ""
    var selectedTimeStart = ""
    var selectedTimend = ""
    var selectedTimPeriod_ID = 0
    var userRole = ""
    var storeName = ""
    var storeLogoPath = ""
    var storeType = false
    
    var userData : Results<UserModel>?
    var timePeriodArry:[String] = []
    var timePeriodstartArry:[String] = []
    var timePeriodendArry:[String] = []
    var timePeriodendIdArry:[Int] = []
    var isTokenSync = false
    var apnsToken = ""
    var salesId = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nodataView.isHidden = true
        filterbarLogo.layer.cornerRadius = filterbarLogo.frame.height / 2
        filterbarLogo.clipsToBounds = true
        colourSwitcher()
        loadIncentive()
        getIncentiveFilter()
        storeManagerTable.separatorStyle = .none
        timelineTable.allowsSelection = false
        timelineTable.separatorStyle = .none
      //  apnsToken = UserDefaults.standard.string(forKey: "apnsToken")!
        
        if isKeyPresentInUserDefaults(key: "apnsToken") {
           apnsToken = UserDefaults.standard.string(forKey: "apnsToken")!
            syncDeviceToken()
        } else {
           print("No APNS")
        }
   
        
        let realm = try! Realm()
        let organizationTheme = realm.objects(OrganizationTheme.self)
        storeLogoPath  = organizationTheme[0].logoSmall
        filterbarLogo.sd_setImage(with: URL(string: storeLogoPath), placeholderImage: UIImage(named: "placeholder.png"))
        syncDeviceToken()
        individulButton.backgroundColor = .clear
        individulButton.layer.cornerRadius = 18
        individulButton.layer.borderWidth = 1.5
        individulButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor
       // storeButton.setTitleColor(UIColor().colourHex1(), for: .normal)
      //  individulButton.setTitleColor(UIColor().colourHex1(), for: .normal)
       
        userData  = try! Realm().objects(UserModel.self)
        for alluserData in userData!  {
            userRole = alluserData.userRole
            salesId = alluserData.salesId
            storeName = alluserData.storeName
            
        }
        
        if(userRole == "STORE_MANAGER"){
            storeManagerSepataror.isHidden = false
            storeManagerTabBar.isHidden = false
            storeButton.setTitle("Store",for: .normal)
            
        }else{
            storeManagerSepataror.isHidden = true
            storeManagerTabBar.isHidden = true
         self.kpiView.frame.origin.y = 198
   
            salesId = ""
        }
        
      
        
        
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
            
            self.loadIndividualKpiData()
         
        }
        
        if(kpitTableIndividualData.count > 0){
            timelineTable.isHidden = false
            nodataView.isHidden = true
        }else{
            timelineTable.isHidden = true
            nodataView.isHidden = false
        }
       
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func storeButtonClick(sender: AnyObject) {
        
        individulButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        storeButton.backgroundColor = .clear
        storeButton.layer.cornerRadius = 18
        storeButton.layer.borderWidth = 1.5
        storeButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor
        
        storeType = true
        kpitTableData = kpitTableStoreData
        
       
        if(kpitTableData.count > 0){
            timelineTable.isHidden = false
            nodataView.isHidden = true
            timelineTable.reloadData()
        }else{
            timelineTable.isHidden = true
            nodataView.isHidden = false
             timelineTable.reloadData()
        }
        
        
    }
    
    @IBAction func unwindToRed(segue: UIStoryboardSegue) {
        print("here its unwind")
    }
    
    @IBAction func change(_ sender: Any) {
     //   self.selectedIndex = 0
       }
    
    @IBAction func individualButtonClick(sender: AnyObject) {
        
        storeButton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        individulButton.backgroundColor = .clear
        individulButton.layer.cornerRadius = 18
        individulButton.layer.borderWidth = 1.5
        individulButton.layer.borderColor = UIColor(red:0.61, green:0.84, blue:0.82, alpha:1.0).cgColor
        storeType = false
        kpitTableData = kpitTableIndividualData
        if(kpitTableData.count > 0){
            timelineTable.isHidden = false
            nodataView.isHidden = true
            timelineTable.reloadData()
        }else{
            timelineTable.isHidden = true
            nodataView.isHidden = false
             timelineTable.reloadData()
        }
        
    }

    
    ///////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
          return kpitTableData.count
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let someInt = kpitTableData[indexPath.row]["specialPlace"].int{
             return 138
        } else {
            return 138
        }
             }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
        if let someInt = kpitTableData[indexPath.row]["specialPlace"].int{
            
            let cell:DashbordPointsCell = tableView.dequeueReusableCell(withIdentifier: "DashbordPointsCell") as! DashbordPointsCell
            
            let baronevalue = kpitTableData[indexPath.row]["value1"].stringValue
            let baronevalue_fil = kpitTableData[indexPath.row]["target"].doubleValue
            let bartwovalue_fil = kpitTableData[indexPath.row]["total"].doubleValue
            let bartwovalue = kpitTableData[indexPath.row]["value2"].intValue
            let baroneColour = kpitTableData[indexPath.row]["color1"].stringValue
            let bartwoColour = kpitTableData[indexPath.row]["color2"].stringValue
            let ShortName = kpitTableData[indexPath.row]["LongName"].stringValue
            
            let WebName = kpitTableData[indexPath.row]["MobileName"].stringValue
            let mobileName = kpitTableData[indexPath.row]["TargetMobileName"].stringValue
            
            cell.batOne.progressValue = CGFloat(bartwovalue_fil)
            cell.barTwo.progressValue = CGFloat(baronevalue_fil)
            cell.frontValue.text = String(someInt)
            
            cell.batOne.barColor = UIColor().colourHex(hexColour: baroneColour)
            cell.barTwo.barColor = UIColor().colourHex(hexColour: bartwoColour)
            cell.cellHeader.text = ShortName
            
            
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: WebName, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            text.append(NSAttributedString(string: " ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            text.append(NSAttributedString(string: String(baronevalue), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)]))
            cell.barOneValue.attributedText = text
            
            cell.barOneValue.textColor = UIColor().colourHex(hexColour: baroneColour)
            
            let texttwo = NSMutableAttributedString()
            texttwo.append(NSAttributedString(string: mobileName, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            texttwo.append(NSAttributedString(string: " ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            texttwo.append(NSAttributedString(string: String(bartwovalue), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)]))
            cell.barTwoValue.attributedText = texttwo
            cell.barTwoValue.textColor = UIColor().colourHex(hexColour: bartwoColour)
            

            return cell
        } else {
            let cell:DashbordBonuASPCell = tableView.dequeueReusableCell(withIdentifier: "DashbordBonuASPCell") as! DashbordBonuASPCell
            
          
            let baroneColour = kpitTableData[indexPath.row]["color1"].stringValue
            let bartwoColour = kpitTableData[indexPath.row]["color2"].stringValue
          let baronevalue_fil = kpitTableData[indexPath.row]["target"].doubleValue
                     let bartwovalue_fil = kpitTableData[indexPath.row]["total"].doubleValue
            if( kpitTableData[indexPath.row]["ShortName"].stringValue == " "){
                 cell.achementHeadder.text = "\(kpitTableData[indexPath.row]["LongName"].stringValue)"
            }else{
                 cell.achementHeadder.text = "\(kpitTableData[indexPath.row]["LongName"].stringValue) ( \(kpitTableData[indexPath.row]["ShortName"].stringValue) )"
            }
           
            cell.progressBarone.progressValue = CGFloat(bartwovalue_fil)
            cell.progressbarTwo.progressValue = CGFloat(baronevalue_fil)
            cell.progressBarone.barColor = UIColor().colourHex(hexColour: baroneColour)
            cell.progressbarTwo.barColor = UIColor().colourHex(hexColour: bartwoColour)
            let yourARHeadder = "\(kpitTableData[indexPath.row]["MobileName"].stringValue) "
            let targetHeadder = "\(kpitTableData[indexPath.row]["TargetMobileName"].stringValue) "
            
            var yourARValue =  ""
            var targetValue = " "
            
            if(kpitTableData[indexPath.row]["MeasureType"].stringValue == "POINT"){
                
                 yourARValue = "Point \(kpitTableData[indexPath.row]["value1"].stringValue)"
                 targetValue = "Point \(kpitTableData[indexPath.row]["value2"].stringValue)"
            } else if(kpitTableData[indexPath.row]["MeasureType"].stringValue == "#"){
                           
                            yourARValue = "# \(kpitTableData[indexPath.row]["value1"].stringValue)"
                            targetValue = "# \(kpitTableData[indexPath.row]["value2"].stringValue)"
                }else if(kpitTableData[indexPath.row]["MeasureType"].stringValue == "$"){
                           
                            yourARValue = "$ \(kpitTableData[indexPath.row]["value1"].stringValue)"
                            targetValue = "$ \(kpitTableData[indexPath.row]["value2"].stringValue)"
                }
            
            
            
            
         
            cell.yorArHeadder.textColor = UIColor().colourHex(hexColour: baroneColour)
           
            cell.targetArHeader.textColor = UIColor().colourHex(hexColour: bartwoColour)
          
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: yourARHeadder, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            text.append(NSAttributedString(string: yourARValue, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)]))
            cell.yorArHeadder.attributedText = text
            
            let textTarget = NSMutableAttributedString()
            textTarget.append(NSAttributedString(string: targetHeadder, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]))
            textTarget.append(NSAttributedString(string: targetValue, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)]))
            cell.targetArHeader.attributedText = textTarget
            
          //  cell.targetArHeader.frame.origin.x = CGFloat((targetValue as NSString).floatValue)

           // cell.targetArHeader.frame.origin.x = 300
           // cell.yorArHeadder.frame.origin.x = 300

            return cell
        }
        
    }
    
    func colourSwitcher() {
        navigationBarUiView.layer.backgroundColor = UIColor().colour1()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.filterbarUIView.frame.width + 200, height: self.filterbarUIView.frame.height)
        gradientLayer.colors = [UIColor().colour2(), UIColor().colour1()]
        self.filterbarUIView.layer.addSublayer(gradientLayer)
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
    
    func loadIncentive(){
        incentiveArry.removeAll()
        incentiveidArry.removeAll()
        incentives  = try! Realm().objects(Incentive.self)
          
               for allIncentives in incentives!  {
                
                   incentiveArry.append(allIncentives.incentiveName)
                   incentiveidArry.append(allIncentives.incentiveId)
               }
        
        if(self.incentiveidArry.count > 0){
            selectedincentiveId = self.incentiveidArry[0]
            incentiveLbl.text = incentiveArry[0]
            loadRecuring()
        }else{
           let alert = UIAlertController(title: "", message: "No incentives to display", preferredStyle: UIAlertController.Style.alert)
           
        //    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        }else{
            print("show alert")
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
                    loadIndividualKpiData()
        }
        
//         timePeriodLbl.text = timePeriodArry[0]
//         self.selectedTimePeriod = timePeriodArry[0]
//        self.selectedTimeStart = self.timePeriodstartArry[0]
//        self.selectedTimend = self.timePeriodendArry[0]
//
//        loadIndividualKpiData()
    }

    func syncDeviceToken(){
        
        let json: JSON =  ["deviceType": "ios","token": apnsToken]
     
        RestClient.makeArryPatchRequestWithToken(url: APPURL.sendToken,arryParam: json, delegate: self, requestFinished: #selector(self.requestFinishedSync), requestFailed: #selector(self.requestFailedSync), tag: 1)
    }

    @objc func requestFinishedSync(response:ResponseSwift){
  
    do {
        let userObj = JSON(response.responseObject!)
       print("TokenSync\(userObj)")
       //  UserDefaults.standard.set(true, forKey: "isLogin")
    } catch let error {
              print(error)
          }
          
      }
    
    @objc func requestFailedSync(response:ResponseSwift){
         print("Response is - \(response)")
    }
    
    
    ////
    func getIncentiveFilter() {
        
        activityIndicator.startAnimating()
        RestClient.makeGetRequstWithToken(url: APPURL.getFilter, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedfec), tag: 1)
        
    }
    
    
    
    func loadStoreKpiData() {
        activityIndicator.startAnimating()
        let uri = "\(APPURL.fetchStoreDashbord)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&PeriodId=\(selectedTimPeriod_ID)&moduleType=rep&tableDisplay=false"
            
           
        

        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchStoreKpi), requestFailed: #selector(self.requestFailedfec), tag: 1)
        
    }
    
    func loadIndividualKpiData() {
        
        activityIndicator.startAnimating()
           let uri = "\(APPURL.fetchIndividualDashbord)\(selectedincentiveId)&selectPeriod=\(selectedRecuringType)&StartDate=\(selectedTimeStart)&EndDate=\(selectedTimend)&PeriodId=\(selectedTimPeriod_ID)&moduleType=rep&tableDisplay=false"
       
        RestClient.makeGetRequstWithToken(url: uri, delegate: self, requestFinished: #selector(self.requestFinishedFetchKpiIndividual), requestFailed: #selector(self.requestFailedfec), tag: 1)
        
    }
    
    
    @objc func requestFinishedFetchStoreKpi(response:ResponseSwift){
        
        do {
            
            activityIndicator.stopAnimating()
            let userObj = JSON(response.responseObject!)
            let code = userObj["response"]["code"].intValue
            
            print("Store object\(userObj)")
    
            if(code == 200){
                kpitTableStoreData = userObj["response"]["dataArr"]
                
                storemanagerView.isHidden = true
                
                
                if(storeType){
                    kpitTableData = kpitTableStoreData
                    if(kpitTableData.count > 0){
                        timelineTable.isHidden = false
                        nodataView.isHidden = true
                        timelineTable.reloadData()
                    }else{
                        timelineTable.isHidden = true
                        nodataView.isHidden = false
                        timelineTable.reloadData()
                    }
                }else{
                    
                }
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    
    
    @objc func requestFinishedFetchKpiIndividual(response:ResponseSwift){
        
        do {
            activityIndicator.stopAnimating()
            loadStoreKpiData()
            let userObj = JSON(response.responseObject!)
            let code = userObj["response"]["code"].intValue
            
            if(code == 200){
                kpitTableIndividualData = userObj["response"]["dataArr"]
                kpitTableData = kpitTableIndividualData
                
                
               
                if(kpitTableData.count > 0){
                    timelineTable.isHidden = false
                    nodataView.isHidden = true
                    timelineTable.reloadData()
                }else{
                     timelineTable.reloadData()
                    nodataView.isHidden = false
                }
                storemanagerView.isHidden = true
                
                
                
                
            }else if(code == 401){
                let alert = UIAlertController(title: "Session expired, please enter username and password again", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
                    
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    Switcher.updateRootVC()
                    
                    
                }))
                
                
                self.present(alert, animated: true)
            }
            
        } catch let error {
            print(error)
        }
        
    }
    
    @objc func requestFinishedFetch(response:ResponseSwift){
        
        do {
            activityIndicator.stopAnimating()
            let userObj = JSON(response.responseObject!)
            
          print("Arina\(userObj)")
            
            let incentiveJson = userObj["response"]["Periods"]

            var IncentiveDBs:[Incentive] = []
            var RecurringDBs:[Recurring] = []
            var TimePeriodsDBs:[TimePeriods] = []
            let realm = try! Realm()
            try! realm.write {
   
            }
            
            var  i = 0
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
                        if let RecurringType = subtimeJson["name"].string {
                            i = i + 1
                            let recuringname = subtimeJson["name"].stringValue
                           
                            let recuringid = i
                            
                            let dropDownList = subtimeJson["dropDownList"]
                            let RecurringDB = Recurring()
                            RecurringDB.incentiveId = incentiveId
                            RecurringDB.recuringid = recuringid
                            RecurringDB.recuringname = recuringname
                            RecurringDB.RecurringType = RecurringType
                            
                            RecurringDBs.append(RecurringDB)
                        
                            for (_, dropDownJson) in dropDownList {
                                let TimePeriodsDB = TimePeriods()
                                
                                TimePeriodsDB.incentiveId = incentiveId
                                TimePeriodsDB.recuringid = recuringid
                                TimePeriodsDB.periodName = dropDownJson["name"].stringValue
                                TimePeriodsDB.StartDate = dropDownJson["StartDate"].stringValue
                                TimePeriodsDB.EndDate = dropDownJson["EndDate"].stringValue
                                TimePeriodsDB.timeperiodid = dropDownJson["id"].intValue
                                TimePeriodsDBs.append(TimePeriodsDB)
                            }

                        }
                    }
                    
                    
                    
                }
                
            }
            
            
            try! realm.write {
                
           
                realm.add(IncentiveDBs, update: true)
                realm.add(RecurringDBs, update: true)
                realm.add(TimePeriodsDBs, update: true)
                
            }
             loadIncentive()
        } catch let error {
            print(error)
        }
        
    }

    @objc func requestFailedfec(response:ResponseSwift){
        activityIndicator.stopAnimating()
    }
    ///
    
    
    func saveToJsonFile(fileName:String,json:JSON) {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        
        let personArray = json
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: personArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    func readJson(fileName:String, completion: (JSON) -> ()) {
        
        var jsonArry:JSON?
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: String]]] else { return }
            jsonArry = JSON(personArray)
        } catch {
            print(error)
        }
        completion(jsonArry!)
    }
}

