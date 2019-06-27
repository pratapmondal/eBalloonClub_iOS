//
//  MembershipViewController.swift
//  E Balloon
//
//  Created by VAP on 08/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import StoreKit

class MemberShipPriceCell:UITableViewCell{
    @IBOutlet weak var imgPerYear: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPerYear: UILabel!
}
class MemberShipBenefits:UITableViewCell{
    @IBOutlet weak var lblMemberShip: UILabel!
    
    @IBOutlet weak var vw1: UIView!
    @IBOutlet weak var lblVw1: UILabel!
    @IBOutlet weak var imgVw1: UIImageView!
    @IBOutlet weak var conTopLabelVw1: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw1: NSLayoutConstraint!
    
    @IBOutlet weak var vw2: UIView!
    @IBOutlet weak var lblVw2: UILabel!
    @IBOutlet weak var imgVw2: UIImageView!
    @IBOutlet weak var conTopLabelVw2: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw2: NSLayoutConstraint!
    
    @IBOutlet weak var vw3: UIView!
    @IBOutlet weak var lblVw3: UILabel!
    @IBOutlet weak var imgVw3: UIImageView!
    @IBOutlet weak var conTopLabelVw3: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw3: NSLayoutConstraint!
    
    @IBOutlet weak var vw4: UIView!
    @IBOutlet weak var lblVw4: UILabel!
    @IBOutlet weak var imgVw4: UIImageView!
    @IBOutlet weak var conTopLabelVw4: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw4: NSLayoutConstraint!
    
    @IBOutlet weak var vw5: UIView!
    @IBOutlet weak var lblVw5: UILabel!
    @IBOutlet weak var imgVw5: UIImageView!
    @IBOutlet weak var conTopLabelVw5: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw5: NSLayoutConstraint!
    
    @IBOutlet weak var vw6: UIView!
    @IBOutlet weak var lblVw6: UILabel!
    @IBOutlet weak var imgVw6: UIImageView!
    @IBOutlet weak var conTopLabelVw6: NSLayoutConstraint!
    @IBOutlet weak var conButLabelVw6: NSLayoutConstraint!
    
    @IBOutlet weak var conTopVw2: NSLayoutConstraint!
    @IBOutlet weak var conTopVw3: NSLayoutConstraint!
    @IBOutlet weak var conTopVw4: NSLayoutConstraint!
    @IBOutlet weak var conTopVw5: NSLayoutConstraint!
    @IBOutlet weak var conTopVw6: NSLayoutConstraint!
}

class GetsStartedCell:UITableViewCell {
    @IBOutlet weak var lblApplyCoupon: UILabel!
    @IBOutlet weak var txtApplyCoupon: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnGetStarted.layer.cornerRadius = 15
        btnGetStarted.clipsToBounds = true
        
        btnApply.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btnApply.layer.borderWidth = 1.0
        btnApply.layer.cornerRadius = 10
        btnApply.clipsToBounds = true
    }
}

class SimpleGetStartedCell:UITableViewCell {
    @IBOutlet weak var btnGetMembership: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnGetMembership.layer.cornerRadius = 15
        btnGetMembership.clipsToBounds = true
    }
}

class MembershipViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver,UITextFieldDelegate {
    
