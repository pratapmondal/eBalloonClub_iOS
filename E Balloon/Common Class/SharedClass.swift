//
//  SharedClass.swift
//  Renting Street
//
//  Created by VAP on 11/05/17.
//  Copyright © 2017 VAP. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import ContactsUI

class SharedVariables {
    static var MAIN_URL = "https://www.eballoonclub.com/api/"
    static let WS_LOGIN = "login"
    static let WS_SignUp = "registration"
    static let WS_SOCIAL_LOGIN = "socialLoginApi"
    static let WS_CHANGE_PASSWORD = "change_password"
    static let WS_ABOUT_US = "get_cms"
    static let WS_MEMBERS_BENEFIT = "members_benefit"
    static let WS_FORGOT_PASSWORD = "forgot_password"
    static let WS_GET_CATEGORY_SUBCAT = "get_cat_subcat"
    static let WS_GET_MEMBERSHIP_DETAILS = "myProfile"
    static let WS_GET_CATEGORY = "all_category"
    static let WS_GET_AllCATEGORY = "view_all_subcategory"
    static let WS_GET_BACKGROUND_IMAGE = "background_image_list"
    static let WS_GET_USER_BACKGROUND_IMAGE = "background_image_list"
    static let WS_UPLOAD_BACKGROUND_IMAGE = "upload_background_image"
    static let WS_REMOVE_BACKGROUND_IMAGE = "remove_background_image"
    static let WS_GET_SOUND_EFFECT = "sound_effect_for_animation"
    static let WS_GET_USERPROFILE = "user_profile"
    static let WS_PROFILE_UPDATE = "edit_profile"
    static let WS_GET_ORDER_LIST = "order_list"
    static let WS_GET_NOTIFICATION = "notifications"
    static let WS_GET_SEND = "sending_list"
    static let WS_GET_REMINDERLIST = "allReminders"
    static let WS_GET_ADDRESSBOOK = "contact_list"
    static let WS_GET_RECIPITIENTDETAILS = "save_addreess_book"
    static let WS_GET_SOCIAL_SHARING_PRICE = "social_sharing_price"
    static let WS_GET_ADDRESS_EDIT = "edit_address_book"
    static let WS_BALLOON_SEND_VIA_MAIL = "send_via_mail"
    static let WS_BALLOON_SEND_VIA_TEXT = "send_via_text"
    static let WS_BALLOON_SEND_BALLOON_SOCIAL = "setSendForBalloon"
    
    static let WS_BALLOON_SAVE_MEMBER_ORDER = "save_member_order"
    static let WS_BALLOON_NON_MEMBER_ORDER = "save_non_member_order"
    static let WS_BALLOON_ACTIVE_MEMBERSHIP = "active_membership"
    static let WS_CANCEL_MEMBERSHIP = "cancel_membership_api"
    static let WS_ORDER_DETAILS = "order_details"
    static let WS_ALL_REMINDERS = "allReminders_month"
    static let WS_BALLOON_ACTIVE_MEMBERSHIP_API = "active_membership_api"
    static let WS_GET_COUPON = "get_coupon"
    static let WS_GET_MEMBER_LIST = "authorizeMemberPhone"
}

struct SharedGlobalVariables {
    static var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    static var loadingView: UIView = UIView()
    static var sharedColorCode:NSArray = ["#008d55","#6646b0","#005cb9","#8cc739","#0c2f42","#42a1e5","#DF0174","#f2c500","#555555","#FFFFFF","#01859e","#000000","#c80000","#F781BE","#FF8000","#00FF00","#0c2f42","#F8E0F1","#380B61","#848484","#FF0040","#b6b9e2"]
    static var dicSaveBallonData:NSMutableDictionary = NSMutableDictionary()
    static var dicPaymentData:NSDictionary = NSDictionary()
    //static var logoChangeProfileUpUpload:NSMutableDictionary = NSMutableDictionary()
    static var logoChangeProfilePicUpload = [String:UIImage]()
    static var GoogleLogInContollerCheck:Int = 1
    static var dicAnimationSound:NSDictionary = NSDictionary()
    static var intPageControl:Int = 1
    static var superViewSet:UIView = UIView()
    static var selectedViewController:String = String()
    static var errorBool:Bool = true
    static var arrContactListData:[CNContact] = [CNContact]()
}

