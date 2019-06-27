//
//  AboutViewController.swift
//  E Balloon
//
//  Created by VAP on 13/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var UIviewAbout: UIView!
    @IBOutlet weak var txtAboutUs: UITextView!
    var strTermsCondition:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        self.UIviewAbout.isHidden = true
        if strTermsCondition == "1" {
            self.WSTermsConditionApiCall()
        }else{
            self.WSAboutUsApiCall()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if strTermsCondition == "1" {
            self.title = "Eula Policy"
        }else{
            self.title = "About"
        }
        self.navigationBarSetUp()
    }
    func WSAboutUsApiCall() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [AboutUsInfo.page_name : "about_us"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_ABOUT_US, parseApiMethod: "POST")
    }
    func WSTermsConditionApiCall() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [AboutUsInfo.page_name : "eula_policy"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_ABOUT_US, parseApiMethod: "POST")
    }
    
    internal func parseDictAboutUsApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let strAbout = (dictJson.value(forKey: "data") is NSNull) ? "" : (dictJson.value(forKey: "data") as! String)
            let htmlData = NSString(string: strAbout).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            self.UIviewAbout.isHidden = false
            self.txtAboutUs.attributedText = attributedString
            self.txtAboutUs.textColor = UIColor.white
        }else{
            let strMessage = (dictJson.value(forKey: "message") is NSNull) ? "" : (dictJson.value(forKey: "message") as! String)
            SharedFunctions.ShowAlert(controller: self, message: strMessage)
        }
    }
    
    
    
    func navigationBarSetUp() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.UIviewAbout.backgroundColor = UIColor.clear
        self.UIviewAbout.layer.borderWidth = 6
        self.UIviewAbout.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
