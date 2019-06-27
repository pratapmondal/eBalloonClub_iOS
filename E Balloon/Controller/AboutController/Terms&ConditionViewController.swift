//
//  Terms&ConditionViewController.swift
//  E Balloon
//
//  Created by VAP on 07/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class TermsCondition:UITableViewCell{
    @IBOutlet weak var imgTermasCondition: UIImageView!
    @IBOutlet weak var txvTermsCondition: UITextView!
}

class TermsConditionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var tableviewtermsCondition: UITableView!
    var attributedString:NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewtermsCondition.estimatedRowHeight = 1000.0
        self.tableviewtermsCondition.rowHeight = UITableViewAutomaticDimension
        self.WSTermsAndConditionApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func navigationBarSetUp() {
        self.title = "Terms & Condition"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    
    
    func WSTermsAndConditionApiCall() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [AboutUsInfo.page_name : "eula_policy"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_ABOUT_US, parseApiMethod: "POST")
    }
    
    internal func parseDictTermsAndConditionApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let strAbout = (dictJson.value(forKey: "data") is NSNull) ? "" : (dictJson.value(forKey: "data") as! String)
            let htmlData = NSString(string: strAbout).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            tableviewtermsCondition.delegate = self
            tableviewtermsCondition.dataSource = self
            tableviewtermsCondition.reloadData()
        }else{
            let strMessage = (dictJson.value(forKey: "message") is NSNull) ? "" : (dictJson.value(forKey: "message") as! String)
            SharedFunctions.ShowAlert(controller: self, message: strMessage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCondition") as! TermsCondition
        cell.txvTermsCondition.attributedText = attributedString
        cell.txvTermsCondition.textColor = UIColor.black
        cell.selectionStyle = .none
        return cell
    }

}