// MARK : WEB SERVICE KEYS
class Login {
    static let email_id = "email_id"
    static let password = "password"
}
class ChangePassword {
    static let cust_id = "cust_id"
    static let password = "password"
    static let confirm_password = "confirm_password"
}

class SignUp {
    static let name = "name"
    static let email = "email"
    static let password = "password"
    static let conf_pass = "conf_pass"
}
class SocialLogin {
    static let oauth_type = "oauth_type"
    static let oauth_uid = "oauth_uid"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
}
//oauth_type:facebook
//oauth_uid:123456
//first_name:Test
//last_name:Facebook
//email:facebook@gmail.com

class AboutUsInfo {
   static let page_name = "page_name"
}
class GetCategoryData {
    static let page = "page"
    static let user_id = "user_id"
}
class Category {
    static let page = "page"
}
class AllCategory {
    static let page = "page"
    static let category_id = "category_id"
}
class BackgroundImage {
    static let page = "page"
    static let cust_id = "cust_id"
    static let id = "id"
    static let image = "image"
}

class RecipientDetails {
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let email = "email"
    static let phone = "phone"
    static let city = "city"
    static let state = "state"
    static let event = "event"
    static let event_date = "event_date"
    static let remind_me = "remind_me"
    static let user_id = "user_id"
    static let address_book_id = "address_book_id"
}


//Profile Page...
class UserProfile {
    static let user_id = "user_id"
    static let first_name = "first_name"
    static let phone = "phone"
}
class GetOrderList {
    static let user_id = "user_id"
    static let page = "page"
}
class Notification {
    static let user_id = "user_id"
    static let page = "page"
}
class SendList {
    static let user_id = "user_id"
    static let page = "page"
}
class ReminderList {
    static let cust_id = "cust_id"
    static let month = "month"
    static let year = "year"
}
class AddressBookList {
    static let user_id = "user_id"
    static let page = "page"
}
class BalloonSendViaMail {
    static let user_id = "user_id"
    static let to_email = "to_email"
    static let link = "link"
    static let order_id = "order_id"
    static let phone = "phone"
    static let type = "type"
}


class BalloonOrder {
    static let user_id = "user_id"
    static let balloon_color = "balloon_color"
    static let balloon_text_color = "balloon_text_color"
    static let balloon_font_family = "balloon_font_family"
    static let balloon_font_size = "balloon_font_size"
    static let balloon_message = "balloon_message"
    static let balloon_bg_image = "balloon_bg_image"
    static let balloon_animation = "balloon_animation"
    static let recording_file = "recording_file"
    static let sub_cat_id = "sub_cat_id"
    static let to_email = "to_email"
    static let sub_cat_name = "sub_cat_name"
    static let delivery_date = "delivery_date"
    static let reminder = "reminder"
    static let image_path = "image_path"
    static let cardno = "cardno"
    static let year = "year"
    static let month = "month"
    static let cvv = "cvv"
    static let email_check = "email_check"
    static let email = "email"
    static let facebook_check = "facebook_check"
    static let facebooksender_name = "facebooksender_name"
    static let twitter_check = "twitter_check"
    static let twitter_sender_name = "twitter_sender_name"
    static let sms_ckeck = "sms_ckeck"
    static let phone_no = "phone_no"
    static let name_on_card = "name_on_card"
    static let order_amount = "order_amount"
    static let user_email = "user_email"
    static let balloon_icon = "balloon_icon"
    static let card_no = "card_no"
    static let card_holder_name = "card_holder_name"
    static let yy = "yy"
    static let email_price = "email_price"
    static let facebook_price = "facebook_price"
    static let linkedin_price = "linkedin_price"
    static let twitter_price = "twitter_price"
    static let transaction_id = "transaction_id"
}
class AddMembershipPlan {
    static let user_id = "user_id"
    static let transaction_id = "transaction_id"
    static let previous_amount = "previous_amount"
    static let transaction_amount = "transaction_amount"
    static let coupon_applied = "coupon_applied"
}

class CouponDetails {
    static let coupon_code = "coupon_code"
}
enum ContactsFilter {
    case none
    case mail
    case message
}

// MARK : Global Messages string
class Messages {
    static let INTERNET_ERROR = "No internet connection please try again later"
    static let ERROR_OCCURS = "Error occurs please try again later"
    static let USER_EMAIL = "Please enter email address to continue"
    static let USER_PASSWORD = "Please enter password to continue"
    static let USER_NEW_PASSWORD = "Please enter new password to continue"
    static let USER_PASSWORD_CONFIRM = "Please enter confirm password to continue"
    static let USER_NAME = "Please enter user name to continue"
    static let USER_PASSWORD_LIMIT = "Please enter minimum 6 characters for password to continue"
    static let USER_CORRECT_EMAIL = "Please enter correct email format to continue"
    

