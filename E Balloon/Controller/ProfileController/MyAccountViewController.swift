//
//  MyAccountViewController.swift
//  E Balloon
//
//  Created by VAP on 03/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class AccountEditCEll:UITableViewCell{
    @IBOutlet weak var vwTextViewBackGround: UIView!
    @IBOutlet weak var txtullName: UITextField!
}
class MembersgipCell:UITableViewCell{
    @IBOutlet weak var lblMembership: UILabel!
    @IBOutlet weak var btnCancelMembership: UIButton!
    @IBOutlet weak var constaintMembershipHeight: NSLayoutConstraint!
}

class MyAccountViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableviewMyAccount: UITableView!
    var dicMyProfileDetails:NSMutableDictionary = NSMutableDictionary()
    var myProfileViewController = MyProfileViewController()
    var boolEditable:Bool = false
    var intTrialTrack:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Account"
        myProfileViewController.NavigationBarSetUp()
        let backImage = UIImage(named: "edit-txt")!
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(actionEdit(_:)))
        navigationItem.rightBarButtonItems = [backButton]
        self.WSGetUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.WSGetMembershipDetails()
    }
    
    func WSGetMembershipDetails() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [GetCategoryData.user_id : UserDefaults.standard.value(forKey: "custid") as! String]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_MEMBERSHIP_DETAILS, parseApiMethod: "POST")
    }
    internal func parseDictGetAccountMembershipDetailsApi(controller:UIViewController, dictJson:NSDictionary){
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
            tableviewMyAccount.reloadData()            
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }

    
    func WSGetUserProfile() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [UserProfile.user_id : UserDefaults.standard.value(forKey: "custid") as! String]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_USERPROFILE, parseApiMethod: "POST")
    }
    internal func parseDictGetUserProfileApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
            let strFirstName = ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "first_name") is NSNull) ? "" : ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "first_name") as! String)
            dicMyProfileDetails.setValue(strFirstName, forKey: "first_name")
            
            let strEmail = ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "email") is NSNull) ? "" : ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "email") as! String)
            dicMyProfileDetails.setValue(strEmail, forKey: "email")
            
            let strPhoneNo = ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "phone") is NSNull) ? "" : ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "phone") as! String)
            dicMyProfileDetails.setValue(strPhoneNo, forKey: "phone")
            
            tableviewMyAccount.delegate = self
            tableviewMyAccount.dataSource = self
            tableviewMyAccount.reloadData()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Tableview Delegate and Datasource...
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            if UserDefaults.standard.value(forKey: "is_member") as! String == "1" {
                if UserDefaults.standard.value(forKey: "is_trial") as! String == "1" {
                    return 62.0
                }else{
                    return 100.0
                }
            }else{
                return 62.0
            }
        }else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEditCEll", for: indexPath) as!  AccountEditCEll
            if dicMyProfileDetails.value(forKey: "first_name") as! String == "" {
                cell.txtullName.placeholder = "Fullname"
                if boolEditable == false {
                    cell.txtullName.isEnabled = false
                }else{
                    cell.txtullName.isEnabled = true
                }
            }else{
                if boolEditable == false {
                    cell.txtullName.attributedText = NSAttributedString(string: (dicMyProfileDetails.value(forKey: "first_name") as! String), attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
                    cell.vwTextViewBackGround.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8823529412, blue: 0.8980392157, alpha: 1)
                    cell.txtullName.isEnabled = false
                }else{
                    cell.txtullName.attributedText = NSAttributedString(string: (dicMyProfileDetails.value(forKey: "first_name") as! String), attributes:[NSAttributedStringKey.foregroundColor: UIColor.black])
                    cell.vwTextViewBackGround.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.txtullName.isEnabled = true
                }
            }
            cell.txtullName.returnKeyType = .done
            cell.txtullName.keyboardType = .default
            cell.txtullName.autocorrectionType = .no
            cell.txtullName.isSecureTextEntry = false
            cell.txtullName.tag = 0
            cell.txtullName.delegate = self
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEditCEll", for: indexPath) as!  AccountEditCEll
            if dicMyProfileDetails.value(forKey: "email") as! String == "" {
                cell.txtullName.placeholder = "Email"
            }else{
                 cell.txtullName.attributedText = NSAttributedString(string: (dicMyProfileDetails.value(forKey: "email") as! String), attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            }
            cell.txtullName.tag = 1
            cell.txtullName.isEnabled = false
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEditCEll", for: indexPath) as!  AccountEditCEll
            if dicMyProfileDetails.value(forKey: "phone") as! String == "" {
                cell.txtullName.placeholder = "Phone"
                if boolEditable == false {
                    cell.txtullName.isEnabled = false
                }else{
                    cell.txtullName.isEnabled = true
                }
            }else{
                if boolEditable == false {
                    cell.txtullName.attributedText = NSAttributedString(string: (dicMyProfileDetails.value(forKey: "phone") as! String), attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
                    cell.vwTextViewBackGround.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8823529412, blue: 0.8980392157, alpha: 1)
                    cell.txtullName.isEnabled = false
                }else{
                    cell.txtullName.attributedText = NSAttributedString(string: (dicMyProfileDetails.value(forKey: "phone") as! String), attributes:[NSAttributedStringKey.foregroundColor: UIColor.black])
                    cell.vwTextViewBackGround.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.txtullName.isEnabled = true
                }
            }
            cell.txtullName.returnKeyType = .done
            cell.txtullName.keyboardType = .default
            cell.txtullName.autocorrectionType = .no
            cell.txtullName.isSecureTextEntry = false
            cell.txtullName.tag = 2
            cell.txtullName.delegate = self
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MembersgipCell", for: indexPath) as! MembersgipCell
            if UserDefaults.standard.value(forKey: "is_member") as! String == "1" {
                if UserDefaults.standard.value(forKey: "is_trial") as! String == "1" {
                    cell.constaintMembershipHeight.constant = 0.0
                    cell.lblMembership.text = ""
                    cell.btnCancelMembership.setTitle("Running Trial Period", for: .normal)
                }else{
                    cell.constaintMembershipHeight.constant = 29.0
                    let strMemberShipAmount = (UserDefaults.standard.value(forKey: "transaction_amount") as! String)
                    cell.lblMembership.text = "Membership - $" + strMemberShipAmount + "/Year - Unlimited Balloons"
                    cell.lblMembership.textColor = UIColor.white
                    cell.btnCancelMembership.setTitle("Cancel Membership", for: .normal)
                }
            }else{
                cell.constaintMembershipHeight.constant = 0.0
                cell.btnCancelMembership.setTitle("Become A Member", for: .normal)
            }
            
//            if UserDefaults.standard.value(forKey: "is_member") as! String == "1" {
//                if intTrialTrack == 0 {
//                    cell.constaintMembershipHeight.constant = 0.0
//                    cell.lblMembership.text = ""
//                    cell.btnCancelMembership.setTitle("Running Trial Period", for: .normal)
//                }else{
//                    cell.constaintMembershipHeight.constant = 29.0
//                    cell.lblMembership.text = "Membership - $3.99/Year - Unlimited Balloons"
//                    cell.lblMembership.textColor = UIColor.white
//                    cell.btnCancelMembership.setTitle("Cancel Membership", for: .normal)
//                }
//            }else{
//                if UserDefaults.standard.value(forKey: "is_trial") as! String == "1" {
//                    cell.constaintMembershipHeight.constant = 0.0
//                    cell.btnCancelMembership.setTitle("Running Trial Period", for: .normal)
//                }else{
//                    cell.constaintMembershipHeight.constant = 0.0
//                    cell.btnCancelMembership.setTitle("Become A Member", for: .normal)
//                }
//            }
            cell.btnCancelMembership.addTarget(self, action: #selector(cancelMember(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    @objc func actionEdit(_ btn:UIBarButtonItem) {
        self.view.endEditing(true)
        if boolEditable == false {
            boolEditable = true
            navigationItem.rightBarButtonItem?.image = UIImage(named: "save-txt")
            self.tableviewMyAccount.reloadData()
        }else{
            boolEditable = false
            navigationItem.rightBarButtonItem?.image = UIImage(named: "edit-txt")
            self.tableviewMyAccount.reloadData()
            WSGetUserInfoUpdate()
        }
    }
    
    //MARK:Textfield delegate and Datasource...
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let strFirstName = tableviewMyAccount.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AccountEditCEll
            dicMyProfileDetails.setValue(strFirstName.txtullName.text, forKey: "first_name")
            strFirstName.txtullName.resignFirstResponder()
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableviewMyAccount.reloadRows(at: [indexPath], with: .none)
        }else if textField.tag == 2 {
            let strPhone = tableviewMyAccount.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! AccountEditCEll
            dicMyProfileDetails.setValue(strPhone.txtullName.text, forKey: "phone")
            strPhone.txtullName.resignFirstResponder()
            let indexPath = IndexPath(item: 2, section: 0)
            self.tableviewMyAccount.reloadRows(at: [indexPath], with: .none)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            let strFirstName = tableviewMyAccount.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! AccountEditCEll
            dicMyProfileDetails.setValue(strFirstName.txtullName.text, forKey: "first_name")
            strFirstName.txtullName.resignFirstResponder()
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableviewMyAccount.reloadRows(at: [indexPath], with: .none)
        }else if textField.tag == 2 {
            let strPhone = tableviewMyAccount.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! AccountEditCEll
            dicMyProfileDetails.setValue(strPhone.txtullName.text, forKey: "phone")
            strPhone.txtullName.resignFirstResponder()
            let indexPath = IndexPath(item: 2, section: 0)
            self.tableviewMyAccount.reloadRows(at: [indexPath], with: .none)
        }
        return true
    }
    func WSGetUserInfoUpdate() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [UserProfile.user_id : UserDefaults.standard.value(forKey: "custid") as! String,UserProfile.first_name : dicMyProfileDetails.value(forKey: "first_name") as! String, UserProfile.phone : dicMyProfileDetails.value(forKey: "phone") as! String]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_PROFILE_UPDATE, parseApiMethod: "POST")
    }
    internal func parseDictUserProfileUpdateApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
    }
    func showAlertWithPop(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @objc func cancelMember(_ btn:UIButton) {
        if UserDefaults.standard.value(forKey: "is_member") as! String == "1" {
            if UserDefaults.standard.value(forKey: "is_trial") as! String == "0" {
                self.userLogOut()
            }
        }else{
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
        
        
        
//        if UserDefaults.standard.value(forKey: "is_trial") as! String == "0" {
//            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
//            let Params:[String:String]! = [UserProfile.user_id : UserDefaults.standard.value(forKey: "custid") as! String]
//            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_CANCEL_MEMBERSHIP, parseApiMethod: "POST")
//        }else{
//            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
//            self.navigationController?.pushViewController(controllerObj, animated: true)
//        }
    }
    internal func parseDictCancelMemberShipApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            UserDefaults.standard.setValue("1", forKey: "is_trial")
            self.showAlertWithPop1(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
    }
    
    func showAlertWithPop1(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.tableviewMyAccount.reloadData()
            let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
            self.navigationController?.pushViewController(viewControllerObj, animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
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
        if ageHours! < 168 {
            intTrialTrack = 0
        }else{
            intTrialTrack = 1
        }
    }
    
    func userLogOut() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Are you sure you want to cancel your membership?", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params:[String:String]! = [UserProfile.user_id : UserDefaults.standard.value(forKey: "custid") as! String]
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_CANCEL_MEMBERSHIP, parseApiMethod: "POST")
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

