//
//  ForgotPasswordViewController.swift
//  E Balloon
//
//  Created by VAP on 06/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate{
   
    @IBOutlet weak var tableviewForgotPassword: UITableView!
    var dicForgotPassword:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forgot Password"
        navigationBarSetup()
        tableviewForgotPassword.delegate = self
        tableviewForgotPassword.dataSource = self
        tableviewForgotPassword.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let mainViewController = sideMenuController!
        mainViewController.panGesture.isEnabled = false
    }

    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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
            return 1
        } else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 270.0
        }else if indexPath.section == 1 {
            return 60.0
        }else{
            return 100.0
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
                if dicForgotPassword.value(forKey: "email_id") == nil {
                    cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                }else{
                    cell.txtEmail.text = dicForgotPassword.value(forKey: "email_id") as? String
                }
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Email.png") ,for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = false
                cell.txtEmail.tag = 0
                cell.txtEmail.isEnabled = true
                cell.txtEmail.delegate = self
            }
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUptableviewCell", for: indexPath) as!  SignUptableviewCell
            cell.btnSignUp.addTarget(self, action: #selector(self.submitAction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // MARK : textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 0){
            let UserName = tableviewForgotPassword.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            dicForgotPassword.setValue(textField.text!, forKey: "email_id")
            UserName.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            let UserName = tableviewForgotPassword.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            dicForgotPassword.setValue(textField.text!, forKey: "email_id")
            UserName.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func submitAction(_ btn:UIButton) {
        self.tableviewForgotPassword.endEditing(true)
        if dicForgotPassword.value(forKey: "email_id") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_EMAIL)
        }else if !((dicForgotPassword.value(forKey: "email_id") as? String)?.isEmail())! {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_CORRECT_EMAIL)
        }else{
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params:[String:String]! = [Login.email_id : dicForgotPassword.value(forKey: "email_id") as! String]
            print(Params)
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_FORGOT_PASSWORD, parseApiMethod: "POST")
        }
    }
    
    internal func parseDictForgotPasswordApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let sucessMsg = (dictJson.value(forKey: "message") is NSNull) ? "" : (dictJson.value(forKey: "message") as! String)
            let actionSheetController:UIAlertController = UIAlertController(title: "",  message: sucessMsg, preferredStyle: .alert)
            let cancelAction:UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
                self.navigationController?.popViewController(animated: true)
            }
            actionSheetController.addAction(cancelAction)
            controller.present(actionSheetController, animated: true, completion: nil)
        }else{
            let Password = tableviewForgotPassword.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            Password.txtEmail.text = ""
            let errorMsg = (dictJson.value(forKey: "message") is NSNull) ? "" : (dictJson.value(forKey: "message") as! String)
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
}
