//
//  ContactViewController.swift
//  E Balloon
//
//  Created by VAP on 11/12/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import AddressBook
import Contacts



class ContantSelectionCell:UITableViewCell {
    @IBOutlet weak var imgContactPic: UIImageView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
}
class ContactSectionCell : UITableViewCell {
    @IBOutlet weak var lblContact: UILabel!
}

class ContactViewController: UIViewController {
    @IBOutlet weak var tableviewContactList: UITableView!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var heightNavigationBar: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var tableviewBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var arrTotalContactDetails:[(Fullname:String,Phnumber:String)] = []
    var userInformationArray:[(Fullname:String,Phnumber:String)] = []
    
    var arrTotalBalloonContact:[(Fullname:String,Phnumber:String)] = []
    var arrBalloonInformationArray:[(Fullname:String,Phnumber:String)] = []
    
    var searchActive : Bool = false
    var filtered:[String] = []
    var boolSync:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundColor = UIColor.clear
        if UIScreen.main.bounds.height < 810.0 {
            heightNavigationBar.constant = 84.0
            tableviewBottomConstaint.constant = 333.0
        }else{
            heightNavigationBar.constant = 145.0
            tableviewBottomConstaint.constant = 258.0
        }
        self.searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true

        self.searchBar.tintColor = UIColor.white
        self.searchBar.placeholder = "Search"
        searchBar.delegate = self
        lblNoDataFound.text = "List Empty!"
        btnSync.addTarget(self, action: #selector(syncContact(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var countryAndCode: [(Fullname:String , Phnumber: String)] = []
        for objcontact in contacts {
            if (objcontact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if (objcontact.phoneNumbers.count > 0) {
                    let phnum =  (objcontact.phoneNumbers[0] as CNLabeledValue).value
                    let PhoneNo = phnum.stringValue
                    let filterPhoneNo = PhoneNo.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    let fullName = (CNContactFormatter.string(from: objcontact, style: .fullName)) ?? ""
                    countryAndCode += [(Fullname:fullName , Phnumber:filterPhoneNo)]
               }
            }
        }
        userInformationArray = countryAndCode.sorted(by: { (item1, item2) -> Bool in
            return item1.Fullname.compare(item2.Fullname) == ComparisonResult.orderedAscending
        })
        if userInformationArray.count > 0 {
            arrTotalContactDetails = userInformationArray
            
            self.tableviewContactList.isHidden = false
            self.lblNoDataFound.isHidden = true
            self.tableviewContactList.delegate = self
            self.tableviewContactList.dataSource = self
            self.tableviewContactList.reloadData()
        }else{
            self.tableviewContactList.isHidden = true
            self.lblNoDataFound.isHidden = false
        }
    }
    @objc func syncContact(_ btn:UIButton) {
        if boolSync == false {
            self.WSGetBalloonContact()
        }else{
           SharedFunctions.ShowAlert(controller: self, message: "Already sync your contact.")
        }
    }
    func WSGetBalloonContact() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params : [String:String]! = [:]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_MEMBER_LIST, parseApiMethod: "POST")
    }
    internal func parseDictBalloonContactApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            boolSync = true
            let arrApiBalloonContactList = dictJson.value(forKey: "data") as? Array<Dictionary<String,Any>> ?? []
            var arrSortBalloonContactList : [(Fullname:String , Phnumber: String)] = []
            if arrApiBalloonContactList.count > 0 {
                for index in 0...arrApiBalloonContactList.count - 1 {
                    let strFistName = arrApiBalloonContactList[index]["first_name"] as? String ?? ""
                    let strPhone = arrApiBalloonContactList[index]["phone"] as? String ?? ""
                    arrSortBalloonContactList += [(Fullname:strFistName , Phnumber:strPhone)]
                }
            }
            arrTotalBalloonContact = arrSortBalloonContactList.sorted(by: { (item1, item2) -> Bool in
                return item1.Fullname.compare(item2.Fullname) == ComparisonResult.orderedAscending
            })
            arrBalloonInformationArray = arrTotalBalloonContact
            self.tableviewContactList.reloadData()
            
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: controller, message:dictJson.value(forKey: "message") as! String)
        }
    }
    
    
    lazy var contacts: [CNContact] = {
        let contactStore = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey,CNContactNamePrefixKey,CNContactNamePrefixKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactFamilyNameKey,CNContactPreviousFamilyNameKey,CNContactNameSuffixKey,CNContactNicknameKey,CNContactOrganizationNameKey,CNContactDepartmentNameKey,CNContactJobTitleKey,CNContactJobTitleKey,CNContactPhoneticGivenNameKey,CNContactPhoneticMiddleNameKey,CNContactPhoneticFamilyNameKey,CNContactBirthdayKey,CNContactNonGregorianBirthdayKey,CNContactNoteKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactImageDataAvailableKey,CNContactTypeKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactUrlAddressesKey,CNContactRelationsKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        print(results)
        return results
    }()
}

