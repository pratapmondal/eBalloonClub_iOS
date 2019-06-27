//
//  AddressBookViewController.swift
//  E Balloon
//
//  Created by VAP on 04/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class AdressBookCell:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var imgMaill: UIImageView!
    @IBOutlet weak var lblMaillId: UILabel!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}

class AddressBookViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tableviewAddressBook: UITableView!
    var addressbookList:NSMutableArray = NSMutableArray()
    var dicPriceList:NSDictionary = NSDictionary()
    
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    var footerLabel : UILabel = UILabel()
    var intPageTracking:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Address Book"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if intPageTracking == 1 {
            let backImage    = UIImage(named: "add")!
            let backButton   = UIBarButtonItem(image: backImage,  style: .plain, target: self, action: Selector(("didTapbackButton:")))
            navigationItem.rightBarButtonItems = [backButton]
            let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(AddressBookViewController.nextButton))
            self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        }
    }
    
    @objc func nextButton(){
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecipientDetailsViewController") as! RecipientDetailsViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
        print("button click")
    }
    func WSGetAddressBook() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [AddressBookList.user_id : UserDefaults.standard.value(forKey: "custid") as! String ,AddressBookList.page : String(currentPageCount)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_ADDRESSBOOK, parseApiMethod: "POST")
    }
    internal func parseDictGetAddressBookApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            if (dictJson.value(forKey: "data") as AnyObject).count > 0{
                if(paginationCall){
                    
                    //let perPageLimit = Double(((dictJson.value(forKey: "dataset") as AnyObject).value(forKey: "limit") as AnyObject) as! Int)
                    let totalCount = Double(dictJson.value(forKey: "total_row_count") as! Int)
                    let totalPage:CGFloat = (CGFloat(totalCount / 10))
                    let pageNo = Int(totalPage)
                    if pageNo == 0 {
                        totalPageCount = 0
                    }else{
                        let desimalValue = (totalPage - CGFloat(pageNo))
                        if desimalValue > 0 {
                            totalPageCount = (pageNo - 1) + 1
                        }else{
                            totalPageCount = (pageNo - 1)
                        }
                    }
                    let featuredArr = dictJson.value(forKey: "data") as! NSArray
                    for index in 0 ..< featuredArr.count {
                        addressbookList.add(featuredArr.object(at: index))
                    }
                }else{
                    addressbookList.removeAllObjects()
                    //let perPageLimit = Double(((dictJson.value(forKey: "dataset") as AnyObject).value(forKey: "limit") as AnyObject) as! Int)
                    
                    let totalCount = Double(dictJson.value(forKey: "total_row_count") as! Int)
                    let totalPage:CGFloat = (CGFloat(totalCount / 10))
                    let pageNo = Int(totalPage)
                    if pageNo == 0 {
                        totalPageCount = 0
                    }else{
                        let desimalValue = (totalPage - CGFloat(pageNo))
                        if desimalValue > 0 {
                            totalPageCount = (pageNo - 1) + 1
                        }else{
                            totalPageCount = (pageNo - 1)
                        }
                    }                    
                    let bb:NSArray = dictJson.value(forKey: "data") as! NSArray
                    for index in 0 ..< bb.count {
                        addressbookList.add(bb.object(at: index))
                    }
                }
                self.tableviewAddressBook.isHidden = false
                self.lblNoDataFound.isHidden = true
                self.tableviewAddressBook.delegate = self
                self.tableviewAddressBook.dataSource = self
                self.tableviewAddressBook.reloadData()
            }else{
                if(!paginationCall){
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
                }
                self.tableviewAddressBook.isHidden = true
                self.lblNoDataFound.isHidden = false
                let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
                lblNoDataFound.text = errorMsg
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            self.tableviewAddressBook.isHidden = true
            self.lblNoDataFound.isHidden = false
            self.lblNoDataFound.text = errorMsg
        }
    }
    
    //scrollview delegates...
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height
        if (endScrolling >= scrollView.contentSize.height){
            if (totalPageCount > 0 && currentPageCount < totalPageCount){
                currentPageCount += 1
                updateTableViewFooter()
                paginationCall = true
                self.WSGetAddressBook()
            }else{
                paginationCall = false
            }
        }
    }
    //MARK: TableView footer add...
    func updateTableViewFooter(){
        if (totalPageCount > 0 && currentPageCount < totalPageCount) {
            self.footerLabel.text = "Loading..."
            ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        }else{
            self.footerLabel.text = "No more items"
            self.tableviewAddressBook.tableFooterView = nil
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableviewAddressBook.isHidden = true
        self.lblNoDataFound.isHidden = true
        paginationCall = false
        currentPageCount = 0
        self.WSGetAddressBook()
    }
    
    
    //MARK: Tableview delegate and Dataource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressbookList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdressBookCell", for: indexPath) as!  AdressBookCell
            cell.btnImage.addTarget(self, action: #selector(Editaction(_:)), for: .touchUpInside)
            
            cell.lblName.text = ((addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String) + " " + ((addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "lst_name") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "lst_name") as! String)
            
            cell.lblPhoneNo.text = (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "number") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "number") as! String
            
            cell.lblMaillId.text = (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "email") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "email") as! String
            
            cell.lblEvent.text = (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
            
            var straddressbookDate = (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "remind_date") is NSNull ? "" : (addressbookList.object(at: indexPath.row) as AnyObject).value(forKey: "remind_date") as! String
            
            if straddressbookDate == "0000-00-00" {
                straddressbookDate = "2018-07-21"
            }
            cell.lblDate.text = SharedFunctions.dateFormatChange(inputDate: straddressbookDate)
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdressBookCell", for: indexPath) as!  AdressBookCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if intPageTracking == 1 {
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecipientDetailsViewController") as! RecipientDetailsViewController
            controllerObj.dicUserInfo = addressbookList.object(at: (indexPath.row)) as! NSDictionary
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }else{
            if (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "email") as! String != "" {
                let strMailAddress = (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "email") is NSNull ? "" : (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "email") as! String
                SharedGlobalVariables.dicSaveBallonData.setValue(strMailAddress, forKey: "senderEmailAddress")
            }else{
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderEmailAddress")
            }
            
            if (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") as! String != "" {
                let strMailAddress = (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") is NSNull ? "" : (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") as! String
                SharedGlobalVariables.dicSaveBallonData.setValue(strMailAddress, forKey: "senderFacebookName")
            }else{
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderFacebookName")
            }
            
            if (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") as! String != "" {
                let strMailAddress = (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") is NSNull ? "" : (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "name") as! String
                SharedGlobalVariables.dicSaveBallonData.setValue(strMailAddress, forKey: "senderTwitterName")
            }else{
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderTwitterName")
            }
            
            if (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "number") as! String != "" {
                let strMailAddress = (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "number") is NSNull ? "" : (addressbookList.object(at: (indexPath.row)) as AnyObject).value(forKey: "number") as! String
                SharedGlobalVariables.dicSaveBallonData.setValue(strMailAddress, forKey: "senderPhoneName")
            }else{
                SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "senderPhoneName")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SENDVIAUPDATE"), object: nil, userInfo: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func Editaction(_ btn:UIButton) {
        let cell = btn.superview?.superview?.superview as? UITableViewCell
        let indexPath = tableviewAddressBook.indexPath(for: cell!)
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "RecipientDetailsViewController") as! RecipientDetailsViewController
        controllerObj.dicUserInfo = addressbookList.object(at: (indexPath?.row)!) as! NSDictionary
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }

}