    @IBOutlet weak var tableviewMembership: UITableView!
    var arrMembershipDetails:NSArray = NSArray()
    var strMessage:NSString = NSString()
    let product_id_Original: NSString = "com.joseph.eBalloon.EballoonOfferMembershipPlan"
    let product_First_Plan:NSString = "com.joseph.eBalloon.eBalloonClubFirstPlan"
    let product_Second_Plan:NSString = "com.joseph.eBalloon.eBalloonPlanSubscription"
    let product_Third_Plan:NSString = "com.joseph.eBalloon.eBalloonClubThirdSubscription"
    var strApplyCouponCode:String = String()
    var dicDiscountDetails:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Membership"
        NotificationCenter.default.addObserver(self, selector: #selector(takenMembership), name: NSNotification.Name("memberShip"), object: nil)
        tableviewMembership.estimatedRowHeight = 1000
        tableviewMembership.rowHeight = UITableViewAutomaticDimension
        if UserDefaults.standard.value(forKey: "custid") == nil {
            WSMembershipDetailsApiCall()
        }else{
            WSGetMembershipDetails()
        }
        SKPaymentQueue.default().add(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationViewSetup()
        
        if SharedGlobalVariables.selectedViewController != "SendviaViewController" {
            self.addMenuToScreen()
        }
    }
    
    func navigationViewSetup() {
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
    
    func WSMembershipDetailsApiCall() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [:]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_MEMBERS_BENEFIT, parseApiMethod: "POST")
    }
    internal func parseDictMembershipDetailsApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            arrMembershipDetails = (dictJson.value(forKey: "data") as AnyObject) as! NSArray
            tableviewMembership.delegate = self
            tableviewMembership.dataSource = self
            tableviewMembership.reloadData()
        }else{
            let strMessage = dictJson.value(forKey: "message") is NSNull ? "" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: strMessage)
        }
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
//                let strMemberShipDetails = ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "membership") as AnyObject).value(forKey: "transaction_amount") is NSNull ? "" : ((dictJson.object(forKey: "data") as AnyObject).value(forKey: "membership") as AnyObject).value(forKey: "transaction_amount") as! String
//                UserDefaults.standard.set(strMemberShipDetails, forKey: "transaction_amount")
            }else{
                UserDefaults.standard.set("", forKey: "transaction_amount")
            }
            WSMembershipDetailsApiCall()
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: TableView Delegate and datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 230.0
        }else if indexPath.row == 1 {
            if arrMembershipDetails.count > 1 {
                return UITableViewAutomaticDimension
            }else{
                return 200.0
            }
        }else if indexPath.row == 2 {
            if UserDefaults.standard.value(forKey: "custid") != nil {
                if (UserDefaults.standard.value(forKey: "is_member") as! String == "1") && (UserDefaults.standard.value(forKey: "is_trial") as! String == "0") {
                    return 100.0
                }else{
                    return 80.0
                }
            }else{
                return 80.0
            }
            
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberShipPriceCell", for: indexPath) as!  MemberShipPriceCell
            if dicDiscountDetails["amount"] == nil {
                cell.lblPrice.text = "$0.99"
            }else{
                if dicDiscountDetails["amount"] as! String == "1" {
                    cell.lblPrice.text = "$2.99"
                }else if dicDiscountDetails["amount"] as! String == "2" {
                    cell.lblPrice.text = "$1.99"
                }else if dicDiscountDetails["amount"] as! String == "3" {
                    cell.lblPrice.text = "$0.99"
                }else{
                    cell.lblPrice.text = "$0.99"
                }
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberShipBenefits", for: indexPath) as! MemberShipBenefits
            if arrMembershipDetails.count > 1 {
                if let dicData = (arrMembershipDetails.count > 0 ? arrMembershipDetails[0] : nil) as! NSDictionary? {
                    cell.vw1.isHidden = false
                    cell.lblVw1.isHidden = false
                    cell.imgVw1.isHidden = false
                    cell.conButLabelVw1.constant = 5
                    cell.conTopLabelVw1.constant = 5
                    cell.lblVw1.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw1.isHidden = true
                    cell.lblVw1.isHidden = true
                    cell.imgVw1.isHidden = true
                    cell.conTopLabelVw1.constant = 0
                    cell.conButLabelVw1.constant = 0
                }
                
                if let dicData = (arrMembershipDetails.count > 1 ? arrMembershipDetails[1] : nil) as! NSDictionary? {
                    cell.vw2.isHidden = false
                    cell.lblVw2.isHidden = false
                    cell.imgVw2.isHidden = false
                    cell.conButLabelVw2.constant = 5
                    cell.conTopLabelVw2.constant = 5
                    cell.conTopVw2.constant = 10
                    cell.lblVw2.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw2.isHidden = true
                    cell.lblVw2.isHidden = true
                    cell.imgVw2.isHidden = true
                    cell.conTopLabelVw2.constant = 0
                    cell.conButLabelVw2.constant = 0
                    cell.conTopVw2.constant = 0
                }
                
                if let dicData = (arrMembershipDetails.count > 2 ? arrMembershipDetails[2] : nil) as! NSDictionary? {
                    cell.vw3.isHidden = false
                    cell.lblVw3.isHidden = false
                    cell.imgVw3.isHidden = false
                    cell.conButLabelVw3.constant = 5
                    cell.conTopLabelVw3.constant = 5
                    cell.conTopVw3.constant = 10
                    cell.lblVw3.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw3.isHidden = true
                    cell.lblVw3.isHidden = true
                    cell.imgVw3.isHidden = true
                    cell.conTopLabelVw3.constant = 0
                    cell.conButLabelVw3.constant = 0
                    cell.conTopVw3.constant = 0
                }
                
                if let dicData = (arrMembershipDetails.count > 3 ? arrMembershipDetails[3] : nil) as! NSDictionary? {
                    cell.vw4.isHidden = false
                    cell.lblVw4.isHidden = false
                    cell.imgVw4.isHidden = false
                    cell.conButLabelVw4.constant = 5
                    cell.conTopLabelVw4.constant = 5
                    cell.conTopVw4.constant = 10
                    cell.lblVw4.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw4.isHidden = true
                    cell.lblVw4.isHidden = true
                    cell.imgVw4.isHidden = true
                    cell.conTopLabelVw4.constant = 0
                    cell.conButLabelVw4.constant = 0
                    cell.conTopVw4.constant = 0
                }
                
                if let dicData = (arrMembershipDetails.count > 4 ? arrMembershipDetails[4] : nil) as! NSDictionary? {
                    cell.vw5.isHidden = false
                    cell.lblVw5.isHidden = false
                    cell.imgVw5.isHidden = false
                    cell.conButLabelVw5.constant = 5
                    cell.conTopLabelVw5.constant = 5
                    cell.conTopVw5.constant = 10
                    cell.lblVw5.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw5.isHidden = true
                    cell.lblVw5.isHidden = true
                    cell.imgVw5.isHidden = true
                    cell.conTopLabelVw5.constant = 0
                    cell.conButLabelVw5.constant = 0
                    cell.conTopVw5.constant = 0
                }
                if let dicData = (arrMembershipDetails.count > 5 ? arrMembershipDetails[5] : nil) as! NSDictionary? {
                    cell.vw6.isHidden = false
                    cell.lblVw6.isHidden = false
                    cell.imgVw6.isHidden = false
                    cell.conButLabelVw6.constant = 5
                    cell.conTopLabelVw6.constant = 5
                    cell.conTopVw6.constant = 10
                    cell.lblVw6.text = (dicData.value(forKey: "details") is NSNull) ? "" : (dicData.value(forKey: "details") as! String)
                }else{
                    cell.vw6.isHidden = true
                    cell.lblVw6.isHidden = true
                    cell.imgVw6.isHidden = true
                    cell.conTopLabelVw6.constant = 0
                    cell.conButLabelVw6.constant = 0
                    cell.conTopVw6.constant = 0
                }
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 2 {
            if UserDefaults.standard.value(forKey: "custid") != nil {
                if (UserDefaults.standard.value(forKey: "is_member") as! String == "1") && (UserDefaults.standard.value(forKey: "is_trial") as! String == "0") {
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
                    cell.btnCancelMembership.addTarget(self, action: #selector(cancelMember(_:)), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleGetStartedCell", for: indexPath) as! SimpleGetStartedCell
//                    cell.lblApplyCoupon.text = "Apply Coupon"
//                    cell.txtApplyCoupon.placeholder = "Enter Coupon Code"
//                    cell.txtApplyCoupon.delegate = self
//                    cell.btnApply.addTarget(self, action: #selector(applyAction(_:)), for: .touchUpInside)
                    cell.btnGetMembership.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleGetStartedCell", for: indexPath) as! SimpleGetStartedCell
//                cell.lblApplyCoupon.text = "Apply Coupon"
//                cell.txtApplyCoupon.placeholder = "Enter Coupon Code"
//                cell.txtApplyCoupon.delegate = self
//                cell.btnApply.addTarget(self, action: #selector(applyAction(_:)), for: .touchUpInside)
                cell.btnGetMembership.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberShipBenefits", for: indexPath) as!  MemberShipBenefits
            cell.selectionStyle = .none
            return cell
        }
    }
    //Textfield delegete and datasourse...
    func textFieldDidEndEditing(_ textField: UITextField) {
        strApplyCouponCode = textField.text!
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        strApplyCouponCode = textField.text!
        textField.resignFirstResponder()
        return true
    }
    @objc func applyAction(_ btn:UIButton) {
        self.view.endEditing(true)
        if strApplyCouponCode != "" {
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
            let Params:[String:String]! = [CouponDetails.coupon_code:strApplyCouponCode]
            SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_COUPON, parseApiMethod: "POST")
        }else{
            SharedFunctions.ShowAlert(controller: self, message: "Please enter coupon code to continue.")
        }
    }
    internal func parseDictCouponDetailsApi(controller:UIViewController, dictJson:NSDictionary){
        ActivityIndicator().hideActivityIndicatory(uiView: self.view)
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            let dicDiscountDetails = dictJson.value(forKey: "data") as! NSDictionary
            self.couponAppliedSucessfully(dicDiscount: dicDiscountDetails)
        }else{
            SharedFunctions.ShowAlert(controller: self, message: "Please apply valid coupon code.")
        }
    }


    
    @objc func getStarted() {
        if UserDefaults.standard.value(forKey: "is_member") == nil {
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            SharedGlobalVariables.selectedViewController = "Membership"
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }else if UserDefaults.standard.value(forKey: "is_member") as! String == "0" {
            if (SKPaymentQueue.canMakePayments()) {
                var productID:NSSet = NSSet()
                if dicDiscountDetails["amount"] == nil {
                    productID = NSSet(array: [self.product_id_Original as NSString])
                }else{
                    productID = NSSet(array: [self.product_id_Original as NSString])
//                    if dicDiscountDetails["amount"] as! String == "1" {
//                        productID = NSSet(array: [self.product_Third_Plan as NSString])
//                    }else if dicDiscountDetails["amount"] as! String == "2" {
//                        productID = NSSet(array: [self.product_Second_Plan as NSString])
//                    }else if dicDiscountDetails["amount"] as! String == "3" {
//                        productID = NSSet(array: [self.product_First_Plan as NSString])
//                    }else{
//                        productID = NSSet(array: [self.product_id_Original as NSString])
//                    }
                }
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
                productsRequest.delegate = self
                productsRequest.start()
                ActivityIndicator().showActivityIndicatory(uiView: self.view!)
                print("Fetching Products")
            }else{
                print("can't make purchases")
            }
            
//            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
//            controllerObj.intComingPageTracking = 2
//            self.navigationController?.pushViewController(controllerObj, animated: true)
        }else if UserDefaults.standard.value(forKey: "is_member") as! String == "1" {
            if (SKPaymentQueue.canMakePayments()) {
                var productID:NSSet = NSSet()
                if dicDiscountDetails["amount"] == nil {
                    productID = NSSet(array: [self.product_id_Original as NSString])
                }else{
                    productID = NSSet(array: [self.product_id_Original as NSString])
//                    if dicDiscountDetails["amount"] as! String == "1" {
//                        productID = NSSet(array: [self.product_Third_Plan as NSString])
//                    }else if dicDiscountDetails["amount"] as! String == "2" {
//                        productID = NSSet(array: [self.product_Second_Plan as NSString])
//                    }else if dicDiscountDetails["amount"] as! String == "3" {
//                        productID = NSSet(array: [self.product_First_Plan as NSString])
//                    }else{
//                        productID = NSSet(array: [self.product_id_Original as NSString])
//                    }
                }
                let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
                productsRequest.delegate = self;
                productsRequest.start()
                ActivityIndicator().showActivityIndicatory(uiView: self.view!)
                print("Fetching Products");
            }else{
                print("can't make purchases");
            }
//            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
//            controllerObj.intComingPageTracking = 2
//            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
    }
    func buyProduct(product: SKProduct) {
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
    }
    
    // SKProductRequest Delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id_Original as String) {
                self.buyProduct(product: validProduct)
            }else{
                print(validProduct.productIdentifier)
            }
            
//            if (validProduct.productIdentifier == self.product_id_Original as String) {
//                self.buyProduct(product: validProduct)
//            }else if (validProduct.productIdentifier == self.product_First_Plan as String) {
//                self.buyProduct(product: validProduct)
//            }else if (validProduct.productIdentifier == self.product_Second_Plan as String) {
//                self.buyProduct(product: validProduct)
//            }else if (validProduct.productIdentifier == self.product_Third_Plan as String) {
//                self.buyProduct(product: validProduct)
//            }else{
//                print(validProduct.productIdentifier)
//            }
        }else{
            print("nothing")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                ActivityIndicator().hideActivityIndicatory(uiView: self.view)
                switch trans.transactionState {
                case .purchased:
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view)
                    print("Product Purchased")
                    //Do unlocking etc stuff here in case of new purchase
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    let strTransId:String = String(trans.transactionIdentifier!)
                    ActivityIndicator().showActivityIndicatory(uiView: self.view!)
                    var strTransactionAmount:String = String()
                    if dicDiscountDetails["amount"] == nil {
                        strTransactionAmount = "3.99"
                    }else{
                        strTransactionAmount = "3.99"
//                        if dicDiscountDetails["amount"] as! String == "1" {
//                            strTransactionAmount = "2.99"
//                        }else if dicDiscountDetails["amount"] as! String == "2" {
//                            strTransactionAmount = "1.99"
//                        }else if dicDiscountDetails["amount"] as! String == "3" {
//                            strTransactionAmount = "0.99"
//                        }else{
//                            strTransactionAmount = "3.99"
//                        }
                    }
                    let Params:[String:String]! = [AddMembershipPlan.user_id : UserDefaults.standard.value(forKey: "custid") as! String,
                                                   AddMembershipPlan.coupon_applied : (dicDiscountDetails["name"] == nil) ? "" : dicDiscountDetails["name"] as! String,
                                                   AddMembershipPlan.previous_amount : "3.99",
                                                   AddMembershipPlan.transaction_amount : strTransactionAmount,
                                                   AddMembershipPlan.transaction_id : strTransId]
                    SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_ACTIVE_MEMBERSHIP_API, parseApiMethod: "POST")
                    break
                case .purchasing:
                    ActivityIndicator().showActivityIndicatory(uiView: self.view!)
                    break;
                case .failed:
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .restored:
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
            }else{
                ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            }
        }
    }
    
    
    
    internal func parseDictGetMemberBalloonOrderApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                self.navigationController?.popViewController(animated: true)
                UserDefaults.standard.set("1", forKey: "is_member")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
            }else{
                SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                self.showAlertWithPop(message: dictJson.value(forKey: "message") as! String)
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: "Something Error!")
        }
    }
    
    func showAlertWithPop(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            if SharedGlobalVariables.selectedViewController == "SendviaViewController" {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SignInTrack"), object: nil, userInfo: nil )
            }else{
                let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                self.navigationController?.pushViewController(controllerObj, animated: true)
            }
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func couponAppliedSucessfully(dicDiscount:NSDictionary) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Your coupon has been sucessfully applied.", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.dicDiscountDetails = dicDiscount
            self.tableviewMembership.reloadData()
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func cancelMember(_ btn:UIButton) {
        if (UserDefaults.standard.value(forKey: "is_member") as! String == "1") && (UserDefaults.standard.value(forKey: "is_trial") as! String == "0") {
            self.userLogOut()
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
            self.tableviewMembership.reloadData()
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @objc func takenMembership() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Do you want to go next step or stay here.", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "NEXT", style: .cancel) { action -> Void in
            self.getStarted()
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "STAY", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    

    

}