    static let USER_OLD_PASSWORD = "Please enter old password to continue"
    
    
    static let TERMS_N_CONDITIONS = "Please agree terms & conditions to continue"
    static let AGE_CONFIRMATION = "Please confirm your desire age to continue"
    
    static let USER_FIRST_NAME = "Please enter first name to continue"
    static let USER_LAST_NAME = "Please enter last name to continue"
    static let COMPANY_NAME = "Please enter company to continue"
    static let USER_FULL_NAME = "Please enter full name to continue"
    static let USER_PH_NO = "Please enter phone number to continue"
    static let USER_DOB = "Please select date of birth to continue"
    static let USER_18YRS_DOB = "Please note! You have to be 18 years old to continue"
    static let USER_MISMATCHED_PASSWORD = "Password mismatched!"
    
    static let USER_PROFILE_PIC = "Please set profile image to continue"
    
    static let USER_ADDRESS = "Please enter address to continue"
    static let USER_LOCALITY = "Please enter locality to continue"
    static let USER_STREET = "Please enter street to continue"
    static let USER_CITY = "Please enter city to continue"
    static let USER_STATE = "Please enter state to continue"
    static let USER_EVENT_NAME = "Please enter the event name to continue"
    static let USER_EVENT_DATE = "Please enter the event date to continue"
    static let USER_REMIND_ME = "Please select remind to continue"
}

// MARK : Extension of Global Shared functions
class ActivityIndicator{
    func showActivityIndicatory(uiView: UIView) {
        
        SharedGlobalVariables.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        SharedGlobalVariables.loadingView.center = uiView.center
        SharedGlobalVariables.loadingView.backgroundColor = UIColorFromHex(rgbValue: 0xDA3D2D, alpha: 1.0)
        SharedGlobalVariables.loadingView.clipsToBounds = true
        SharedGlobalVariables.loadingView.layer.cornerRadius = 10
        
        SharedGlobalVariables.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        SharedGlobalVariables.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        SharedGlobalVariables.actInd.center = CGPoint(x: SharedGlobalVariables.loadingView.frame.size.width / 2, y: SharedGlobalVariables.loadingView.frame.size.height / 2)
        
        SharedGlobalVariables.loadingView.addSubview(SharedGlobalVariables.actInd)
        uiView.addSubview(SharedGlobalVariables.loadingView)
        uiView.isUserInteractionEnabled = false
        SharedGlobalVariables.actInd.startAnimating()
    }
    
