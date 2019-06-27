//
//  TermsAndConditionViewController.swift
//  E Balloon
//
//  Created by VAP on 22/11/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: UIViewController {
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var vwTextBack: UIView!
    @IBOutlet weak var txtViewCondition: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwTextBack.isHidden = true
        
        //view.isOpaque = false
        //view.backgroundColor = UIColor.clear
        
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previewViewPopUpTap)))
        self.WSAboutUsApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.vwTextBack.backgroundColor = UIColor.clear
        self.vwTextBack.layer.borderWidth = 6
        self.vwTextBack.layer.borderColor = UIColor.white.cgColor
    }
    
    func WSAboutUsApiCall() {
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
            self.vwTextBack.isHidden = false
            self.txtViewCondition.attributedText = attributedString
            self.txtViewCondition.textColor = UIColor.white
        }else{
            let strMessage = (dictJson.value(forKey: "message") is NSNull) ? "" : (dictJson.value(forKey: "message") as! String)
            SharedFunctions.ShowAlert(controller: self, message: strMessage)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
//        self.view.alpha = 1.0
//        UIView.animate (withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations:
//            {
//                self.view.alpha = 0.0
//                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//
//        }, completion: { _ in
//            self.removeFromParentViewController()
//            self.view.removeFromSuperview()
//            self.view.alpha = 1.0
//        })
    }
    
    @objc func previewViewPopUpTap(gesture : UITapGestureRecognizer) {
        self.view.alpha = 1.0
        UIView.animate (withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations:
            {
                self.view.alpha = 0.0
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                
        }, completion: { _ in
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            self.view.alpha = 1.0
            
        })
    }
    
    internal func ShowPopUpOnController(controller : UIViewController) {
        self.view.alpha = 0.0
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        controller.addChildViewController(self)
        controller.view.addSubview(self.view)
        
        UIView.animate (withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            
        })
    }
}
