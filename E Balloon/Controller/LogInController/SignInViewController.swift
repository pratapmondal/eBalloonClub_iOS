//
//  SignInViewController.swift
//  E Balloon
//
//  Created by VAP on 06/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class LogoImageCell:UITableViewCell{
}

class SignInCell:UITableViewCell{
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblLine: UILabel!
}

class ForgotPasswordCell:UITableViewCell{
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
}

class SignUpCell:UITableViewCell{
    @IBOutlet weak var BtnImageFacebook: UIButton!
    @IBOutlet weak var btnImageLinkedin: UIButton!
    @IBOutlet weak var lblHaveAccount: UILabel!
}


class SignInViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GIDSignInUIDelegate{
    @IBOutlet weak var tableviewsignIn: UITableView!
    var SigninDic:NSMutableDictionary = NSMutableDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(googleSignInLogData), name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE"), object: nil)
//        IQKeyboardManager.sharedManager().enable = false
//        IQKeyboardManager.sharedManager().enableAutoToolbar = false
//        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
//        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
        tableviewsignIn.delegate = self
        tableviewsignIn.dataSource = self
        tableviewsignIn.reloadData()
    }
    
    func navigationBarSetUp() {
        self.title = "Sign in"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func addMenuToScreen(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu-profile"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 23.0, height: 18.0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        let mainViewController = sideMenuController!
        menuButton.addTarget(mainViewController, action: #selector(mainViewController.showLeftViewAnimated(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SharedGlobalVariables.selectedViewController != "SendviaViewController" && SharedGlobalVariables.selectedViewController != "Membership" {
            self.addMenuToScreen()
        }else{
            print("test")
        }
//        self.navigationItem.hidesBackButton = true
//        let mainViewController = sideMenuController!
//        mainViewController.panGesture.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 1{
            return 2
        } else if section == 2{
            return 1
        } else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140.0
        }else if indexPath.section == 1 {
            return 65.0
        }else if indexPath.section == 2 {
            return 122.0
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
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                        attributes: [NSAttributedStringKey.foregroundColor
                                                                            : UIColor.white])

                cell.btnEmail.setImage(#imageLiteral(resourceName: "Email.png") ,for: .normal)
                cell.txtEmail.returnKeyType = UIReturnKeyType.next
                cell.txtEmail.keyboardType = .emailAddress
                cell.txtEmail.autocorrectionType = .no
                cell.txtEmail.isSecureTextEntry = false
                cell.txtEmail.tag = 0
                cell.txtEmail.isEnabled = true
                cell.txtEmail.delegate = self
            }else{
                cell.txtEmail.attributedPlaceholder = NSAttributedString(string: "Password",
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
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForgotPasswordCell", for: indexPath) as!  ForgotPasswordCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordaction))
            tap.numberOfTapsRequired = 1
            cell.lblForgotPassword.isUserInteractionEnabled = true
            cell.lblForgotPassword.addGestureRecognizer(tap)
            
            cell.btnLogin.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpCell", for: indexPath) as!  SignUpCell
            cell.BtnImageFacebook.addTarget(self, action: #selector(facebookLogin(_:)), for: .touchUpInside)
            cell.btnImageLinkedin.addTarget(self, action: #selector(googleLogin(_:)), for: .touchUpInside)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpaction))
            tap.numberOfTapsRequired = 1
            cell.lblHaveAccount.isUserInteractionEnabled = true
            cell.lblHaveAccount.addGestureRecognizer(tap)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func logInAction(btn : UIButton) {
        self.view.endEditing(true)
        if SigninDic.value(forKey: "email_id") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_EMAIL)
        }else if !((SigninDic.value(forKey: "email_id") as? String)?.isEmail())! {
            SharedFunctions.ShowAlert(controller: self, message: Messages.USER_CORRECT_EMAIL)
        }else if SigninDic.value(forKey: "password") == nil {
            SharedFunctions.ShowAlert(controller: self, message:Messages.USER_PASSWORD)
        }else{
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params : [String:String]! = [
                Login.email_id : (SigninDic.value(forKey: "email_id") as! String),
                Login.password : (SigninDic.value(forKey: "password") as! String)
            ]
            print(Params)
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_LOGIN, parseApiMethod: "POST")
        }
    }
    // MARK : Webservice call return result
    internal func parseDictLoginApi(controller:UIViewController, dictJson:NSDictionary){
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
            
            let strTrialNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_trial") as! String)
            UserDefaults.standard.set(strTrialNumber, forKey: "is_trial")
            
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else if SharedGlobalVariables.selectedViewController == "Membership" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberShip"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else{
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
            let Password = tableviewsignIn.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            Password.txtEmail.text = ""
            
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
    // MARK : textField 
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.tag == 0){
            let UserName = tableviewsignIn.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "email_id")
            UserName.txtEmail.resignFirstResponder()
        }else if (textField.tag == 1){
            let Password = tableviewsignIn.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "password")
            Password.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 0){
            let UserName = tableviewsignIn.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "email_id")
            UserName.txtEmail.becomeFirstResponder()
        }else if (textField.tag == 1){
            let Password = tableviewsignIn.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "password")
            Password.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 0 {
            let UserName = tableviewsignIn.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "email_id")
            UserName.txtEmail.resignFirstResponder()
        }else if textField.tag == 1 {
            let Password = tableviewsignIn.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as! SignInCell
            SigninDic.setValue(textField.text!, forKey: "password")
            Password.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
  
    
    @objc func ForgotPasswordaction() {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    @objc func SignUpaction() {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableviewsignIn.endEditing(true)
    }
    //MARK:Facebook login...
    @objc func facebookLogin(_ btn:UIButton) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        UIApplication.shared.statusBarStyle = .default
        UserDefaults.standard.setValue("facebook", forKey: "loginSocial")
        FB.getFaceBookInfo(Controller: self)
    }
    
    //FB in WS Call
    func FacebookGetResult (result:AnyObject!) {
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
            
            let strTrialNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_trial") as! String)
            UserDefaults.standard.set(strTrialNumber, forKey: "is_trial")
            
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil)
            }else if SharedGlobalVariables.selectedViewController == "Membership" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberShip"), object: nil, userInfo: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil)
            }else{
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil)
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }

        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
  
    //MARK:Google login...
    @objc func googleLogin(_ btn:UIButton) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        UIApplication.shared.statusBarStyle = .default
        UserDefaults.standard.setValue("google", forKey: "loginSocial")
        SharedGlobalVariables.GoogleLogInContollerCheck = 1
        GIDSignIn.sharedInstance().signIn()
    }
    @objc func googleSignInLogData(object:NSNotification){
        let userInfo : NSDictionary = object.userInfo! as NSDictionary
        print(userInfo)
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        if (userInfo.value(forKey: "userId") != nil) {
            self.googleSignInLogServiceCall(userInfo: userInfo)
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
        var email:String = String()
        
        if userInfo.value(forKey: "userName") != nil{
            var name:String = String()
            name = userInfo.value(forKey: "userName") as! String
            let fullNameArr = name.components(separatedBy: " ")
            firstName = fullNameArr[0]
            lastName = fullNameArr[1]
            email = userInfo.value(forKey: "userEmail") as! String
        }
        
        let Params : [String:String]! = [SocialLogin.oauth_type : "google",SocialLogin.oauth_uid : userInfo.value(forKey: "userId") as! String,SocialLogin.first_name : (firstName != "") ? (firstName) :  "" , SocialLogin.last_name : (lastName != "") ? (lastName) :  "" , SocialLogin.email : email]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_SOCIAL_LOGIN, parseApiMethod: "POST")
    }
    
    
    internal func parseDictGoogleApi(controller:UIViewController, dictJson:NSDictionary){
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
            
            let strTrialNumber = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "is_trial") as! String)
            UserDefaults.standard.set(strTrialNumber, forKey: "is_trial")
            
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            }else if SharedGlobalVariables.selectedViewController == "Membership" {
                self.navigationController?.popViewController(animated: true)
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