    func hideActivityIndicatory(uiView: UIView) {
        uiView.isUserInteractionEnabled = true
        SharedGlobalVariables.actInd.stopAnimating()
        SharedGlobalVariables.loadingView.removeFromSuperview()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

class SharedFunctions {
    
    class func getContacts(filter: ContactsFilter = .none,controller:UIViewController) -> [CNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            SharedFunctions.ShowAlert(controller: controller, message: "Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                SharedFunctions.ShowAlert(controller: controller, message: "Error fetching containers")
            }
        }
        return results
    }
    
    class func ShowAlert(controller:UIViewController,message:String){
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        
        //Present the AlertController
        controller.present(actionSheetController, animated: true, completion: nil)
    }

    class func GetScreenResolution() ->CGSize{
        return UIScreen.main.bounds.size
    }
    
    class func createFontName(fontName:String) -> String {
        var selectedFontName:String?
        let fontName1 = fontName.components(separatedBy: " ")
        if fontName == "Arial Regular" {
            selectedFontName = fontName1[0]
        }else if fontName == "Open Sans" {
            selectedFontName = fontName1[0] + fontName1[1]
        }else if fontName == "Helvetica Regular" {
            selectedFontName = fontName1[0]
        }else if fontName == "Times New Roman" {
            selectedFontName = fontName
        }else if fontName == "Comic Sans MS" {
            selectedFontName = fontName
        }else{
            selectedFontName = fontName
        }
        return selectedFontName!
    }
    
    class func textToColorCode(colorCode:String) -> String{
        let start = colorCode.index(colorCode.startIndex, offsetBy: 1)
        let hexColor = String(colorCode[start...])
        return hexColor
    }
    class func createFontSize(fontSize:String) -> CGFloat {
        let fontSize = CGFloat((Float((fontSize.components(separatedBy: " "))[0])!) * 14.0 / 10.5)
        return fontSize
    }
    class func dateFormatChange(inputDate:String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: inputDate)
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    class func delivaryDateFormatChange(inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let showDate = inputFormatter.date(from: inputDate)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = outputFormatter.string(from: showDate!)
        return resultString
    }
    
    class func balloonAnimationChecked(intAnimation:Int) -> String {
        //["happy","sad"]
        var strAnimationSelection:String?
        if intAnimation == 0 {
            strAnimationSelection = "bounceInUp"
        }else if intAnimation == 1 {
            strAnimationSelection = "bounceInDown"
        }else if intAnimation == 2 {
            strAnimationSelection = "bounceInRight"
        }else if intAnimation == 3 {
            strAnimationSelection = "flipInY"
        }else if intAnimation == 4 {
            strAnimationSelection = "zoomInUp"
        }else if intAnimation == 5 {
            strAnimationSelection = "blust"
        }else if intAnimation == 6 {
            strAnimationSelection = "sing"
        }else if intAnimation == 7 {
            strAnimationSelection = "talk"
        }else if intAnimation == 8 {
            strAnimationSelection = "Buzzing"
        }else if intAnimation == 9 {
            strAnimationSelection = "bounce"
        }else if intAnimation == 10 {
            strAnimationSelection = "happy"
        }else{
            strAnimationSelection = "sad"
        }
        return strAnimationSelection!
    }
    
    
    
    class func callApi(controller:UIViewController , valuDict: Dictionary<String, String>, serviceName:String , parseApiMethod:String = "POST"){
        switch parseApiMethod {
        case "POST":
            var postEndpoint: String = String()
            postEndpoint = SharedVariables.MAIN_URL + serviceName
            // Alamofire 4.4
            Alamofire.request(postEndpoint, method: .post, parameters: valuDict)
                .responseJSON { response in
                    debugPrint(response)
                    
                    do {
                        if response.result.isSuccess == true {
                            if let json = response.result.value {
                                print("JSON: \(json)")
                                
                                let jsonDict = try JSONSerialization.jsonObject(with: (response.data)!, options: []) as! NSDictionary
                                
                            if (controller as? SignInViewController != nil) {
                                if serviceName == "socialLoginApi" {
                                    if valuDict["oauth_type"] == "facebook" {
                                        (controller as! SignInViewController).parseDictFacebookLoginApi(controller: controller,dictJson:jsonDict)
                                    }else{
                                        (controller as! SignInViewController).parseDictGoogleApi(controller: controller,dictJson:jsonDict)
                                    }
                                }else{
                                  (controller as! SignInViewController).parseDictLoginApi(controller: controller,dictJson:jsonDict)
                                }
                            }else if (controller as? ChangePasswordViewController != nil ) {
                                (controller as! ChangePasswordViewController).parseDictChangePasswordApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? AboutViewController != nil) {
                                (controller as! AboutViewController).parseDictAboutUsApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? MembershipViewController != nil) {
                                if serviceName == "active_membership_api" {
                                    (controller as! MembershipViewController).parseDictGetMemberBalloonOrderApi(controller: controller,dictJson:jsonDict)
                                }else if serviceName == "get_coupon" {
                                    (controller as! MembershipViewController).parseDictCouponDetailsApi(controller: controller,dictJson:jsonDict)
                                }else if serviceName == "myProfile" {
                                    (controller as! MembershipViewController).parseDictGetAccountMembershipDetailsApi(controller: controller,dictJson:jsonDict)
                                }else if serviceName == "cancel_membership_api" {
                                    (controller as! MembershipViewController).parseDictCancelMemberShipApi(controller: controller,dictJson:jsonDict)
                                }else{
                                    (controller as! MembershipViewController).parseDictMembershipDetailsApi(controller: controller, dictJson: jsonDict)
                                }
                            }else if (controller as? ForgotPasswordViewController != nil) {
                                (controller as! ForgotPasswordViewController).parseDictForgotPasswordApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? eBalloonClubViewController != nil) {
                                if serviceName == "myProfile" {
                                    (controller as! eBalloonClubViewController).parseDictGetMembershipDetailsApi(controller:controller, dictJson: jsonDict)
                                }else{
                                    (controller as! eBalloonClubViewController).parseDictGetCategoriesListApi(controller:controller, dictJson: jsonDict)
                                }
                            }else if (controller as? SignUpViewController != nil) {
                                if serviceName == "socialLoginApi" {
                                    if valuDict["oauth_type"] == "facebook" {
                                        (controller as! SignUpViewController).parseDictFacebookLoginApi(controller: controller,dictJson:jsonDict)
                                    }else{
                                        (controller as! SignUpViewController).parseDictSignUPGoogleApi(controller: controller,dictJson:jsonDict)
                                    }
                                }else{
                                    (controller as! SignUpViewController).parseDictSignUpApi(controller:controller, dictJson: jsonDict)
                                }
                            }else if (controller as? CategoryViewController != nil) {
                                (controller as! CategoryViewController).parseDictGetCategoryListApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? AllCataegoriesViewController != nil) {
                                (controller as! AllCataegoriesViewController).parseDictGetAllCategoriesListApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? backgroundImageViewController != nil){
                                if serviceName == "background_image_list" {
                                    (controller as! backgroundImageViewController).parseDictGetOwnBackgroundImageListApi(controller:controller, dictJson: jsonDict)
//                                }else if serviceName == "upload_background_image" {
//                                    (controller as! backgroundImageViewController).parseDictUploadBackgroundImageListApi(controller:controller, dictJson: jsonDict)
                                }else if serviceName == "remove_background_image" {
                                    (controller as! backgroundImageViewController).parseDictRemoveBackgroundImageListApi(controller:controller, dictJson: jsonDict)
                                }else{
                                   (controller as! backgroundImageViewController).parseDictGetAnimationListApi(controller:controller, dictJson: jsonDict)
                                }
                            }else if (controller as? eBalloonAnimationViewController != nil) {
                                (controller as! eBalloonAnimationViewController).parseDictGetAnimationSoundEffectListApi(controller:controller, dictJson: jsonDict)
                            }else if (controller as? MyAccountViewController != nil) {
                                if serviceName == "edit_profile" {
                                    (controller as! MyAccountViewController).parseDictUserProfileUpdateApi(controller:controller,dictJson:jsonDict)
                                }else if serviceName == "cancel_membership_api" {
                                    (controller as! MyAccountViewController).parseDictCancelMemberShipApi(controller:controller,dictJson:jsonDict)
                                }else if serviceName == "myProfile" {
                                    (controller as! MyAccountViewController).parseDictGetAccountMembershipDetailsApi(controller:controller,dictJson:jsonDict)
                                }else{
                                   (controller as! MyAccountViewController).parseDictGetUserProfileApi(controller:controller,dictJson:jsonDict)
                                }
                            }else if (controller as? MyOrderViewController != nil) {
                                (controller as! MyOrderViewController).parseDictGetMyOrderApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? NotificationViewController != nil) {
                                (controller as! NotificationViewController).parseDictGetNotificationApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? SendViewController != nil) {
                                if serviceName == "send_via_text" {
                                    (controller as! SendViewController).parseDictCallThroughBalloonSendApi(controller:controller,dictJson:jsonDict)
                                }else if serviceName == "send_via_mail" {
                                    (controller as! SendViewController).parseDictMailThroughBalloonSendApi(controller:controller,dictJson:jsonDict)
                                }else if serviceName == "setSendForBalloon" {
                                    (controller as! SendViewController).parseDictSocialThroughBalloonSendApi(controller:controller,dictJson:jsonDict)
                                }else{
                                   (controller as! SendViewController).parseDictGetSendApi(controller:controller,dictJson:jsonDict)
                                }
                            }else if (controller as? RecipientDetailsViewController != nil) {
                                (controller as! RecipientDetailsViewController).parseDictSaveApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? ReminderListViewController != nil) {
                                (controller as! ReminderListViewController).parseDictGetReminderApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? AddressBookViewController != nil) {
                                (controller as! AddressBookViewController).parseDictGetAddressBookApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? SendviaViewController != nil) {
                                (controller as! SendviaViewController).parseDictGetSocialSharingPriceListApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? TermsConditionViewController != nil) {
                                (controller as! TermsConditionViewController).parseDictTermsAndConditionApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? OrderDetailsViewController != nil) {
                                (controller as! OrderDetailsViewController).parseDictGetOrderDetailsApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? CalenderDetailsViewController != nil){
                                (controller as! CalenderDetailsViewController).parseDictGetReminderListApi(controller:controller,dictJson:jsonDict)
                            }else if (controller as? TermsAndConditionViewController != nil) {
                                (controller as! TermsAndConditionViewController).parseDictAboutUsApi(controller: controller, dictJson: jsonDict)
                            }else if (controller as? ContactViewController != nil) {
                                (controller as! ContactViewController).parseDictBalloonContactApi(controller: controller, dictJson: jsonDict)
                                }
                            }else{
                                print("error1")
                                ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                                SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                            }
                        }else{
                            print("error2")
                            ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                            SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                        }
                        
                    }catch{
                        print("error3")
                        ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                        SharedFunctions.ShowAlert(controller: controller, message:Messages.INTERNET_ERROR)
                    }
            }
            
            break
            
        case "GET" :
            var postEndpoint: String = SharedVariables.MAIN_URL + serviceName
            
            if serviceName == "products?page=" {
                postEndpoint = postEndpoint + "\(valuDict["pageCount"]!)"
                
            }/*else if serviceName == "removeWishList" {
             postEndpoint = SharedVariables.MAIN_URL + "?action=\(serviceName)" + "&id=\(valuDict["id"]!)&pid=\(valuDict["pid"]!)"
             
             }*/
            
            print(postEndpoint)
            
            Alamofire.request(postEndpoint, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON
                { (response:DataResponse<Any>) in
                    
                    switch(response.result) {
                    case .success(_):
                        if response.result.value != nil{
                            print(response.result.value!)
                            
                            let jsonDict = response.result.value as! NSDictionary
                            /*if (controller as? Category1ViewController != nil) {
                                (controller as! Category1ViewController).parseDictCategoryApi(controller: controller,dictJson:jsonDict)
                            }else if (controller as? Category2ViewController != nil) {
                                (controller as! Category2ViewController).parseDictCategoryApi(controller: controller,dictJson:jsonDict)
                            }else if (controller as? ProductViewController != nil) {
                                (controller as! ProductViewController).parseDictProductApi(controller: controller,dictJson:jsonDict)
                            }
                             */
                            
                            /*if (controller as? CartViewController != nil) {
                             if serviceName == "getcart" {
                             (controller as! CartViewController).parseDictCartListApi(controller: controller,dictJson:jsonDict)
                             }else if serviceName == "delete" {
                             (controller as! CartViewController).parseDictDeleteCartListApi(controller: controller,dictJson:jsonDict)
                             }
                             }else if (controller as? LoginViewController != nil) {
                             (controller as! LoginViewController).parseDictCartListApi(controller: controller,dictJson:jsonDict)
                             }else if (controller as? WishListViewController != nil) {
                             if serviceName == "removeWishList" {
                             (controller as! WishListViewController).parseDictDeleteWishListApi(controller: controller,dictJson:jsonDict)
                             }
                             }*/
                        }
                        
                        break
                    case .failure(_):
                        print(response.result.error!)
                        break
                    }
            }
            
            
            break
            
           
        case "UPLOAD" :
            let postEndpoint: String = SharedVariables.MAIN_URL + serviceName
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                print(SharedGlobalVariables.logoChangeProfilePicUpload.count)
                for index in 0 ..< SharedGlobalVariables.logoChangeProfilePicUpload.count {
                    let itemKey = Array(SharedGlobalVariables.logoChangeProfilePicUpload)[index].key
                    let imgData:Data = UIImageJPEGRepresentation(Array(SharedGlobalVariables.logoChangeProfilePicUpload)[index].value, 0.6)!
                    if serviceName == "upload_background_image" {
                        multipartFormData.append(imgData, withName: BackgroundImage.image, fileName: "\(itemKey).jpeg", mimeType: "image/jpeg")
                    }else{
                        multipartFormData.append(imgData, withName: BalloonOrder.balloon_icon, fileName: "\(itemKey).jpeg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, value) in valuDict {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to:postEndpoint)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        do {
                            if response.result.isSuccess == true {
                                if let json = response.result.value {
                                    print("JSON: \(json)")
                                    
                                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data)!, options: []) as! NSDictionary
                                    
                                    if (controller as? SendviaViewController != nil) {
                                        (controller as! SendviaViewController).parseDictGetMemberBalloonOrderApi(controller: controller,dictJson:jsonDict)
                                    }else if (controller as? PaymentViewController != nil) {
                                        if serviceName == "active_membership" {
                                            (controller as! PaymentViewController).parseDictGetMembershipApi(controller: controller,dictJson:jsonDict)
                                        }else{
                                            (controller as! PaymentViewController).parseDictGetNonMemberBalloonOrderApi(controller: controller,dictJson:jsonDict)
                                        }
                                    }else if (controller as? backgroundImageViewController != nil) {
                                        (controller as! backgroundImageViewController).parseDictUploadBackgroundImageListApi(controller: controller,dictJson:jsonDict)
                                    }
                                    
                                    /*if (controller as? AccountCreatViewController != nil) {
                                     (controller as! AccountCreatViewController).parseDictProfileApi(controller: controller,dictJson:jsonDict)
                                     }*/
                                    
                                }else{
                                    print("error1")
                                    ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                                    SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                                    
                                }
                            }else{
                                print("error2")
                                ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                                SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                            }
                            
                        }catch{
                            print("error3")
                            ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                            SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                        }
                        
                    }
                    break
                    
                case .failure(let encodingError):
                    
                    print(encodingError.localizedDescription)
                    ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                    SharedFunctions.ShowAlert(controller: controller, message:encodingError.localizedDescription)
                    
                    break
                }
            }
            
            break
            
        /*case "UPLOAD" :
            let postEndpoint: String = SharedVariables.MAIN_URL + serviceName
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                //SharedGlobalVariables.logoChangeProfileUpUpload["fileToUpload"]
                print(SharedGlobalVariables.logoChangeProfilePicUpload.count)
                for index in 0 ..< SharedGlobalVariables.logoChangeProfilePicUpload.count {
                    let itemKey = Array(SharedGlobalVariables.logoChangeProfilePicUpload)[index].key
                    let imgData:Data = UIImageJPEGRepresentation(Array(SharedGlobalVariables.logoChangeProfilePicUpload)[index].value, 0.6)!
                    multipartFormData.append(imgData, withName: "profile_image", fileName: "\(itemKey).jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in valuDict {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to:postEndpoint)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        do {
                            if response.result.isSuccess == true {
                                if let json = response.result.value {
                                    print("JSON: \(json)")
                                    
                                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data)!, options: []) as! NSDictionary
                                    
                                    /*if (controller as? AccountCreatViewController != nil) {
                                        (controller as! AccountCreatViewController).parseDictProfileApi(controller: controller,dictJson:jsonDict)
                                    }*/
                                    
                                }else{
                                    print("error1")
                                    ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                                    SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                                    
                                }
                            }else{
                                print("error2")
                                ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                                SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                            }
                            
                        }catch{
                            print("error3")
                            ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                            SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                        }
                        
                    }
                    break
                    
                case .failure(let encodingError):
                    
                    print(encodingError.localizedDescription)
                    ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                    SharedFunctions.ShowAlert(controller: controller, message:encodingError.localizedDescription)
                    
                    break
                }
            }
            
            break
            */
        case "OTHER" :
            var postEndpoint: String = String()
            var dict:NSMutableDictionary = NSMutableDictionary()
            
            /*if serviceName == "cart" {
                postEndpoint = SharedVariables.MAIN_URL1 + "\(serviceName)/v2/addproducts/"
                dict = SharedGlobalVariables.DICT_ADD_TO_CART
            }else if serviceName == "updatecart" {
                postEndpoint = SharedVariables.MAIN_URL1 + "cart/v2/updateproducts/"
                dict = SharedGlobalVariables.DICT_UPDATE_TO_CART
            }else{
                postEndpoint = SharedVariables.MAIN_URL1 + "\(serviceName)/v2/createorder/"
                dict = SharedGlobalVariables.DICT_PLACE_ORDER
            }*/
            
            let url = NSURL(string: "\(postEndpoint)" as String)
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = try! JSONSerialization.data(withJSONObject: dict , options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            if let json = json {
                print(json)
            }
            
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            let alamoRequest = Alamofire.request(request as URLRequestConvertible)
            alamoRequest.validate(statusCode: 200..<300)
            alamoRequest.responseString { response in
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: (response.data)!, options: []) as! NSDictionary
                    print(jsonDict)
                    
                    switch response.result {
                    case .success:
                        print("success")
                        ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                        //                        if (controller as? PaymentStep1ViewController != nil) {
                        //                            (controller as! PaymentStep1ViewController).parseDictPlaceOrderApi(controller: controller,dictJson:jsonDict)
                        //                        }else if (controller as? ProductDetailsViewController != nil) {
                        //                           (controller as! ProductDetailsViewController).parseDictAddToCartApi(controller: controller,dictJson:jsonDict)
                        //                        }else if (controller as? CartViewController != nil) {
                        //                            (controller as! CartViewController).parseDictUpdateCartListApi(controller: controller,dictJson:jsonDict)
                        //                        }
                        
                        break
                    case .failure(let encodingError):
                        print(encodingError.localizedDescription)
                        ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                        SharedFunctions.ShowAlert(controller: controller, message:encodingError.localizedDescription)
                        break
                    }
                }catch{
                    print("error")
                    ActivityIndicator().hideActivityIndicatory(uiView: controller.view)
                    SharedFunctions.ShowAlert(controller: controller, message:Messages.ERROR_OCCURS)
                }
            }
            break
        default:
            break
            
        }
    }
}

