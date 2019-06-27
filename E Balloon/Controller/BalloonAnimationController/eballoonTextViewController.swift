//
//  eballoonTextViewController.swift
//  E Balloon
//
//  Created by VAP on 08/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift



class MessageCell:UITableViewCell{
    @IBOutlet weak var lblCharacters: UILabel!
    @IBOutlet weak var imgbackGround: UIImageView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var txtView: UITextView!
}

class chooseStyleCell:UITableViewCell{
    @IBOutlet weak var lblchooseStyle: UILabel!
    @IBOutlet weak var btnFront: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
}

class eballoonTextViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var tablevieweballoonText: UITableView!
    var strBalloonInnerText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
    
    let arrFontName:NSArray = ["Select","Arial Regular","Open Sans","Helvetica Regular","Times New Roman","Comic Sans MS","American Typewriter"]
    let arrFontSize:NSArray = ["Select","8 pt","9 pt","10 pt","11 pt"]
    var selectDropDown:Int = 0
    var strSelectFont:String = ""
    var strSelectFontSize:String = ""
    var strBalloonId:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetUp()
        if SharedGlobalVariables.intPageControl == 1 {
            self.title = "Select eBalloon Font Style"
        }else{
            self.title = "Select eBalloon Font Size"
        }
        strBalloonInnerText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
        tablevieweballoonText.delegate = self
        tablevieweballoonText.dataSource = self
        tablevieweballoonText.reloadData()
    }
    
    func navigationBarSetUp() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(eballoonTextViewController.clickButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(eballoonTextViewController.backButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func clickButton() {
        self.view.endEditing(true)
        if SharedGlobalVariables.intPageControl == 1 {
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eballoonTextViewController") as! eballoonTextViewController
            SharedGlobalVariables.intPageControl = 2
            SharedGlobalVariables.dicSaveBallonData.setValue(strBalloonInnerText, forKey: "description")
            SharedGlobalVariables.dicSaveBallonData.setValue(((strSelectFontSize == "" || strSelectFontSize == "Select") ? "8 pt" : strSelectFontSize), forKey: "BalloonInnerTextFontSize")
            SharedGlobalVariables.dicSaveBallonData.setValue(((strSelectFont == "" || strSelectFont == "Select") ? "Arial Regular" : strSelectFont), forKey: "BallonInnerTextFontName")
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }else{
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "backgroundImageViewController") as! backgroundImageViewController
            SharedGlobalVariables.dicSaveBallonData.setValue(strBalloonInnerText, forKey: "description")
            SharedGlobalVariables.dicSaveBallonData.setValue(((strSelectFont == "" || strSelectFont == "Select") ? "Arial Regular" : strSelectFont), forKey: "BallonInnerTextFontName")
            SharedGlobalVariables.dicSaveBallonData.setValue(((strSelectFontSize == "" || strSelectFontSize == "Select") ? "8 pt" : strSelectFontSize), forKey: "BalloonInnerTextFontSize")
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
            self.navigationController?.pushViewController(controllerObj, animated: true)

        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Tableview Delagate and Data
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 290.0
        }else if indexPath.row == 1{
            return 90.0
        }else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as!  MessageCell
            var finalFontName:String?
            print(strSelectFont)
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") == nil {
                let textFontName = (strSelectFont == "" || strSelectFont == "Select") ? "Arial Regular" : strSelectFont
                finalFontName = SharedFunctions.createFontName(fontName: textFontName)
            }else{
                let textFontName = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as! String
                finalFontName = SharedFunctions.createFontName(fontName: textFontName)
            }
            var finalFontSize:CGFloat?
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") == nil {
                let textFontSize:String = (strSelectFontSize == ""  || strSelectFontSize == "Select") ? "8 pt" : strSelectFontSize
                finalFontSize = CGFloat((Float((textFontSize.components(separatedBy: " "))[0])!) * 14.0 / 10.5)
            }else{
                let textFontSize = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as! String
                finalFontSize = CGFloat((Float((textFontSize.components(separatedBy: " "))[0])!) * 14.0 / 10.5)
            }
            
            let balloonTextColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as! String
            
            let myTitle = NSAttributedString(string: strBalloonInnerText , attributes: [NSAttributedStringKey.font:UIFont(name: finalFontName!, size: finalFontSize!)!,NSAttributedStringKey.foregroundColor:UIColor(hex:SharedFunctions.textToColorCode(colorCode: balloonTextColor))])
            cell.txtView.attributedText = myTitle
            cell.txtView.textAlignment = .center
            
            cell.txtView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
            cell.txtView.layer.borderWidth = 1.0
            cell.txtView.layer.masksToBounds = true
            if strBalloonId == "29" {
                cell.imgBalloon.image = UIImage(named: "flag-balloon")
            }else{
                cell.imgBalloon.image = cell.imgBalloon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
                cell.imgBalloon.tintColor = UIColor(hex : SharedFunctions.textToColorCode(colorCode: balloonColor))
            }
            cell.txtView.autocorrectionType = .no
            cell.txtView.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseStyleCell", for: indexPath) as!  chooseStyleCell
            if SharedGlobalVariables.intPageControl == 1 {
                cell.lblchooseStyle.text = "Choose Font Style"
                cell.btnFront.addTarget(self, action: #selector(selectFont(_:)), for: .touchUpInside)
                if strSelectFont == "" || strSelectFont == "Select" {
                    cell.btnFront.setTitle("Select", for: .normal)
                }else{
                    cell.btnFront.setTitle(strSelectFont, for: .normal)
                }
            }else{
                cell.btnFront.addTarget(self, action: #selector(selectFontSize(_:)), for: .touchUpInside)
                cell.lblchooseStyle.text = "Choose Font Size"
                if strSelectFontSize == "" || strSelectFontSize == "Select" {
                    cell.btnFront.setTitle("8 pt", for: .normal)
                }else{
                    cell.btnFront.setTitle(strSelectFontSize, for: .normal)
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseStyleCell", for: indexPath) as!  chooseStyleCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    @objc func selectFont(_ btn:UIButton){
        selectDropDown = 1
        self.getFontDetailsListPopUp(headerMessage: "Select the font name.")
    }
    @objc func selectFontSize(_ btn:UIButton){
        selectDropDown = 2
        self.getFontDetailsListPopUp(headerMessage: "Select the font size.")
    }
    
    func getFontDetailsListPopUp(headerMessage:String){
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
            self.tablevieweballoonText.reloadData()
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
        if (selectDropDown == 1){
            return arrFontName.count
        }else{
            return arrFontSize.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (selectDropDown == 1) {
            strSelectFont = arrFontName.object(at: row) as! String
            if row == 0 {
                strSelectFont = "American Typewriter"
            }
            SharedGlobalVariables.dicSaveBallonData.setValue(strSelectFont, forKey: "BallonInnerTextFontName")
        }else{
            strSelectFontSize = arrFontSize.object(at: row) as! String
            SharedGlobalVariables.dicSaveBallonData.setValue(strSelectFontSize, forKey: "BalloonInnerTextFontSize")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (selectDropDown == 1) {
            return arrFontName.object(at: row) as? String
        }else{
            return arrFontSize.object(at: row) as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if (selectDropDown == 1) {
            let strFontName = (arrFontName.object(at: row) as? String)!
            let myTitle = NSAttributedString(string: strFontName , attributes: [NSAttributedStringKey.font:UIFont(name: "OpenSans", size: 12.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            return myTitle
        }else{
            let strFontSize = (arrFontSize.object(at: row) as? String)!
            let myTitle = NSAttributedString(string: strFontSize , attributes: [NSAttributedStringKey.font:UIFont(name: "OpenSans", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.black])
            return myTitle
        }
    }
    
    //MARK: TextView Delegate...
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let cell = tablevieweballoonText.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! MessageCell
        strBalloonInnerText = textView.text
        cell.txtView.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let cell = tablevieweballoonText.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! MessageCell
        strBalloonInnerText = textView.text
        cell.txtView.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cell = tablevieweballoonText.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! MessageCell
        var finalFontName:String?
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") == nil {
            let textFontName = (strSelectFont == "" || strSelectFont == "Select") ? "Arial Regular" : strSelectFont
            finalFontName = SharedFunctions.createFontName(fontName: textFontName)
        }else{
            let textFontName = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as! String
            finalFontName = SharedFunctions.createFontName(fontName: textFontName)
        }
        var finalFontSize:CGFloat?
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") == nil {
            let textFontSize:String = (strSelectFontSize == ""  || strSelectFontSize == "Select") ? "8 pt" : strSelectFontSize
            finalFontSize = CGFloat((Float((textFontSize.components(separatedBy: " "))[0])!) * 14.0 / 10.5)
        }else{
            let textFontSize = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as! String
            finalFontSize = CGFloat((Float((textFontSize.components(separatedBy: " "))[0])!) * 14.0 / 10.5)
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let balloonTextColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as! String
        cell.txtView.attributedText = NSAttributedString(string: textView.text , attributes: [NSAttributedStringKey.font:UIFont(name: finalFontName!, size: finalFontSize!)!,NSAttributedStringKey.foregroundColor:UIColor(hex:SharedFunctions.textToColorCode(colorCode: balloonTextColor))])
        cell.txtView.textAlignment = .center
        let numberOfChars = newText.count
        return numberOfChars < 50
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let cell = tablevieweballoonText.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! MessageCell
        cell.txtView.endEditing(true)
    }
    
    @objc func backButton() {
        if SharedGlobalVariables.intPageControl == 1 {
            SharedGlobalVariables.intPageControl = 1
        }else{
            SharedGlobalVariables.intPageControl = 1
        }
        self.navigationController?.popViewController(animated: true)
    }
}
