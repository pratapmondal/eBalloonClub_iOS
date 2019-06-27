//
//  eBalloonClubViewController.swift
//  E Balloon
//
//  Created by VAP on 07/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class FreeTrialCell:UITableViewCell{
    
    @IBOutlet weak var CollectionViewTrial: UICollectionView!
    @IBOutlet weak var PageControl: UIPageControl!
}
class OccassionsCell:UITableViewCell{
    
    @IBOutlet weak var lblOccassions: UILabel!
    @IBOutlet weak var CollectionViewOccissions: UICollectionView!
    
    @IBOutlet weak var btnViewAll: UIButton!
}
class FreeTrialCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var imgFreeTrial: UIImageView!
}

class OccassionsCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var lblAnniversary: UILabel!
}

class eBalloonClubViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tablevieweBalloonClub: UITableView!
    var arrCategoryList:NSArray = NSArray()
    var dicAnimationEffectSound:NSDictionary = NSDictionary()
    var intTrialTrack:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "eBalloonClub"
        self.WSGetCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SharedGlobalVariables.selectedViewController = ""
        self.navigationBarSetup()
        if UserDefaults.standard.value(forKey: "custid") == nil {
            self.rightBarItemAdds()
            intTrialTrack = 0
        }else{
            self.WSGetMembershipDetails()
        }
    }
    
    func rightBarItemAdds() {
        let rightButtonItem = UIBarButtonItem.init(
            title: "Sign In",
            style: .done,
            target: self,
            action: #selector(self.loginTap(_:))
        )
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1960784314, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    //MARK: Goto Login Page...
    @objc func loginTap(_ btn:UIButton) {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    
    func WSGetCategories() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [GetCategoryData.page : "0"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_CATEGORY_SUBCAT, parseApiMethod: "POST")
    }
    internal func parseDictGetCategoriesListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            arrCategoryList = dictJson.value(forKey: "data") as! NSArray
            tablevieweBalloonClub.delegate = self
            tablevieweBalloonClub.dataSource = self
            tablevieweBalloonClub.reloadData()
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
    
    func WSGetMembershipDetails() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [GetCategoryData.user_id : UserDefaults.standard.value(forKey: "custid") as! String]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_MEMBERSHIP_DETAILS, parseApiMethod: "POST")
    }
    internal func parseDictGetMembershipDetailsApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
            let strMemberId:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_member") as! String)
            UserDefaults.standard.set(strMemberId, forKey: "is_member")
            
            let strTrialNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_trial") as! String)
            UserDefaults.standard.set(strTrialNumber, forKey: "is_trial")
            
            if strMemberId == "1" && strTrialNumber == "0" {
                if let strMemberShipDetails = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "membership") as AnyObject).value(forKey: "transaction_amount") {
                    UserDefaults.standard.set((strMemberShipDetails as? String), forKey: "transaction_amount")
                }else{
                    UserDefaults.standard.set("", forKey: "transaction_amount")
                }
            }else{
                UserDefaults.standard.set("", forKey: "transaction_amount")
            }
            
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Tableview delegate and datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCategoryList.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }else{
            return 160.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FreeTrialCell", for: indexPath) as!  FreeTrialCell
            cell.CollectionViewTrial.tag = indexPath.section
            cell.CollectionViewTrial.delegate = self
            cell.CollectionViewTrial.dataSource = self
            cell.CollectionViewTrial.reloadData()
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OccassionsCell", for: indexPath) as!  OccassionsCell
            cell.lblOccassions.text = ((arrCategoryList.object(at: indexPath.section - 1) as AnyObject).value(forKey: "name") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.section - 1) as AnyObject).value(forKey: "name") as! String)
            
            cell.btnViewAll.addTarget(self, action: #selector(viewAllCategory(_:)), for: .touchUpInside)
            cell.btnViewAll.accessibilityHint = ((arrCategoryList.object(at: indexPath.section - 1) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.section - 1) as AnyObject).value(forKey: "id") as! String)
            
            
            cell.CollectionViewOccissions.tag = indexPath.section
            cell.CollectionViewOccissions.delegate = self
            cell.CollectionViewOccissions.dataSource = self
            cell.CollectionViewOccissions.reloadData()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
  
    //MARK:CollectionView Delegate and Datasource...
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 1
        }else{
            let cellCount = ((arrCategoryList.object(at: collectionView.tag - 1) as AnyObject).value(forKey: "subcategory") as AnyObject).value(forKey: "data") as! NSArray
            return cellCount.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreeTrialCollectionViewCell", for: indexPath) as! FreeTrialCollectionViewCell
            if UserDefaults.standard.value(forKey: "custid") != nil {
                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
                    if UserDefaults.standard.value(forKey: "is_trial") as! String == "1" {
                        cell.imgFreeTrial.image = UIImage(named: "banner")
                    }else{
                        cell.imgFreeTrial.image = UIImage(named: "banner_1")
                    }
                }else{
                    cell.imgFreeTrial.image = UIImage(named: "banner_2")
                }
            }else{
                cell.imgFreeTrial.image = UIImage(named: "banner")
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccassionsCollectionViewCell", for: indexPath as IndexPath) as! OccassionsCollectionViewCell
            let arrCellDetails = ((arrCategoryList.object(at: collectionView.tag - 1) as AnyObject).value(forKey: "subcategory") as AnyObject).value(forKey: "data") as! NSArray
            
            let strDescription = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
            let data = Data(strDescription.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                cell.lblAnniversary.attributedText = attributedString
            }else{
                cell.lblAnniversary.text = strDescription
            }
            cell.lblAnniversary.textAlignment = .center
            cell.lblAnniversary.adjustsFontSizeToFitWidth = false;
            cell.lblAnniversary.lineBreakMode = NSLineBreakMode.byTruncatingTail
            
           //image colour set
            let strBalloonId = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
            if strBalloonId == "29" {
                cell.imgBalloon.image = UIImage(named: "flag-balloon")
            }else{
                cell.imgBalloon.image = cell.imgBalloon.image!.withRenderingMode(.alwaysTemplate)
                let hexaColorCode1 = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") as! String)
                if hexaColorCode1 != "" {
                    let start = hexaColorCode1.index(hexaColorCode1.startIndex, offsetBy: 1)
                    let hexColor = String(hexaColorCode1[start...])
                    cell.imgBalloon.tintColor = UIColor(hex: hexColor)
                }else{
                    cell.imgBalloon.tintColor = UIColor.red
                }
            }
            
           return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: (collectionView.frame.size.width), height: collectionView.frame.size.height)
        }else{
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0.0
        }else{
            return 3.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return 0.0
        }else{
            return 3.0
        }
    }
    
    @objc func viewAllCategory(_ btn:UIButton) {
        //arrCategoryList
        let tableCell = btn.superview?.superview as! UITableViewCell
        let indexpath = self.tablevieweBalloonClub.indexPath(for: tableCell)
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AllCataegoriesViewController") as! AllCataegoriesViewController
        controllerObj.strPhotoSelection = btn.accessibilityHint
        controllerObj.title = ((arrCategoryList.object(at: ((indexpath?.section)! - 1)) as AnyObject).value(forKey: "name") as! String)
        controllerObj.strSelectCategoryName = ((arrCategoryList.object(at: ((indexpath?.section)! - 1)) as AnyObject).value(forKey: "name") as! String)
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag != 0 {
            let tableCell = collectionView.superview?.superview as! UITableViewCell
            let indexpath = self.tablevieweBalloonClub.indexPath(for: tableCell)
            let dicSelectBalloonDetails = arrCategoryList.object(at: ((indexpath?.section)! - 1)) as! NSDictionary
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonColorViewController") as! eBalloonColorViewController
            let arrCellDetails = (dicSelectBalloonDetails.value(forKey: "subcategory") as AnyObject).value(forKey: "data") as! NSArray
            
            let strSelectCategoryName = (dicSelectBalloonDetails.value(forKey: "name") is NSNull) ? "" : dicSelectBalloonDetails.value(forKey: "name") as! String
            SharedGlobalVariables.dicSaveBallonData.setValue(strSelectCategoryName, forKey: "sub_cat_name")
            
            let strBalloonColor = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") as! String)
            SharedGlobalVariables.dicSaveBallonData.setValue(strBalloonColor, forKey: "BalloonColor")
            
            let selectedBalloonId = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
            SharedGlobalVariables.dicSaveBallonData.setValue(selectedBalloonId, forKey: "balloon_id")
            
            let strAudioLink:String = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "audio") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "audio") as! String)
            SharedGlobalVariables.dicSaveBallonData.setValue(strAudioLink, forKey: "audio")
            
            let strBalloonId = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
            
            let strDescription:String = ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull) ? "" : ((arrCellDetails.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
            let data = Data(strDescription.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                let stringFormating = attributedString.string as String
                SharedGlobalVariables.dicSaveBallonData.setValue(stringFormating, forKey: "description")
            }else{
                SharedGlobalVariables.dicSaveBallonData.setValue(strDescription, forKey: "description")
            }
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }else{
            if UserDefaults.standard.value(forKey: "custid") == nil {
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }else{
                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
                    let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
//                    controllerObj.intComingPageTracking = 2
                    self.navigationController?.pushViewController(controllerObj, animated: true)
                }
            }
        }
    }
    
    func membershipCalculate() {
        let membershipCreateData = UserDefaults.standard.value(forKey: "created_at") as! String
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "el_GR") as? Locale
        formatter.locale = NSLocale(localeIdentifier: "fr_FR") as? Locale
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let Date1 = formatter.date(from: membershipCreateData)
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.hour, from: Date1!, to: now, options: [])
        let ageHours = calcAge.hour
        if UserDefaults.standard.value(forKey: "is_trial") as! String == "0" {
            intTrialTrack = 1
            UserDefaults.standard.set("1", forKey: "is_member")
        }else{
            if ageHours! < 168 {
                intTrialTrack = 0
                UserDefaults.standard.set("1", forKey: "is_member")
            }else{
                intTrialTrack = 1
                UserDefaults.standard.set("0", forKey: "is_member")
            }
        }
    }


}

