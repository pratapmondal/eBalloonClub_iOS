//
//  ChangePasswordViewController.swift
//  E Balloon
//
//  Created by VAP on 06/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChangePasswordViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableviewChangePassword: UITableView!
    
    var ChangePasswordDic:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        
        tableviewChangePassword.delegate = self
        tableviewChangePassword.dataSource = self
        tableviewChangePassword.reloadData()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 1{
            return 2
        } else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 258.0
        }else if indexPath.section == 1 {
            return 68.0
        }else{
            return 90.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoImageCell", for: indexPath) as!  LogoImageCell
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignInCell", for: indexPath) as! SignInCell
            
            if indexPath.row == 0 {
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Password.png") ,for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = true
                cell.txtEmail.tag = 0
                cell.txtEmail.isEnabled = true
                cell.txtEmail.delegate = self
            }else{
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Password.png"), for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = true
                cell.txtEmail.tag = 1
                cell.txtEmail.isEnabled = true
                cell.txtEmail.delegate = self
            }
            
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUptableviewCell", for: indexPath) as!  SignUptableviewCell
            
//          cell.btnSignUp.addTarget(self, action: #Selector, for: .touchupInside, for: (ChangePasswordAction))
            cell.btnSignUp.addTarget(self, action: #selector(ChangePasswordAction), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    @objc func ChangePasswordAction(btn : UIButton){
        
        self.view.endEditing(true)
        if ChangePasswordDic.value(forKey: "password") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_NEW_PASSWORD)
            
            
        }else if ChangePasswordDic.value(forKey: "confirm_password") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PASSWORD_CONFIRM)
        }else{
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params : [String:String]! = [
                ChangePassword.cust_id : UserDefaults.standard.value(forKey: "custid") as! String,
                ChangePassword.password : (ChangePasswordDic.value(forKey: "password") as! String),
                ChangePassword.confirm_password : (ChangePasswordDic.value(forKey: "confirm_password") as! String)
            ]
            print(Params)
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_CHANGE_PASSWORD, parseApiMethod: "POST")
        }
        
        
    }
    
    internal func parseDictChangePasswordApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let Password = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            Password.txtEmail.text = ""
            self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let Password = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            Password.txtEmail.text = ""
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
    
    // MARK : textField Change Password
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 0){
            let UserName = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            //strEmailAddress = textField.text!
            ChangePasswordDic.setValue(textField.text!, forKey: "password")
            UserName.txtEmail.resignFirstResponder()
        }else if (textField.tag == 1){
            let Password = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            ChangePasswordDic.setValue(textField.text!, forKey: "confirm_password")
            Password.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            let UserName = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            //strEmailAddress = textField.text!
            ChangePasswordDic.setValue(textField.text!, forKey: "password")
            UserName.txtEmail.becomeFirstResponder()
        }else if (textField.tag == 1){
            let Password = tableviewChangePassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            ChangePasswordDic.setValue(textField.text!, forKey: "confirm_password")
            Password.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func showAlertWithPop(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    

   

}