extension ContactViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrTotalContactDetails.removeAll()
        arrBalloonInformationArray.removeAll()
        if searchText != "" {
            searchActive = true
            var tmp1:NSString?
            var tmp2:NSString?
            arrTotalContactDetails = (userInformationArray.filter({ (data) -> Bool in
                let num = Int(searchText)
                if num != nil {
                    tmp1 = data.Phnumber as NSString
                }else{
                    tmp1 = data.Fullname as NSString
                }
                let range = tmp1?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range?.location != NSNotFound
            }))
            arrBalloonInformationArray = (arrTotalBalloonContact.filter({ (data) -> Bool in
                let num = Int(searchText)
                if num != nil {
                    tmp2 = data.Phnumber as NSString
                }else{
                    tmp2 = data.Fullname as NSString
                }
                let range = tmp2?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range?.location != NSNotFound
            }))
        }else{
            arrBalloonInformationArray = arrTotalBalloonContact
            arrTotalContactDetails = userInformationArray
            searchActive = true
        }
        self.tableviewContactList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
}
    


extension ContactViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if boolSync == false {
            return 1
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44.0
        }else{
            return 85.0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boolSync == true {
            if section == 0 {
                return arrBalloonInformationArray.count + 1
            }else{
                return arrTotalContactDetails.count + 1
            }
        }else{
            return arrTotalContactDetails.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if boolSync == true {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactSectionCell", for: indexPath) as! ContactSectionCell
                    cell.lblContact.text = "Balloon Contact"
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ContantSelectionCell", for: indexPath) as! ContantSelectionCell
                    cell.lblContactName.text = arrBalloonInformationArray[indexPath.row - 1].Fullname
                    cell.lblContactNo.text = arrBalloonInformationArray[indexPath.row - 1].Phnumber
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ContactSectionCell", for: indexPath) as! ContactSectionCell
                    cell.lblContact.text = "Phone Contact"
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ContantSelectionCell", for: indexPath) as! ContantSelectionCell
                    cell.lblContactName.text = arrTotalContactDetails[indexPath.row - 1].Fullname
                    cell.lblContactNo.text = arrTotalContactDetails[indexPath.row - 1].Phnumber
                    cell.selectionStyle = .none
                    return cell
                }
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactSectionCell", for: indexPath) as! ContactSectionCell
                cell.lblContact.text = "Phone Contact"
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContantSelectionCell", for: indexPath) as! ContantSelectionCell
                cell.lblContactName.text = arrTotalContactDetails[indexPath.row - 1].Fullname
                cell.lblContactNo.text = arrTotalContactDetails[indexPath.row - 1].Phnumber
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if boolSync == true {
                if indexPath.section == 0 {
                    let strPhoneNo = arrBalloonInformationArray[indexPath.row - 1].Phnumber
                    SharedGlobalVariables.dicSaveBallonData.setValue(strPhoneNo, forKey: "senderPhoneName")
                }else{
                    let strPhoneNo = arrTotalContactDetails[indexPath.row - 1].Phnumber
                    SharedGlobalVariables.dicSaveBallonData.setValue(strPhoneNo, forKey: "senderPhoneName")
                }
            }else{
                let strPhoneNo = arrTotalContactDetails[indexPath.row - 1].Phnumber
                SharedGlobalVariables.dicSaveBallonData.setValue(strPhoneNo, forKey: "senderPhoneName")
            }
        }
        searchBar.text = ""
        searchBar.showsCancelButton = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SENDVIAUPDATE"), object: nil, userInfo: nil)
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
