//
//  SignUpViewController.swift
//  E Balloon
//
//  Created by VAP on 06/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SignUptableviewCell:UITableViewCell{
    @IBOutlet weak var btnSignUp: UIButton!
}
class TermsNConditionCell:UITableViewCell {
    @IBOutlet weak var btnAgreeSelection: UIButton!
    @IBOutlet weak var lblAgreeCondition: UILabel!
}


class SignUpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GIDSignInUIDelegate {

    @IBOutlet weak var tableviewSignUp: UITableView!
    var dictSignUp:NSMutableDictionary = NSMutableDictionary()
    var myAccountViewController = MyAccountViewController()
    
    var boolTermsNCondition:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(self.googleSignUpLogData), name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE_SIGNUP"), object: nil)
        
        tableviewSignUp.delegate = self
        tableviewSignUp.dataSource = self
        tableviewSignUp.reloadData()

    }
    func navigationBarSetUp() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Sign up"
        let mainViewController = sideMenuController!
        mainViewController.panGesture.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 1{
            return 4
        } else if section == 2{
            return 2
        } else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 146.0
        }else if indexPath.section == 1 {
            return 57.0
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 34.0
            }else{
                return 95.0
            }
        }else{
            return 121.0
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
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                cell.btnEmail.setImage(#imageLiteral(resourceName: "name.png") ,for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = false
                cell.txtEmail.tag = 0
                cell.txtEmail.isEnabled = true
                
                let v = cell.txtEmail.inputAccessoryView as? IQToolbar
                v?.doneBarButton.tintColor = UIColor.clear
                v?.doneBarButton.isEnabled = false
                cell.txtEmail.delegate = self
            }else if indexPath.row == 1 {
                
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                        attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Email.png"), for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .emailAddress
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = false
                cell.txtEmail.tag = 1
                cell.txtEmail.isEnabled = true
                
                let v = cell.txtEmail.inputAccessoryView as? IQToolbar
                v?.doneBarButton.tintColor = UIColor.clear
                v?.doneBarButton.isEnabled = false
                cell.txtEmail.delegate = self
            }else if indexPath.row == 2 {
                
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Password.png"), for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = true
                cell.txtEmail.tag = 2
                cell.txtEmail.isEnabled = true
                
                let v = cell.txtEmail.inputAccessoryView as? IQToolbar
                v?.doneBarButton.tintColor = UIColor.clear
                v?.doneBarButton.isEnabled = false
                cell.txtEmail.delegate = self
            }else{
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                cell.btnEmail.setImage(#imageLiteral(resourceName: "Password.png"), for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.done
                cell.txtEmail.keyboardType = .default
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = true
                cell.txtEmail.tag = 3
                cell.txtEmail.isEnabled = true
                let v = cell.txtEmail.inputAccessoryView as? IQToolbar
                v?.doneBarButton.tintColor = UIColor.clear
                v?.doneBarButton.isEnabled = false
                cell.txtEmail.delegate = self
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TermsNConditionCell", for: indexPath) as! TermsNConditionCell
                if boolTermsNCondition == false {
                    cell.btnAgreeSelection.setImage(UIImage(named: "white_chk2"), for: .normal)
                }else{
                    cell.btnAgreeSelection.setImage(UIImage(named: "white_chk1"), for: .normal)
                }
                cell.btnAgreeSelection.addTarget(self, action: #selector(selectTermsNCondition(_:)), for: .touchUpInside)
                cell.lblAgreeCondition.isUserInteractionEnabled = true
                cell.lblAgreeCondition.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTerms(_:))))
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SignUptableviewCell", for: indexPath) as!  SignUptableviewCell
                cell.btnSignUp.addTarget(self, action: #selector(SignUpViewController.SignUpAction(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpCell", for: indexPath) as!  SignUpCell
            cell.BtnImageFacebook.addTarget(self, action: #selector(facebookSignIn(_:)), for: .touchUpInside)
            cell.btnImageLinkedin.addTarget(self, action: #selector(googleLogin(_:)), for: .touchUpInside)
            cell.lblHaveAccount.isUserInteractionEnabled = true
            cell.lblHaveAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionSignIn(_:))))
            cell.selectionStyle = .none
            return cell
        }
    }
    @objc func selectTermsNCondition(_ btn:UIButton) {
        if boolTermsNCondition == false {
            boolTermsNCondition = true
        }else{
            boolTermsNCondition = false
        }
        let indexpath = IndexPath(item: 0, section: 2)
        self.tableviewSignUp.reloadRows(at: [indexpath], with: .automatic)
    }
    
    @objc func showTerms(_ gesture:UITapGestureRecognizer) {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        present(controllerObj, animated: true, completion: nil)
    }
    
    
    @objc func SignUpAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if dictSignUp.value(forKey: "name") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_NAME)
        }else if dictSignUp.value(forKey: "email") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PASSWORD)
        }else if !((dictSignUp.value(forKey: "email") as? String)?.isEmail())! {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_CORRECT_EMAIL)
        }else if ((dictSignUp.value(forKey: "password") as? String)?.length)! < 6 {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PASSWORD_LIMIT)
        }else if dictSignUp.value(forKey: "conf_pass") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PASSWORD)
        }else if (dictSignUp.value(forKey: "password") as? String) != (dictSignUp.value(forKey: "conf_pass") as? String) {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_MISMATCHED_PASSWORD)
        }else if boolTermsNCondition == false {
            SharedFunctions.ShowAlert(controller: self, message: "Please agree terms and conditions.")
        }else{
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            
            let Params : [String:String]! = [SignUp.name : (dictSignUp.value(forKey: "name") as! String),
                                             SignUp.email : (dictSignUp.value(forKey: "email") as! String),
                                             SignUp.password : (dictSignUp.value(forKey: "password") as! String),
                                             SignUp.conf_pass : (dictSignUp.value(forKey: "conf_pass") as! String)]
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_SignUp, parseApiMethod: "POST")
        }
    }
    // MARK : Webservice call return result
    internal func parseDictSignUpApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
            
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
            let Password = tableviewSignUp.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            Password.txtEmail.text = ""
            
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 0){
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "name")
            }else{
                dictSignUp.removeObject(forKey: "name")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.resignFirstResponder()
            
        }else if (textField.tag == 1){
            
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "email")
            }else{
                dictSignUp.removeObject(forKey: "email")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.resignFirstResponder()
            
        }else if (textField.tag == 2){
            
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "password")
            }else{
                dictSignUp.removeObject(forKey: "password")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.resignFirstResponder()
            
        }else if (textField.tag == 3){
            
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "conf_pass")
            }else{
                dictSignUp.removeObject(forKey: "conf_pass")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 3, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.resignFirstResponder()
            
        }else{
            textField.resignFirstResponder()
        }
    }
    
    // to get return value from text field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "name")
            }else{
                dictSignUp.removeObject(forKey: "name")
            }
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.becomeFirstResponder()
            
        }else if (textField.tag == 1){
            
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "email")
            }else{
                dictSignUp.removeObject(forKey: "email")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.becomeFirstResponder()
            
        }else if (textField.tag == 2){
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "password")
            }else{
                dictSignUp.removeObject(forKey: "password")
            }
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 3, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.becomeFirstResponder()
            
        }else if (textField.tag == 3){
            
            if !(textField.text?.isEmpty)!{
                dictSignUp.setValue(textField.text, forKey: "conf_pass")
            }else{
                dictSignUp.removeObject(forKey: "conf_pass")
            }
            
            let strTxtField = tableviewSignUp.cellForRow(at: NSIndexPath(row: 3, section: 1) as IndexPath) as! SignInCell
            strTxtField.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func actionSignIn(_ gesture:UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertWithPop(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func facebookSignIn(_ btn:UIButton) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        UIApplication.shared.statusBarStyle = .default
        UserDefaults.standard.setValue("facebook", forKey: "loginSocial")
        FB.getFaceBookInfo(Controller: self)
    }
    
    //FB in WS Call
    func SignUpFacebookGetResult (result:AnyObject!) {
        if (result != nil) {
            var emailId:String = String()
            var firstName:String = String()
            var lastName:String = String()
            var url:String = String()
            
            let obj = result as! NSDictionary
            print(obj)
            
            if obj.value(forKey: "email") != nil {
                emailId = obj.value(forKey: "email") as! String
            }else{
                emailId = ""
            }
            
            if ((obj.value(forKey: "picture") as? AnyObject)?.value(forKey: "data") as? AnyObject)?.value(forKey: "url") != nil {
                url = ((obj.value(forKey: "picture") as? AnyObject)?.value(forKey: "data") as? AnyObject)?.value(forKey: "url") as! String
            }else{
                url = ""
            }
            
            if obj.value(forKey: "name") != nil{
                var name:String = String()
                name = obj.value(forKey: "name") as! String
                let fullNameArr = name.components(separatedBy: " ")
                firstName = fullNameArr[0]
                lastName = fullNameArr[1]
            }
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            
            print(emailId)
            print(obj.value(forKey: "id") as! String)
            print(firstName)
            print(lastName)
            print(url)
            
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params : [String:String]! = [SocialLogin.oauth_type : "facebook",SocialLogin.oauth_uid : obj.value(forKey: "id") as! String,SocialLogin.first_name : (firstName != "") ? (firstName) :  "" , SocialLogin.last_name : (lastName != "") ? (lastName) :  "" , SocialLogin.email : emailId]
            
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_SOCIAL_LOGIN, parseApiMethod: "POST")
        }else{
            print("error occurs")
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
            SharedFunctions.ShowAlert(controller: self, message:Messages.ERROR_OCCURS)
        }
    }
    
    internal func parseDictFacebookLoginApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let strUserId:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "cust_id") as! String)
            UserDefaults.standard.set(strUserId, forKey: "custid")
            
            let strUserCreateData:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "created_at") as! String)
            UserDefaults.standard.set(strUserCreateData, forKey: "created_at")
            
            let strUserEmail:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "email") as! String)
            UserDefaults.standard.set(strUserEmail, forKey: "Email_Id")
            
            let strFirstName:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "first_name") as! String)
            UserDefaults.standard.set(strFirstName, forKey: "firstName")
            
            let strMemberId:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_member") as! String)
            UserDefaults.standard.set(strMemberId, forKey: "is_member")
            
            let strPhoneNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "phone") as! String)
            UserDefaults.standard.set(strPhoneNumber, forKey: "phone")
            
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else if SharedGlobalVariables.selectedViewController == "Membership" {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberShip"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else{
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
    
    
    //MARK: Google SignIn...
    @objc func googleLogin(_ btn: UIButton) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        UIApplication.shared.statusBarStyle = .default
        UserDefaults.standard.setValue("google", forKey: "loginSocial")
        SharedGlobalVariables.GoogleLogInContollerCheck = 2
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func googleSignUpLogData(object:NSNotification){
        let userInfo : NSDictionary = object.userInfo! as NSDictionary
        print(userInfo)
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        if (userInfo.value(forKey: "userId") != nil) {
            googleSignInLogServiceCall(userInfo: userInfo)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
            SharedFunctions.ShowAlert(controller: self, message:userInfo.value(forKey: "statusText") as! String)
        }
    }
    
    func googleSignInLogServiceCall(userInfo: NSDictionary) {
        NotificationCenter.default.removeObserver(self)
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        var firstName:String = String()
        var lastName:String = String()
        var emailId:String = String()
        
        if userInfo.value(forKey: "userName") != nil{
            var name:String = String()
            name = userInfo.value(forKey: "userName") as! String
            let fullNameArr = name.components(separatedBy: " ")
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
            emailId = userInfo.value(forKey: "userEmail") as! String
        }
        
        let Params : [String:String]! = [SocialLogin.oauth_type : "google",SocialLogin.oauth_uid : userInfo.value(forKey: "userId") as! String,SocialLogin.first_name : (firstName != "") ? (firstName) :  "" , SocialLogin.last_name : (lastName != "") ? (lastName) :  "" , SocialLogin.email : emailId]
        
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_SOCIAL_LOGIN, parseApiMethod: "POST")
    }
    
    
    internal func parseDictSignUPGoogleApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let strUserId:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "cust_id") as! String)
            UserDefaults.standard.set(strUserId, forKey: "custid")
            
            let strUserCreateData:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "created_at") as! String)
            UserDefaults.standard.set(strUserCreateData, forKey: "created_at")
            
            let strUserEmail:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "email") as! String)
            UserDefaults.standard.set(strUserEmail, forKey: "Email_Id")
            
            let strFirstName:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "first_name") as! String)
            UserDefaults.standard.set(strFirstName, forKey: "firstName")
            
            let strMemberId:String = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_member") as! String)
            UserDefaults.standard.set(strMemberId, forKey: "is_member")
            
            let strPhoneNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "phone") as! String)
            UserDefaults.standard.set(strPhoneNumber, forKey: "phone")
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else if SharedGlobalVariables.selectedViewController == "Membership" {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberShip"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else{
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
}
