//
//  RecipientDetailsViewController.swift
//  E Balloon
//
//  Created by VAP on 04/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class PersonalInformationCell:UITableViewCell{
    @IBOutlet weak var lblPersonalInformation: UILabel!
}
class PresonalDEtailsCell:UITableViewCell{
    @IBOutlet weak var txtDetails: UITextField!
}
class PrmiderOnformationCell:UITableViewCell{
    @IBOutlet weak var lblRemainder: UILabel!
}
class PrmiderOnformation:UITableViewCell{
    @IBOutlet weak var btnCalender: UIButton!
    @IBOutlet weak var lblDateShow: UILabel!
}
class saveCell:UITableViewCell{
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblRemind: UILabel!
    @IBOutlet weak var btnSave: UIButton!
}


class RecipientDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var tableviewRecipientDetails: UITableView!
    
    var strDate:String = ""
    var reminderList:Bool = false
    var SaveDic:NSMutableDictionary = NSMutableDictionary()
    var dicUserInfo:NSDictionary = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Recipient Details"
        self.navigationBarSetup()
        
        tableviewRecipientDetails.delegate = self
        tableviewRecipientDetails.dataSource = self
        tableviewRecipientDetails.reloadData()
    }
    func gettingValue() {
        if dicUserInfo.value(forKey: "address") == nil {
            SaveDic.setValue("", forKey: "first_name")
            SaveDic.setValue("", forKey: "last_name")
            SaveDic.setValue("", forKey: "email")
            SaveDic.setValue("", forKey: "phone")
            SaveDic.setValue("", forKey: "city")
            SaveDic.setValue("", forKey: "state")
            SaveDic.setValue("", forKey: "event")
            SaveDic.setValue("", forKey: "event_date")
            SaveDic.setValue("0", forKey: "is_remind")
            SaveDic.setValue("0", forKey: "add_Address")
        }else{
            SaveDic.setValue((dicUserInfo.value(forKey: "name") is NSNull ? "" : dicUserInfo.value(forKey: "name") as! String), forKey: "first_name")
            SaveDic.setValue((dicUserInfo.value(forKey: "lst_name") is NSNull ? "" : dicUserInfo.value(forKey: "lst_name") as! String), forKey: "last_name")
            SaveDic.setValue((dicUserInfo.value(forKey: "email") is NSNull ? "" : dicUserInfo.value(forKey: "email") as! String), forKey: "email")
            SaveDic.setValue((dicUserInfo.value(forKey: "number") is NSNull ? "" : dicUserInfo.value(forKey: "number") as! String), forKey: "phone")
            SaveDic.setValue((dicUserInfo.value(forKey: "city") is NSNull ? "" : dicUserInfo.value(forKey: "city") as! String), forKey: "city")
            SaveDic.setValue((dicUserInfo.value(forKey: "state") is NSNull ? "" : dicUserInfo.value(forKey: "state") as! String), forKey: "state")
            SaveDic.setValue((dicUserInfo.value(forKey: "event_name") is NSNull ? "" : dicUserInfo.value(forKey: "event_name") as! String), forKey: "event")
            SaveDic.setValue((dicUserInfo.value(forKey: "remind_date") is NSNull ? "" : dicUserInfo.value(forKey: "remind_date") as! String), forKey: "event_date")
            SaveDic.setValue((dicUserInfo.value(forKey: "is_remind") is NSNull ? "" : dicUserInfo.value(forKey: "is_remind") as! String), forKey: "is_remind")
            SaveDic.setValue((dicUserInfo.value(forKey: "id") is NSNull ? "" : dicUserInfo.value(forKey: "id") as! String), forKey: "address_book_id")
            SaveDic.setValue("1", forKey: "add_Address")
        }
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        strDate = dateformatter.string(from: currentDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.gettingValue()
    }
    
    
    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 36.0
        }else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
            return 52.0
        }else if indexPath.row == 3 || indexPath.row == 8{
            return 44.0
        }else if indexPath.row == 9 || indexPath.row == 10 {
            return 56.0
        }else if indexPath.row == 11{
            return 120.0
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInformationCell", for: indexPath) as!  PersonalInformationCell
            cell.selectionStyle = .none
            return cell
        }else if indexPath .row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "first_name") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "first_name") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .default
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 0
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "last_name") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "last_name") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .default
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 1
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalInformationCell", for: indexPath) as!  PersonalInformationCell
            cell.lblPersonalInformation.text = "Contact Information"
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "email") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "email") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .emailAddress
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 2
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "phone") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "Phone No",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "phone") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .phonePad
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 3
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "city") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "City",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "city") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .default
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 4
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "state") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "State",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "state") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .default
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 5
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrmiderOnformationCell", for: indexPath) as!  PrmiderOnformationCell
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PresonalDEtailsCell", for: indexPath) as!  PresonalDEtailsCell
            if SaveDic.value(forKey: "event") as! String == "" {
                cell.txtDetails.attributedPlaceholder = NSAttributedString(string: "Purpose/Event",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.txtDetails.text = SaveDic.value(forKey: "event") as? String
            }
            cell.txtDetails.returnKeyType = UIReturnKeyType.next
            cell.txtDetails.keyboardType = .default
            cell.txtDetails.autocorrectionType = .no
            cell.txtDetails.isSecureTextEntry = false
            cell.txtDetails.tag = 6
            cell.txtDetails.isEnabled = true
            cell.txtDetails.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrmiderOnformation", for: indexPath) as!  PrmiderOnformation
            if SaveDic.value(forKey: "event_date") as! String == "" {
                cell.lblDateShow.attributedText = NSAttributedString(string: "Reminder Me",attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            }else{
                cell.lblDateShow.attributedText = NSAttributedString(string: (SaveDic.value(forKey: "event_date") as? String)!,attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
            }
            cell.lblDateShow.isUserInteractionEnabled = true
            cell.lblDateShow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.datePickerCall(_:))))
            cell.btnCalender.setImage(#imageLiteral(resourceName: "calender"), for: .normal)
            cell.btnCalender.addTarget(self, action: #selector(self.datePickerCall(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "saveCell", for: indexPath) as!  saveCell
            
            if SaveDic.value(forKey: "is_remind") as! String == "0" {
                cell.btnCheck.backgroundColor = UIColor(patternImage: UIImage(named: "chk2")!)
            }else{
                cell.btnCheck.backgroundColor = UIColor(patternImage: UIImage(named: "chk1")!)
            }
            cell.btnCheck.addTarget(self, action: #selector(Remindtion(_:)), for: .touchUpInside)
            cell.btnSave.addTarget(self, action: #selector(Saveaction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "saveCell", for: indexPath) as!  saveCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    @objc func Remindtion(_ btn : UIButton){
        if SaveDic.value(forKey: "is_remind") as! String == "0" {
            SaveDic.setValue("1", forKey: "is_remind")
        }else{
            SaveDic.setValue("0", forKey: "is_remind")
        }
        let indexPath = IndexPath(item: 11, section: 0)
        self.tableviewRecipientDetails.reloadRows(at: [indexPath], with: .none)
    }
    
    
    //   Date Picker
    @objc func datePickerCall(_ btn:UIButton){
        let message = "\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        let attributedString = NSAttributedString(string: "Please select date" , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14.0),NSAttributedStringKey.foregroundColor:UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)])
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        var pickerFrame: CGRect = CGRect()
        
        if UIScreen.main.bounds.size.width >= 750.0 && UIScreen.main.bounds.size.width < 1334.0 {
            pickerFrame = CGRect(x: 0, y: 0, width: 310, height: 100)
        }else{
            pickerFrame = CGRect(x: 0, y: 30, width: alert.view.bounds.size.width - 20, height: 120)
        }
        
        let datePicker = UIDatePicker(frame: pickerFrame)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = datePicker.date
        datePicker.addTarget(self, action: #selector(self.PickerDateChanged(sender:)), for: .valueChanged)
        alert.view.addSubview(datePicker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.SaveDic.setValue(self.strDate, forKey: "event_date")
            let indexPath = IndexPath(item: 10, section: 0)
            self.tableviewRecipientDetails.reloadRows(at: [indexPath], with: .none)
        })
        
        // for iPAD support:
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 30.0, width: 40.0, height: 300.0)
        
        // this is the center of the screen currently but it can be any point in the view
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    @objc func PickerDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        strDate = formatter.string(from: sender.date)
        SaveDic.setValue(strDate, forKey: "event_date")
    }
    
    
    @objc func Saveaction(_ btn : UIButton){
        self.view.endEditing(true)
        if SaveDic.value(forKey: "first_name") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_FIRST_NAME)
        }else if SaveDic.value(forKey: "last_name") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_LAST_NAME)
        }else if SaveDic.value(forKey: "email") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_EMAIL)
        }else if !(SaveDic.value(forKey: "email") as! String).isEmail() {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_CORRECT_EMAIL)
        }else if SaveDic.value(forKey: "phone") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PH_NO)
        }else if SaveDic.value(forKey: "city") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_CITY)
        }else if SaveDic.value(forKey: "state") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_STATE)
        }else if SaveDic.value(forKey: "event") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_EVENT_NAME)
        }else if SaveDic.value(forKey: "event_date") as! String == "" {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_EVENT_DATE)
        }else{
            self.locationSaveApiCall()
        }
    }
    
    func locationSaveApiCall() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        if SaveDic.value(forKey: "add_Address") as! String == "0" {
            let Params : [String:String]! = [RecipientDetails.first_name : (SaveDic.value(forKey: "first_name") as! String),
                                             RecipientDetails.last_name : (SaveDic.value(forKey: "last_name") as! String),
                                             RecipientDetails.email : (SaveDic.value(forKey: "email") as! String),
                                             RecipientDetails.phone : (SaveDic.value(forKey: "phone") as! String),
                                             RecipientDetails.city : (SaveDic.value(forKey: "city") as! String),
                                             RecipientDetails.state : (SaveDic.value(forKey: "state") as! String),
                                             RecipientDetails.event : (SaveDic.value(forKey: "event") as! String),
                                             RecipientDetails.event_date : (SaveDic.value(forKey: "event_date") as! String),
                                             RecipientDetails.user_id : UserDefaults.standard.value(forKey: "custid") as! String,
                                             RecipientDetails.remind_me : (SaveDic.value(forKey: "is_remind") as! String == "1" ? "on" : "")]
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_RECIPITIENTDETAILS, parseApiMethod: "POST")
        }else{
            let Params : [String:String]! = [RecipientDetails.first_name : (SaveDic.value(forKey: "first_name") as! String),
                                             RecipientDetails.last_name : (SaveDic.value(forKey: "last_name") as! String),
                                             RecipientDetails.email : (SaveDic.value(forKey: "email") as! String),
                                             RecipientDetails.phone : (SaveDic.value(forKey: "phone") as! String),
                                             RecipientDetails.city : (SaveDic.value(forKey: "city") as! String),
                                             RecipientDetails.state : (SaveDic.value(forKey: "state") as! String),
                                             RecipientDetails.event : (SaveDic.value(forKey: "event") as! String),
                                             RecipientDetails.event_date : (SaveDic.value(forKey: "event_date") as! String),
                                             RecipientDetails.remind_me : (SaveDic.value(forKey: "is_remind") as! String == "1" ? "on" : ""),
                                             RecipientDetails.address_book_id : SaveDic.value(forKey: "address_book_id") as! String]
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_ADDRESS_EDIT, parseApiMethod: "POST")
        }
    }

    
    // MARK : Webservice call return result
    internal func parseDictSaveApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            if SaveDic.value(forKey: "add_Address") as! String == "0" {
                self.showAlertWithPop(message: "Address sucessfully added.")
            }else{
                self.showAlertWithPop(message: "Address sucessfully updated.")
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
        }
    }
    
    func showAlertWithPop(message:String) {
        self.view.endEditing(true)
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 0){
            SaveDic.setValue(textField.text, forKey: "first_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 1){
            SaveDic.setValue(textField.text, forKey: "last_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 2){
            SaveDic.setValue(textField.text, forKey: "email")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 3){
            SaveDic.setValue(textField.text, forKey: "phone")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 4){
            SaveDic.setValue(textField.text, forKey: "city")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 6, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 5){
            SaveDic.setValue(textField.text, forKey: "state")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 8, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 6){
            SaveDic.setValue(textField.text, forKey: "event")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 9, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            SaveDic.setValue(textField.text, forKey: "first_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 1){
            SaveDic.setValue(textField.text, forKey: "last_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 2){
            SaveDic.setValue(textField.text, forKey: "email")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 3){
            SaveDic.setValue(textField.text, forKey: "phone")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 6, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 4){
            SaveDic.setValue(textField.text, forKey: "city")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 7, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 5){
            SaveDic.setValue(textField.text, forKey: "state")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 9, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.becomeFirstResponder()
        }else if (textField.tag == 6){
            SaveDic.setValue(textField.text, forKey: "event")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 9, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField.tag == 0){
            SaveDic.setValue(textField.text, forKey: "first_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 1){
            SaveDic.setValue(textField.text, forKey: "last_name")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 2, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 2){
            SaveDic.setValue(textField.text, forKey: "email")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 4, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 3){
            SaveDic.setValue(textField.text, forKey: "phone")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 5, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 4){
            SaveDic.setValue(textField.text, forKey: "city")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 6, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 5){
            SaveDic.setValue(textField.text, forKey: "state")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 7, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else if (textField.tag == 6){
            SaveDic.setValue(textField.text, forKey: "event")
            let strTxtField = tableviewRecipientDetails.cellForRow(at: NSIndexPath(row: 9, section: 0) as IndexPath) as! PresonalDEtailsCell
            strTxtField.txtDetails.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
    
}