// MARK : Extension of System Objects
/*
 extension NSMutableAttributedString {
 func bold(text:String) -> NSMutableAttributedString {
 let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "OpenSans-LightItalic", size: 12)!]
 let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
 self.append(boldString)
 return self
 }
 
 func normal(text:String)->NSMutableAttributedString {
 let normal =  NSAttributedString(string: text)
 self.append(normal)
 return self
 }
 
 }*/

extension Date {
    func toString(myDate: String, myDateFormat: String, returnDateFormat: String) -> String {
        if(myDate == "" || myDate == "null" || myDate == "0000-00-00") {
            return "00/00/0000"
        }else{
            let dateString = myDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = myDateFormat
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            
            let dateObj = dateFormatter.date(from: dateString)
            
            dateFormatter.dateFormat = returnDateFormat
            let newDate = dateFormatter.string(from: dateObj!)
            //print(newDate) //New formatted Date string
            return newDate
        }
    }
    
        
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedStringKey, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension String {
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    func validateNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.image = anyImage
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        // Position Activity Indicator in the center of the main view
        //myActivityIndicator.center = inView.center
        myActivityIndicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        //If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        //myActivityIndicator.hidesWhenStopped = true
        //myActivityIndicator.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        self.addSubview(myActivityIndicator)
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                myActivityIndicator.stopAnimating()
                myActivityIndicator.removeFromSuperview()
                self.layer.masksToBounds = true
                self.layer.borderWidth = 0.0
                self.layer.borderColor = UIColor.clear.cgColor
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

extension String {
    var length: Int { return self.characters.count }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
extension UIView:Explodable {
    
}


func scaleUIImageToSize( image: UIImage, size: CGSize) -> UIImage {
    let hasAlpha = false
    let scale: CGFloat = 0.0
    //Automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.draw(in: CGRect(origin: CGPoint.zero, size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage!
}

class PageControlCustom: UIPageControl {
    
    var activeImage: UIImage! = UIImage(named: "active_dot")
    
    var inactiveImage: UIImage! = UIImage(named: "inactive_dot")
    
    override var currentPage: Int {
        
        willSet {
            
            self.updateDots()
            
        }
        
    }
    
    convenience init(activeImage: UIImage, inactiveImage: UIImage) {
        
        self.init()
        
        self.activeImage = activeImage
        
        self.inactiveImage = inactiveImage
        
        self.pageIndicatorTintColor = UIColor.clear
        
        self.currentPageIndicatorTintColor = UIColor.clear
        
    }
    
    func updateValues(value:Int){
        
        self.currentPage = value
        
        updateDots()
        
    }
    
    func updateDots() {
        
        for i in 0 ..< subviews.count {
            
            let view: UIView = subviews[i]
            
            if view.subviews.count == 0 {
                
                self.addImageViewOnDotView(view: view, imageSize: activeImage.size)
                
            }
            
            let imageView: UIImageView = view.subviews.first as! UIImageView
            
            imageView.image = self.currentPage == i ? activeImage : inactiveImage
            
        }
        
    }
    
    // MARK: - Private
    
    func addImageViewOnDotView(view: UIView, imageSize: CGSize) {
        
        var frame = view.frame
        
        frame.origin = CGPoint.zero
        
        frame.size = imageSize
        
        let imageView = UIImageView(frame: frame)
        
        imageView.contentMode = UIViewContentMode.scaleToFill
        
        view.addSubview(imageView)
        
    }
    
}

//extension Request {
//    public func debugLog() -> Self {
//        #if DEBUG
//            debugPrint(self)
//        #endif
//        return self
//    }
//}
