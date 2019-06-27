//
//  PaymentViewController.swift
//  E Balloon
//
//  Created by Ayan on 09/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class packageDetails:UITableViewCell{
    @IBOutlet weak var imgPrice: UIImageView!
    @IBOutlet weak var lblAddition: UILabel!
    @IBOutlet weak var lblAdditionCost: UILabel!
    @IBOutlet weak var lblPackageDetails: UILabel!
}


class PaymentDetails:UITableViewCell{
    @IBOutlet weak var lblPriceDetails: UILabel!
}

class DetaulsCell:UITableViewCell{
    @IBOutlet weak var txtFirst: UITextField!
}


class PaymentOptionSelectionCell:UITableViewCell {
    @IBOutlet weak var lblPaymentSelection: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
}

class CompleteCell:UITableViewCell{
    @IBOutlet weak var bntComplete: UIButton!
}

class PaymentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var tableviewPayment: UITableView!
    let arrPaymentName:NSArray = ["Select","Authorize Payment"]
    var intComingPageTracking:Int = 1
    var dicPayementdetails:NSMutableDictionary = NSMutableDictionary()
    var dicSharePaymentDetails:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewPayment.delegate = self
        tableviewPayment.dataSource = self
        tableviewPayment.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetup()
    }
    
    func navigationBarSetup() {
        self.title = "Payment"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:TableView Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            if intComingPageTracking == 1 {
                return 9
            }else{
                return 6
            }
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 195.0
        }else if indexPath.section == 1 {
            return 60.0
        }else if indexPath.section == 2 {
            return 50.0
        }else{
            return 79.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "packageDetails", for: indexPath) as!  packageDetails
            cell.imgPrice.layer.cornerRadius = cell.imgPrice.frame.height/2
            cell.imgPrice.layer.masksToBounds = true
            if intComingPageTracking == 1 {
                cell.lblPackageDetails.text = "Total Payment Amount"
                cell.lblAddition.text = "Total"
                cell.lblAdditionCost.text = "$ " + (SharedGlobalVariables.dicSaveBallonData.value(forKey: "ballon_order_amount") as! String)
            }else{
                cell.lblPackageDetails.text = "Your Package Details"
                cell.lblAdditionCost.text = "$ 18.95"
                cell.lblAddition.text = "Membership Price"
            }
            cell.imgPrice.isUserInteractionEnabled = true
            cell.imgPrice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToCategoryPage(_:))))
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetails", for: indexPath) as! PaymentDetails
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            if intComingPageTracking == 1 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") as! String == ""  {
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "First Name" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.autocapitalizationType = .words
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .default
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 0
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "last_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "last_name") as! String == "" {
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Last Name" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "last_name") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .default
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 1
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") as! String == "" {
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Email" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .emailAddress
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 2
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionSelectionCell", for: indexPath) as! PaymentOptionSelectionCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "payment_method") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "payment_method") as! String == ""{
                        cell.lblPaymentSelection.attributedText = NSAttributedString(string: "Payment Method" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.lblPaymentSelection.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "payment_method") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.lblPaymentSelection.isUserInteractionEnabled = true
                    cell.lblPaymentSelection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentOptionSelection(_:))))
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "XXXX XXXX XXXX XXXX" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 4
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_holder_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_holder_name") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Card Holder Name" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_holder_name") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .default
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 5
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 6 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Expiry Month(MM)" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 6
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 7 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Expiry Year(YYYY)" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 7
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 8 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    if SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "CVV" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 8
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell", for: indexPath) as!  DetaulsCell
                    cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    cell.txtFirst.returnKeyType = UIReturnKeyType.done
                    cell.txtFirst.keyboardType = .default
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = true
                    cell.txtFirst.tag = 1
                    cell.txtFirst.isEnabled = true
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionSelectionCell", for: indexPath) as!  PaymentOptionSelectionCell
                    if dicPayementdetails.value(forKey: "payment_method") == nil || dicPayementdetails.value(forKey: "payment_method") as! String == ""{
                        cell.lblPaymentSelection.attributedText = NSAttributedString(string: "Payment Method" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.lblPaymentSelection.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "payment_method") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.lblPaymentSelection.isUserInteractionEnabled = true
                    cell.lblPaymentSelection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentOptionSelection(_:))))
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    if dicPayementdetails.value(forKey: "card_number") == nil || dicPayementdetails.value(forKey: "card_number") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "XXXX XXXX XXXX XXXX" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "card_number") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 9
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    if dicPayementdetails.value(forKey: "card_holder_name") == nil || dicPayementdetails.value(forKey: "card_holder_name") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Card Holder Name" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "card_holder_name") as? String)!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .default
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 10
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 3 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    if dicPayementdetails.value(forKey: "expiry_month") == nil || dicPayementdetails.value(forKey: "expiry_month") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Expiry Month(MM)" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "expiry_month") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 11
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    if dicPayementdetails.value(forKey: "expiry_year") == nil || dicPayementdetails.value(forKey: "expiry_year") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "Expiry Year(YYYY)" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "expiry_year") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = false
                    cell.txtFirst.tag = 12
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else if indexPath.row == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    if dicPayementdetails.value(forKey: "cvv_no") == nil || dicPayementdetails.value(forKey: "cvv_no") as! String == ""{
                        cell.txtFirst.attributedPlaceholder = NSAttributedString(string: "CVV" ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }else{
                        cell.txtFirst.attributedText = NSAttributedString(string: (dicPayementdetails.value(forKey: "cvv_no") as? String)! ,attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                    }
                    cell.txtFirst.returnKeyType = .done
                    cell.txtFirst.keyboardType = .numberPad
                    cell.txtFirst.autocorrectionType = .no
                    cell.txtFirst.isSecureTextEntry = true
                    cell.txtFirst.tag = 13
                    cell.txtFirst.delegate = self
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetaulsCell") as! DetaulsCell
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteCell", for: indexPath) as!  CompleteCell
            cell.bntComplete.addTarget(self, action: #selector(completePayment(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteCell", for: indexPath) as!  CompleteCell
            cell.bntComplete.addTarget(self, action: #selector(completePayment(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK:TextField Delegate...
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 1, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "first_name")
            lastNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 1 {
            let emailCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "last_name")
            emailCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 2 {
            let paymentMethodCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "email")
            paymentMethodCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 4 {
            let cardHolderNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_number")
            cardHolderNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 5 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 6, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 6 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 7, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 7 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 8, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 8 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 8, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 9 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 1, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_number")
            lastNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 10 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 11 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 3, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 12 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 4, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 13 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "first_name")
            lastNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 1 {
            let emailCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 1, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "last_name")
            emailCell.txtFirst.becomeFirstResponder()
        }else if textField.tag == 2 {
            let emailCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "email")
            emailCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 4 {
            let cardHolderNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 4, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_number")
            cardHolderNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 5 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 6 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 6, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 7 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 7, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 8 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 8, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 9 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_number")
            lastNameCell.txtFirst.becomeFirstResponder()
        }else if textField.tag == 10 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 3, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.becomeFirstResponder()
        }else if textField.tag == 11 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 4, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.becomeFirstResponder()
        }else if textField.tag == 12 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.becomeFirstResponder()
        }else if textField.tag == 13 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 0 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 0, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "first_name")
            lastNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 1 {
            let emailCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 1, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "last_name")
            emailCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 2 {
            let paymentMethodCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "email")
            paymentMethodCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 4 {
            let cardHolderNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 4, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_number")
            cardHolderNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 5 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 6 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 6, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 7 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 7, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 8 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 8, section: 2) as IndexPath) as! DetaulsCell
            SharedGlobalVariables.dicSaveBallonData.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 9 {
            let lastNameCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 1, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_number")
            lastNameCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 10 {
            let monthCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 2, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "card_holder_name")
            monthCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 11 {
            let yearCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 3, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_month")
            yearCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 12 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 4, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "expiry_year")
            cvvCell.txtFirst.resignFirstResponder()
        }else if textField.tag == 13 {
            let cvvCell = tableviewPayment.cellForRow(at: NSIndexPath(row: 5, section: 2) as IndexPath) as! DetaulsCell
            dicPayementdetails.setValue(textField.text!, forKey: "cvv_no")
            cvvCell.txtFirst.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 4 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 16 {
                SharedFunctions.ShowAlert(controller: self, message: "Please enter digits between 14 to 16.")//Card Number
                return false
            }else{
                return true
            }
        }else if textField.tag == 6 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 2 {
                SharedFunctions.ShowAlert(controller: self, message: "Month should be correct format.")//Month
                return false
            }else{
                return true
            }
        }else if textField.tag == 7 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 4 {
                SharedFunctions.ShowAlert(controller: self, message: "Years should be correct format.")//Years
                return false
            }else{
                return true
            }
        }else if textField.tag == 8 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 3 {
                SharedFunctions.ShowAlert(controller: self, message: "Please enter correct cvv number.")//Cvv
                return false
            }else{
                return true
            }
        }else if textField.tag == 9 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 16 {
                SharedFunctions.ShowAlert(controller: self, message: "Please enter digits between 14 to 16.")//Card Number
                return false
            }else{
                return true
            }
        }else if textField.tag == 11 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 2 {
                SharedFunctions.ShowAlert(controller: self, message: "Month should be correct format.")//Month
                return false
            }else{
                return true
            }
        }else if textField.tag == 12 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 4 {
                SharedFunctions.ShowAlert(controller: self, message: "Years should be correct format.")//Years
                return false
            }else{
                return true
            }
        }else if textField.tag == 13 {
            let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let numberOfChars = updatedString?.count
            if numberOfChars! > 3 {
                SharedFunctions.ShowAlert(controller: self, message: "Please enter correct cvv number.")//Cvv
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    
    
    @objc func paymentOptionSelection(_ gesture:UITapGestureRecognizer) {
        self.selectPaymentOptionPopUp(headerMessage: "Select the payment option.")
    }
    
    func selectPaymentOptionPopUp(headerMessage:String){
        self.view.endEditing(true)
        let message = "\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        
        let attributedString = NSAttributedString(string: headerMessage, attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        alert.setValue(attributedString, forKey: "attributedTitle")
        var pickerFrame: CGRect = CGRect()
        if UIScreen.main.bounds.size.width >= 750.0 && UIScreen.main.bounds.size.width < 1334.0 {
            pickerFrame = CGRect(x:0, y:0, width:310, height:100)
        }else{
            pickerFrame = CGRect(x:0, y:30, width:alert.view.bounds.size.width - 20, height:120)
        }
        
        let picker: UIPickerView = UIPickerView(frame: pickerFrame)
        picker.backgroundColor = UIColor.clear
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        
        picker.delegate = self
        picker.dataSource = self
        
        alert.view.addSubview(picker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.intComingPageTracking == 1 {
                let selectedIndexPath = IndexPath(item: 3, section: 2)
                self.tableviewPayment.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let selectedIndexPath = IndexPath(item: 0, section: 2)
                self.tableviewPayment.reloadRows(at: [selectedIndexPath], with: .none)
            }
            
            //self.tableviewPayment.reloadData()
        })
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.width / 2.0,
                                                                 y:self.view.bounds.height / 30.0, width:40.0, height:300.0)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark : Picker View Delegate and Datasourse
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPaymentName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectPaymentOption = arrPaymentName.object(at: row) as! String
        if intComingPageTracking == 1 {
            SharedGlobalVariables.dicSaveBallonData.setValue(selectPaymentOption == "Select" ? "Payment Method" : selectPaymentOption, forKey: "payment_method")
        }else{
            dicPayementdetails.setValue(selectPaymentOption == "Select" ? "Payment Method" : selectPaymentOption, forKey: "payment_method")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPaymentName.object(at: row) as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let strPaymentOptionName = arrPaymentName.object(at: row) as? String
        let myTitle = NSAttributedString(string: strPaymentOptionName! , attributes: [NSAttributedStringKey.font:UIFont(name: "OpenSans", size: 12.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        return myTitle
    }
    //Please enter first name to continue
    @objc func completePayment(_ btn:UIButton){
        self.view.endEditing(true)
        if intComingPageTracking == 1 {
            let strUserCardNumber = SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") == nil ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") as! String
            let strUserCardMonth = SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") == nil ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") as! String
            let strUserCardYear = SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") == nil ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") as! String
            let strUserCvvNumber = SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") == nil ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") as! String
            
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: Messages.USER_FIRST_NAME)
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "last_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "last_name") as! String == ""{
                SharedFunctions.ShowAlert(controller: self, message: Messages.USER_LAST_NAME)
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: Messages.USER_EMAIL)
            }else if !((SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") as? String)?.isEmail())! {
                SharedFunctions.ShowAlert(controller: self, message: Messages.USER_CORRECT_EMAIL)
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "payment_method") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "payment_method") as! String == "Select" {
                SharedFunctions.ShowAlert(controller: self, message: "Please select payment option to continue.")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card number to continue.")
            }else if strUserCardNumber.count < 14 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provider valid card number.")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_holder_name") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_holder_name") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card holder name to continue.")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card expiry month to continue.")
            }else if strUserCardMonth.count < 2 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide valid month.")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card expiry year to continue.")
            }else if strUserCardYear.count < 4 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide valid year.")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card cvv number to continue.")
            }else if strUserCvvNumber.count < 3 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide vaild cvv no.")
            }else{
                self.balloonOrder()
            }
        }else{
            let strUserCardNumber = dicPayementdetails.value(forKey: "card_number") == nil ? "" : dicPayementdetails.value(forKey: "card_number") as! String
            let strUserCardMonth = dicPayementdetails.value(forKey: "expiry_month") == nil ? "" : dicPayementdetails.value(forKey: "expiry_month") as! String
            let strUserCardYear = dicPayementdetails.value(forKey: "expiry_year") == nil ? "" : dicPayementdetails.value(forKey: "expiry_year") as! String
            let strUserCardCvv = dicPayementdetails.value(forKey: "cvv_no") == nil ? "" : dicPayementdetails.value(forKey: "cvv_no") as! String
            
            if dicPayementdetails.value(forKey: "payment_method") == nil || dicPayementdetails.value(forKey: "payment_method") as! String == "Select" {
                SharedFunctions.ShowAlert(controller: self, message: "Please select payment option to continue.")
            }else if dicPayementdetails.value(forKey: "card_number") == nil || dicPayementdetails.value(forKey: "card_number") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card number to continue.")
            }else if strUserCardNumber.count < 14 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provider valid card number.")
            }else if dicPayementdetails.value(forKey: "card_holder_name") == nil || dicPayementdetails.value(forKey: "card_holder_name") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card holder name to continue.")
            }else if dicPayementdetails.value(forKey: "expiry_month") == nil || dicPayementdetails.value(forKey: "expiry_month") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card expiry month to continue.")
            }else if strUserCardMonth.count < 2 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide valid month.")
            }else if dicPayementdetails.value(forKey: "expiry_year") == nil || dicPayementdetails.value(forKey: "expiry_year") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card expiry year to continue.")
            }else if strUserCardYear.count < 4 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide valid year.")
            }else if dicPayementdetails.value(forKey: "cvv_no") == nil || dicPayementdetails.value(forKey: "cvv_no") as! String == "" {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide card cvv number to continue.")
            }else if strUserCardCvv.count < 3 {
                SharedFunctions.ShowAlert(controller: self, message: "Please provide vaild cvv no.")
            }else{
                self.getMembership()
            }
        }
    }
    
    func balloonOrder() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        
        var strEmailSender:String?
        var strFacebookSender:String?
        var strTwitterSender:String?
        var strPhoneSender:String?
        
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String != "" {
                strEmailSender = "on"
                SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePaymentDetails.value(forKey: "email_price") as! String), forKey: "emailSharePrice")
            }else{
                strEmailSender = ""
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "emailSharePrice")
            }
        }else{
            strEmailSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "emailSharePrice")
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String != "" {
                strFacebookSender = "on"
                SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePaymentDetails["fb_price"] as! String), forKey: "facebookSharePrice")
            }else{
                strFacebookSender = ""
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "facebookSharePrice")
            }
        }else{
            strFacebookSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "facebookSharePrice")
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String != "" {
                strTwitterSender = "on"
                SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePaymentDetails["twitter_price"] as! String), forKey: "twitterSharePrice")
            }else{
                strTwitterSender = ""
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "twitterSharePrice")
            }
        }else{
            strTwitterSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "twitterSharePrice")
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") != nil {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as! String != "" {
                strPhoneSender = "on"
                SharedGlobalVariables.dicSaveBallonData.setValue((dicSharePaymentDetails["linkedin_price"] as! String), forKey: "linkedinSharePrice")
            }else{
                strPhoneSender = ""
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "linkedinSharePrice")
            }
        }else{
            strPhoneSender = ""
            SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "linkedinSharePrice")
        }
        
        let Params:[String:String]! = [BalloonOrder.balloon_color : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String),
                                       BalloonOrder.balloon_text_color : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as! String),
                                       BalloonOrder.balloon_font_family : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as! String),
                                       BalloonOrder.balloon_font_size : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as! String,
                                       BalloonOrder.balloon_message : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String),
                                       BalloonOrder.balloon_bg_image : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_bg_image") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_bg_image") as! String),
                                       BalloonOrder.balloon_animation : SharedFunctions.balloonAnimationChecked(intAnimation: SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int),
                                       BalloonOrder.recording_file : "",
                                       BalloonOrder.sub_cat_id : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_id") == nil) ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloon_id")as! String),
                                       BalloonOrder.sub_cat_name : (SharedGlobalVariables.dicSaveBallonData.value(forKey: "sub_cat_name") == nil) ? "" : (SharedGlobalVariables.dicSaveBallonData.value(forKey: "sub_cat_name") as! String),
                                       BalloonOrder.delivery_date : SharedFunctions.delivaryDateFormatChange(inputDate: SharedGlobalVariables.dicSaveBallonData.value(forKey: "selectSendDate") as! String),
                                       BalloonOrder.reminder : SharedGlobalVariables.dicSaveBallonData.value(forKey: "balloonRemainder") as! String == "1" ? "on" : "off",
                                       BalloonOrder.image_path : "",
                                       BalloonOrder.cardno : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") == nil)
                                        ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "card_number") as! String),
                                       BalloonOrder.year : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_year")  as! String),
                                       BalloonOrder.month : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") == nil) ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "expiry_month") as! String),
                                       BalloonOrder.cvv : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "cvv_no") as! String),
                                       BalloonOrder.email_check : strEmailSender!,
                                       BalloonOrder.email : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "email") as! String)/*SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String*/,
                                       BalloonOrder.facebook_check : strFacebookSender!,
                                       BalloonOrder.facebooksender_name : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderFacebookName") as! String,
                                       BalloonOrder.twitter_check : strTwitterSender!,
                                       BalloonOrder.twitter_sender_name : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderTwitterName") as! String,
                                       BalloonOrder.sms_ckeck : strPhoneSender!,
                                       BalloonOrder.phone_no : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderPhoneName") as! String,
                                       BalloonOrder.name_on_card : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "first_name") as! String),
                                       BalloonOrder.order_amount : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "ballon_order_amount") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "ballon_order_amount") as! String),
                                       BalloonOrder.user_email : SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") == nil ? "" :  SharedGlobalVariables.dicSaveBallonData.value(forKey: "senderEmailAddress") as! String,
                                       BalloonOrder.email_price : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "emailSharePrice") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "emailSharePrice")  as! String),
                                       BalloonOrder.facebook_price : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "facebookSharePrice") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "facebookSharePrice")  as! String),
                                       BalloonOrder.twitter_price : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "twitterSharePrice") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "twitterSharePrice") as! String),
                                       BalloonOrder.linkedin_price : ((SharedGlobalVariables.dicSaveBallonData.value(forKey: "linkedinSharePrice") == nil) ? "" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "linkedinSharePrice") as! String)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_NON_MEMBER_ORDER, parseApiMethod: "UPLOAD")
    }
    
    @objc func goToCategoryPage(_ gesture:UITapGestureRecognizer) {
        self.view.endEditing(true)
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    internal func parseDictGetNonMemberBalloonOrderApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
            showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
    }
    
    func getMembership() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonOrder.user_id : UserDefaults.standard.value(forKey: "custid") as! String,
                                       BalloonOrder.card_no : dicPayementdetails.value(forKey: "card_number") as! String,
                                       BalloonOrder.card_holder_name : dicPayementdetails.value(forKey: "card_holder_name") as! String,
                                       BalloonOrder.month : dicPayementdetails.value(forKey: "expiry_month") as! String,
                                       BalloonOrder.yy : dicPayementdetails.value(forKey: "expiry_year") as! String,
                                       BalloonOrder.cvv : dicPayementdetails.value(forKey: "cvv_no") as! String]
        
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_ACTIVE_MEMBERSHIP, parseApiMethod: "UPLOAD")
    }
    
    
    internal func parseDictGetMembershipApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            dicPayementdetails.removeAllObjects()
            self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
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
    //MARK : View background Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event!)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    
}
