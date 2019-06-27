//
//  SendviaViewController.swift
//  E Balloon
//
//  Created by VAP on 08/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts


class SendviaCell:UITableViewCell{
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
}
class PriceCell:UITableViewCell{
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var LblSubPrice: UILabel!
    @IBOutlet weak var btnProcressToPayment: UIButton!
}

class TextCell:UITableViewCell{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var imgPhBook: UIButton!
}
class SendViaGapCell:UITableViewCell {
}

class memberShipProcressCheckUp:UITableViewCell {
    @IBOutlet weak var memberShipProcessCheckOut: UIButton!
}


class SendviaViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableviewSendviaViewController: UITableView!
    var previousPageTacking:Int = 0
    
    var arrSendSelection:[Int] = [3]
    var userMember:Bool = false
    
    var dicSharePrice:NSDictionary = NSDictionary()
    var balloonPrice:Float = 0.0

    var dicUserSendDetails:NSMutableDictionary = NSMutableDictionary()
    var contactStore = CNContactStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(sendViaDataUpdate), name: NSNotification.Name(rawValue: "SENDVIAUPDATE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(processToCheckOut), name: NSNotification.Name("SignInTrack"), object: nil)
        self.tableviewSendviaViewController.delegate = self
        self.tableviewSendviaViewController.dataSource = self
        self.tableviewSendviaViewController.reloadData()
        
    }
    
    @objc func sendViaDataUpdate(object:NSNotification){
        arrSendSelection.removeAll()
        arrSendSelection.append(0)
        arrSendSelection.append(1)
        arrSendSelection.append(2)
        arrSendSelection.append(3)
        tableviewSendviaViewController.delegate = self
        tableviewSendviaViewController.dataSource = self
        tableviewSendviaViewController.reloadData()
    }
    
    func rightBarItemAdds() {
        let openAddressBook = UIImage(named: "addressbook")!
        let openAddressButton = UIBarButtonItem(image: openAddressBook, style: .plain, target: self, action: #selector(self.addAddress(_:)))
        navigationItem.rightBarButtonItems = [openAddressButton]
        //let navigationBarAppearace = UINavigationBar.appearance()
        //navigationBarAppearace.tintColor =
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.value(forKey: "is_member") != nil {
            self.rightBarItemAdds()
        }
        
        navigationBarSrtUp()
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
    
    func navigationBarSrtUp() {
        self.title = "Send via"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1960784314, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func WSSocialSharingPrice() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [:]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_SOCIAL_SHARING_PRICE, parseApiMethod: "POST")
    }
    internal func parseDictGetSocialSharingPriceListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
            dicSharePrice = dictJson.value(forKey: "data") as! NSDictionary
            balloonPrice = balloonPrice + Float(dicSharePrice["email_price"] as! String)!
            self.tableviewSendviaViewController.delegate = self
            self.tableviewSendviaViewController.dataSource = self
            tableviewSendviaViewController.reloadData()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
            SharedFunctions.ShowAlert(controller: self, message: "Error occur!")
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Tableview Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if arrSendSelection.contains(section) {
                return 2
            }else{
                return 1
            }
        }else if section == 3 {
            if arrSendSelection.contains(section) {
                return 3
            }else{
                return 2
            }
//        }else if section == 1 || section == 2 || section == 3 {
//            if arrSendSelection.contains(section) {
//                return 3
//            }else{
//                return 2
//            }
        }else if section == 4 {
            return 1
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    //return 56.0
                    return 0.0
                }else{
                    //return 49.0
                    return 0.0
                }
            }else{
                //return 56.0
                return 0.0
            }
        }else if indexPath.section == 4 {
            return 115.0
        }else{
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    return 15.0
                }else if indexPath.row == 1 {
                    return 56.0
                }else{
                    return 49.0
                }
            }else{
                if indexPath.row == 0 {
                    return 15.0
                }else{
                    return 56.0
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-mail")
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    if (SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") != nil ) {
                        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String == "" {
                            cell.txtEmail.text = ""
                            cell.txtEmail.placeholder = "Please Enter Recipient Email."
                        }else{
                            cell.txtEmail.text = SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as? String
                        }
                    }else{
                        cell.txtEmail.text = ""
                        cell.txtEmail.placeholder = "Please Enter Recipient Email."
                    }
                    cell.txtEmail.tag = 0
                    cell.txtEmail.keyboardType = .emailAddress
                    cell.txtEmail.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                cell.imgEmail.image = #imageLiteral(resourceName: "send-mail")
                let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                cell.lblFree.attributedText = myTitle
                cell.lblFree.textAlignment = .left
                cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                cell.btnCheck.addTarget(self, action: #selector(selectOption(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 1 {
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-fb")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") != nil {
                        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String != ""  {
                            cell.txtEmail.text = SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as? String
                        }else{
                            cell.txtEmail.text = ""
                            cell.txtEmail.placeholder = "Please Enter Recipient Name"
                        }
                    }else{
                        cell.txtEmail.text = ""
                        cell.txtEmail.placeholder = "Please Enter Recipient Name"
                    }
                    cell.txtEmail.tag = 1
                    cell.txtEmail.keyboardType = .default
                    cell.txtEmail.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-fb")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else if indexPath.section == 2 {
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-twitter")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") != nil {
                        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String == "" {
                            cell.txtEmail.text = ""
                            cell.txtEmail.placeholder = "Please Enter Recipient Name"
                        }else{
                            cell.txtEmail.text = SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as? String
                        }
                    }else{
                        cell.txtEmail.text = ""
                        cell.txtEmail.placeholder = "Please Enter Recipient Name"
                    }
                    cell.txtEmail.tag = 2
                    cell.txtEmail.keyboardType = .default
                    cell.txtEmail.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-twitter")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else if indexPath.section == 3 {
            if arrSendSelection.contains(indexPath.section) {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-call")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") != nil {
                        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as? String == "" {
                            cell.txtEmail.text = ""
                            cell.txtEmail.placeholder = "Please Enter Phone Number(xxx)xxx-xxxx"
                        }else{
                           cell.txtEmail.text = SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as? String
                        }
                    }else{
                        cell.txtEmail.text = ""
                        cell.txtEmail.placeholder = "Please Enter Phone Number(xxx)xxx-xxxx"
                    }
                    cell.imgPhBook.isUserInteractionEnabled = true
                    cell.imgPhBook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(getContactDetils(_:))))
                    cell.txtEmail.tag = 3
                    cell.txtEmail.keyboardType = .numberPad
                    cell.txtEmail.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendViaGapCell", for: indexPath) as! SendViaGapCell
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SendviaCell", for: indexPath) as!  SendviaCell
                    cell.imgEmail.image = #imageLiteral(resourceName: "send-call")
                    let myTitle = NSAttributedString(string: "Free", attributes: [NSAttributedStringKey.font:UIFont(name: "Arial", size: 17.0)!,NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.01960784314, green: 0.7058823529, blue: 0.3333333333, alpha: 1)])
                    cell.lblFree.attributedText = myTitle
                    cell.lblFree.textAlignment = .left
                    cell.btnCheck.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    cell.btnCheck.addTarget(self, action: #selector(selectOption(_ :)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "memberShipProcressCheckUp", for: indexPath) as! memberShipProcressCheckUp
            //cell.memberShipProcessCheckOut.setTitle("Send", for: .normal)
            cell.memberShipProcessCheckOut.addTarget(self, action: #selector(self.procressCheckOut), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as!  TextCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if !arrSendSelection.contains(indexPath.section) {
                    arrSendSelection.append(indexPath.section)
//                    if userMember == false{
//                        balloonPrice = balloonPrice + Float(dicSharePrice["email_price"] as! String)!
//                    }
                }else{
                    if arrSendSelection.count > 1 {
                        var valueFound:Bool = false
                        var selectIndex:Int?
                        for index in 0 ..< arrSendSelection.count {
                            let indexData = arrSendSelection[index]
                            if indexData == indexPath.section {
                                valueFound = true
                                selectIndex = index
                                break
                            }else{
                                valueFound = false
                            }
                        }
                        if valueFound == true {
                            arrSendSelection.remove(at: selectIndex!)
//                            if userMember == false {
//                                balloonPrice = balloonPrice - Float(dicSharePrice["email_price"] as! String)!
//                            }
                        }
                    }
                }
            }
        }else if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 {
            if indexPath.row == 1 {
                var indexToData:Int?
                if !arrSendSelection.contains(indexPath.section) {
//                    if userMember == false {
//                        if indexPath.section == 1 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["fb_price"] as! String)!
//                        }else if indexPath.section == 2 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["twitter_price"] as! String)!
//                        }else if indexPath.section == 3 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["linkedin_price"] as! String)!
//                        }
//                    }
                    arrSendSelection.append(indexPath.section)
                }else{
                    if arrSendSelection.count > 1 {
                        var valueFound:Bool = false
                        var selectIndex:Int?
                        for index in 0 ..< arrSendSelection.count {
                            indexToData = index
                            let indexData = arrSendSelection[index]
                            if indexData == indexPath.section {
                                valueFound = true
                                selectIndex = indexData
                                indexToData = index
                                break
                            }else{
                                valueFound = false
                            }
                        }
                        if valueFound == true {
                            if userMember == false {
//                                if selectIndex == 1 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["fb_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
//                                }else if selectIndex == 2 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["twitter_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
//                                }else if selectIndex == 3 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["linkedin_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
//                                }
                            }else{
                                if selectIndex == 1 {
                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
                                }else if selectIndex == 2 {
                                   SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
                                }else if selectIndex == 3 {
                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
                                }
                            }
                            arrSendSelection.remove(at: indexToData!)
                        }
                    }
                }
            }
        }
        self.tableviewSendviaViewController.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
        self.tableviewSendviaViewController.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .none)
    }
    //MARK: Textfield delegate...
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            let emailCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderEmailAddress")
            emailCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 1 {
            let facebaookSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderFacebookName")
            facebaookSenderCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 2 {
            let twitterSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderTwitterName")
            twitterSenderCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 3 {
            let phoneSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 3) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderPhoneName")
            phoneSenderCell.txtEmail.resignFirstResponder()
        }else{
            return textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let emailCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderEmailAddress")
            emailCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 1 {
            let facebaookSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 1) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderFacebookName")
            facebaookSenderCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 2 {
            let twitterSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderTwitterName")
            twitterSenderCell.txtEmail.resignFirstResponder()
        }else if textField.tag == 3 {
            let phoneSenderCell = tableviewSendviaViewController.cellForRow(at: NSIndexPath(row: 2, section: 3) as IndexPath) as! TextCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text, forKey: "senderPhoneName")
            phoneSenderCell.txtEmail.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    
    @objc func getContactDetils(_ gesture:UITapGestureRecognizer) {
        self.askForContactAccess()
//
//
//
//        DispatchQueue.main.async {
//            SharedGlobalVariables.arrContactListData = SharedFunctions.getContacts(filter: ContactsFilter.none, controller: self)
//        }
//        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
//        self.present(controllerObj, animated: true, completion: nil)
    }
    
    func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
                            let message = "Please allow the app to access your contacts through the Settings."
                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            }
                            alertController.addAction(dismissAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            })
            break
        case .authorized:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
            self.present(controllerObj, animated: true, completion: nil)
            break
        default:
            break
        }
    }

    
    
    @objc func procressCheckOut(){
        self.view.endEditing(true)
        SharedGlobalVariables.errorBool = true
//        if arrSendSelection.contains(0) {
//            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") == nil {
//                SharedFunctions.ShowAlert(controller: self, message: "Please provide recipient email address to continue.")
//                SharedGlobalVariables.errorBool = false
//            }else if !((SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as? String)?.isEmail())! {
//               SharedFunctions.ShowAlert(controller: self, message: "Please provider vaild email address.")
//                SharedGlobalVariables.errorBool = false
//            }
//        }
//
//
//        if arrSendSelection.contains(1)  {
//            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") == nil {
//                SharedFunctions.ShowAlert(controller: self, message: "Please provide facebook sender recipient name to continue.")
//                SharedGlobalVariables.errorBool = false
//            }else{
//                if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String == "" {
//                    SharedFunctions.ShowAlert(controller: self, message: "Please provide facebook sender recipient name to continue.")
//                    SharedGlobalVariables.errorBool = false
//                }
//            }
//        }
//
//        if arrSendSelection.contains(2) {
//            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") == nil {
//                SharedFunctions.ShowAlert(controller: self, message: "Please provide twitter sender recipient name to continue.")
//                SharedGlobalVariables.errorBool = false
//            }else{
//                if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String == "" {
//                    SharedFunctions.ShowAlert(controller: self, message: "Please provide twitter sender recipient name to continue.")
//                    SharedGlobalVariables.errorBool = false
//                }
//            }
//        }
        
        if arrSendSelection.contains(3) {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") == nil {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide phone number to continue.")
                SharedGlobalVariables.errorBool = false
            }else{
                if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as! String == "" {
                    SharedFunctions.ShowAlert(controller: self, message: "Please provide phone number to continue.")
                    SharedGlobalVariables.errorBool = false
                }
            }
        }
      
        if SharedGlobalVariables.errorBool == true {
            self.SignInTrackSelection()
        }
    }
    
    @objc func processToCheckOut() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Do you want to go next step or stay here.", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "NEXT", style: .cancel) { action -> Void in
            self.SignInTrackSelection()
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "STAY", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func SignInTrackSelection() {
        if SharedGlobalVariables.errorBool == true {
            if UserDefaults.standard.value(forKey: "is_member") == nil {
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                SharedGlobalVariables.selectedViewController = "SendviaViewController"
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }else{
                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
                    if UserDefaults.standard.value(forKey: "is_trial") as! String == "0" {
                        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
                        SharedGlobalVariables.selectedViewController = "SendviaViewController"
                        self.navigationController?.pushViewController(controllerObj, animated: true)
                    }else{
                        self.balloonOrderApiCall()
                    }
                }else{
                    self.balloonOrderApiCall()
                }
            }
        }else{
            SharedFunctions.ShowAlert(controller: self, message: "Please provide vaild sender details.")
        }
    }
    
    
    func balloonOrderApiCall() {
        var strEmailSender:String?
        var strFacebookSender:String?
        var strTwitterSender:String?
        var strPhoneSender:String?

        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String != "" {
                strEmailSender = "on"
                //SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePrice.value(forKey: "email_price") as! String), forKey: "emailSharePrice")
            }else{
                //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "emailSharePrice")
                strEmailSender = ""
            }
        }else{
            //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "emailSharePrice")
            strEmailSender = ""
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String != "" {
                strFacebookSender = "on"
//                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
//                    SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePrice["fb_price"] as! String), forKey: "facebookSharePrice")
//                }else{
//                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "facebookSharePrice")
//                }
            }else{
                strFacebookSender = ""
                //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "facebookSharePrice")
            }
        }else{
            strFacebookSender = ""
            //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "facebookSharePrice")
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String != "" {
                strTwitterSender = "on"
//                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
//                    SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePrice["twitter_price"] as! String), forKey: "twitterSharePrice")
//                }else{
//                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "twitterSharePrice")
//                }
            }else{
                strTwitterSender = ""
                //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "twitterSharePrice")
            }
        }else{
            strTwitterSender = ""
            //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "twitterSharePrice")
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as! String != "" {
                strPhoneSender = "on"
//                if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
//                    SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePrice["linkedin_price"] as! String), forKey: "linkedinSharePrice")
//                }else{
//                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "linkedinSharePrice")
//                }

            }else{
                strPhoneSender = ""
                //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "linkedinSharePrice")
            }
        }else{
            strPhoneSender = ""
            //SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "linkedinSharePrice")
        }
        
        if arrSendSelection.contains(0) {
            strEmailSender = "on"
        }else{
            strEmailSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderEmailAddress")
        }
        if arrSendSelection.contains(1) {
            strFacebookSender = "on"
        }else{
            strFacebookSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
        }
        if arrSendSelection.contains(2) {
            strTwitterSender = "on"
        }else{
            strTwitterSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
        }
        if arrSendSelection.contains(3) {
            strPhoneSender = "on"
        }else{
            strPhoneSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
        }
        
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonOrder.user_id : UserDefaults.standard.value(forKey: "custid") as! String,
                                       BalloonOrder.balloon_color : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String,
                                       BalloonOrder.balloon_text_color : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as! String,
                                       BalloonOrder.balloon_font_family : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as! String,
                                       BalloonOrder.balloon_font_size : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as! String,
                                       BalloonOrder.balloon_message : SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String,
                                       BalloonOrder.balloon_bg_image : SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_bg_image") as! String,
                                       BalloonOrder.balloon_animation : SharedFunctions.balloonAnimationChecked(intAnimation: SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int),
                                       BalloonOrder.recording_file : "",
                                       BalloonOrder.sub_cat_id : SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_id") as! String,
                                       BalloonOrder.sub_cat_name : (SharedGlobalVariables.dicSaveBallonData.value(forKey: "sub_cat_name") == nil) ? "" : (SharedGlobalVariables.dicSaveBallonData.value(forKey: "sub_cat_name") as! String),
                                       BalloonOrder.delivery_date : SharedFunctions.delivaryDateFormatChange(inputDate: SharedGlobalVariables.dicSaveBallonData.value(forKey: "selectSendDate") as! String),
                                       BalloonOrder.reminder : SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloonRemainder") as! String == "1" ? "on" : "off",
                                       BalloonOrder.image_path : "",
                                       BalloonOrder.cardno : "",
                                       BalloonOrder.year : "",
                                       BalloonOrder.month : "",
                                       BalloonOrder.cvv : "",
                                       BalloonOrder.email_check : strEmailSender!,
                                       BalloonOrder.email : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") == nil ? "" :  ""/*SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String*/,
                                       BalloonOrder.facebook_check : strFacebookSender!,
                                       BalloonOrder.facebooksender_name : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") == nil ? "" : "" /*SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String*/,
                                       BalloonOrder.twitter_check : strTwitterSender!,
                                       BalloonOrder.twitter_sender_name : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") == nil ? "" : "" /*SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String*/,
                                       BalloonOrder.sms_ckeck : strPhoneSender!,
                                       BalloonOrder.phone_no : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as! String,
                                       BalloonOrder.email_price : "",
                                       BalloonOrder.facebook_price : "",
                                       BalloonOrder.twitter_price : "",
                                       BalloonOrder.linkedin_price : ""]
        
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_SAVE_MEMBER_ORDER, parseApiMethod: "UPLOAD")
    }
    
    internal func parseDictGetMemberBalloonOrderApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.showAlertWithPop(message: "Balloon Sent sucessfully")
            //self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: "Something Error!")
        }
    }
    
    func showAlertWithPop(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
//            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
//            controllerObj.pageTrack = "1"
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @objc func addAddress(_ btn:UIButton){
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AddressBookViewController") as! AddressBookViewController
        controllerObj.intPageTracking = 2
        controllerObj.dicPriceList = dicSharePrice
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    @objc func selectOption(_ btn:UIButton) {
        let tableCell = btn.superview?.superview?.superview as! UITableViewCell
        let indexPath = self.tableviewSendviaViewController.indexPath(for: tableCell)
        
        self.view.endEditing(true)
        if indexPath?.section == 0 {
            if indexPath?.row == 0 {
                if !arrSendSelection.contains((indexPath?.section)!) {
                    arrSendSelection.append((indexPath?.section)!)
                    if userMember == false{
                        //balloonPrice = balloonPrice + Float(dicSharePrice["email_price"] as! String)!
                    }
                }else{
                    if arrSendSelection.count > 1 {
                        var valueFound:Bool = false
                        var selectIndex:Int?
                        for index in 0 ..< arrSendSelection.count {
                            let indexData = arrSendSelection[index]
                            if indexData == indexPath?.section {
                                valueFound = true
                                selectIndex = index
                                break
                            }else{
                                valueFound = false
                            }
                        }
                        if valueFound == true {
                            arrSendSelection.remove(at: selectIndex!)
                            if userMember == false {
                                //balloonPrice = balloonPrice - Float(dicSharePrice["email_price"] as! String)!
                            }
                        }
                    }
                }
            }
        }else if indexPath?.section == 1 || indexPath?.section == 2 || indexPath?.section == 3 {
            if indexPath?.row == 1 {
                var indexToData:Int?
                if !arrSendSelection.contains((indexPath?.section)!) {
//                    if userMember == false {
//                        if indexPath?.section == 1 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["fb_price"] as! String)!
//                        }else if indexPath?.section == 2 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["twitter_price"] as! String)!
//                        }else if indexPath?.section == 3 {
//                            balloonPrice = balloonPrice + Float(dicSharePrice["linkedin_price"] as! String)!
//                        }
//                    }
                    arrSendSelection.append((indexPath?.section)!)
                }else{
                    if arrSendSelection.count > 1 {
                        var valueFound:Bool = false
                        var selectIndex:Int?
                        for index in 0 ..< arrSendSelection.count {
                            indexToData = index
                            let indexData = arrSendSelection[index]
                            if indexData == indexPath?.section {
                                valueFound = true
                                selectIndex = indexData
                                indexToData = index
                                break
                            }else{
                                valueFound = false
                            }
                        }
                        if valueFound == true {
                            if userMember == false {
//                                if selectIndex == 1 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["fb_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
//                                }else if selectIndex == 2 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["twitter_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
//                                }else if selectIndex == 3 {
//                                    balloonPrice = balloonPrice - Float(dicSharePrice["linkedin_price"] as! String)!
//                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
//                                }
                            }else{
                                if selectIndex == 1 {
                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
                                }else if selectIndex == 2 {
                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
                                }else if selectIndex == 3 {
                                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
                                }
                            }
                            arrSendSelection.remove(at: indexToData!)
                        }
                    }
                }
            }
        }
        self.tableviewSendviaViewController.reloadSections(NSIndexSet(index: (indexPath?.section)!) as IndexSet, with: .none)
        self.tableviewSendviaViewController.reloadSections(NSIndexSet(index: 4) as IndexSet, with: .none)
    }
}
