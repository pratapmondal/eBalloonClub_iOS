//
//  SendViewController.swift
//  E Balloon
//
//  Created by VAP on 04/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class sendCell:UITableViewCell{
    @IBOutlet weak var lbleballoonSchedule: UILabel!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgCall: UIImageView!
    @IBOutlet weak var imgMail: UIImageView!
    @IBOutlet weak var imgFacebook: UIImageView!
    @IBOutlet weak var imgTwitter: UIImageView!
    
    @IBOutlet weak var constaintCallWidth: NSLayoutConstraint!
    @IBOutlet weak var constaintTwiterWidth: NSLayoutConstraint!
    @IBOutlet weak var constaintFacebookWidth: NSLayoutConstraint!
    @IBOutlet weak var constaintMailWidth: NSLayoutConstraint!
    
    @IBOutlet weak var constaintTwitterLeading: NSLayoutConstraint!
    @IBOutlet weak var constaintFacebookLeading: NSLayoutConstraint!
    @IBOutlet weak var constaintMailLeading: NSLayoutConstraint!
}


class SendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableviewSend: UITableView!
    var sendList:NSMutableArray = NSMutableArray()
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    var footerLabel : UILabel = UILabel()
    var pageTrack:String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Send"
        currentPageCount = 0
        self.WSGetSend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblNoDataFound.isHidden = true
        self.navigationBarSetup()
        paginationCall = false
    }
    
    @objc func backButton(_ btn:UIButton) {
        if pageTrack == "0" {
            self.navigationController?.popViewController(animated: true)
        }else{
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
    }
    
    
    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let backButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(self.backButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    
    //MARK: Webservice call...
    func WSGetSend() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [SendList.user_id : UserDefaults.standard.value(forKey: "custid") as! String ,SendList.page : String(currentPageCount)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_SEND, parseApiMethod: "POST")
    }
    
    internal func parseDictGetSendApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            if ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as AnyObject).count > 0{
                if(paginationCall){
                    let totalCount = Double(dictJson.value(forKey: "total_data_count") as! Int)
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
                    
                    let featuredArr = (dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as! NSArray
                    for index in 0 ..< featuredArr.count {
                        let strPhone = (featuredArr.object(at: index) as AnyObject).value(forKey: "linkedin_send") as! String
                        let strEmail:String = (featuredArr.object(at: index) as AnyObject).value(forKey: "email_send") as! String
                        let strfacebook = (featuredArr.object(at: index) as AnyObject).value(forKey: "facebook_send") as! String
                        let strTwitter = (featuredArr.object(at: index) as AnyObject).value(forKey: "twitter_send") as! String
                        
                        if strPhone == "1" || strEmail == "1" || strfacebook == "1" || strTwitter == "1" {
                            sendList.add(featuredArr.object(at: index))
                        }
                    }
                }else{
                    sendList.removeAllObjects()
                    let totalCount = Double(dictJson.value(forKey: "total_data_count") as! Int)
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
                    
                    
                    let bb:NSArray = (dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as! NSArray
                    for index in 0 ..< bb.count {
                        let strPhone = (bb.object(at: index) as AnyObject).value(forKey: "linkedin_send") as! String
                        let strEmail:String = (bb.object(at: index) as AnyObject).value(forKey: "email_send") as! String
                        let strfacebook = (bb.object(at: index) as AnyObject).value(forKey: "facebook_send") as! String
                        let strTwitter = (bb.object(at: index) as AnyObject).value(forKey: "twitter_send") as! String
                        
                        if strPhone == "1" || strEmail == "1" || strfacebook == "1" || strTwitter == "1" {
                            sendList.add(bb.object(at: index))
                        }
                    }
                }
                self.tableviewSend.delegate = self
                self.tableviewSend.dataSource = self
                self.tableviewSend.reloadData()
            }else{
                if(!paginationCall){
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
                }
                self.tableviewSend.isHidden = true
                self.lblNoDataFound.isHidden = false
                let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
                lblNoDataFound.text = errorMsg
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            self.lblNoDataFound.isHidden = false
            self.tableviewSend.isHidden = true
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
                self.WSGetSend()
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
            self.tableviewSend.tableFooterView = nil
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Tableview delegate and datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as!  sendCell
            let sendDate = (((sendList.object(at: indexPath.row) as AnyObject).value(forKey: "package_deatils") as AnyObject).value(forKey: "delivery_date") is NSNull) ? "" : (((sendList.object(at: indexPath.row) as AnyObject).value(forKey: "package_deatils") as AnyObject).value(forKey: "delivery_date") as! String)
            cell.lblDate.text = sendDate
            
            cell.lbleballoonSchedule.text = (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "message") is NSNull ? "" : (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "message") as! String
            let strPhone:String = (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "linkedin_send") as! String
            
            if strPhone == "0" {
                cell.constaintCallWidth.constant = 0.0
            }else{
                cell.constaintCallWidth.constant = 34.0
            }
            
            
            
            let strEmail:String = (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "email_send") as! String
            if strEmail == "0" {
                cell.constaintMailWidth.constant = 0.0
                cell.constaintMailLeading.constant = 0.0
            }else{
                cell.constaintMailWidth.constant = 34.0
                cell.constaintMailLeading.constant = 5.0
            }
            let strTwitter = (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "twitter_send") as! String
            if strTwitter == "0" {
                cell.constaintTwiterWidth.constant = 0.0
                cell.constaintTwitterLeading.constant = 0.0
            }else{
                cell.constaintTwiterWidth.constant = 34.0
                cell.constaintTwitterLeading.constant = 5.0
            }
            
            let strfacebook = (sendList.object(at: indexPath.row) as AnyObject).value(forKey: "facebook_send") as! String
            if strfacebook == "0" {
                cell.constaintFacebookWidth.constant = 0.0
                cell.constaintFacebookLeading.constant = 0.0
            }else{
                cell.constaintFacebookWidth.constant = 34.0
                cell.constaintFacebookLeading.constant = 5.0
            }
            
            cell.imgCall.isUserInteractionEnabled = true
            cell.imgTwitter.isUserInteractionEnabled = true
            cell.imgFacebook.isUserInteractionEnabled = true
            cell.imgMail.isUserInteractionEnabled = true
            
            cell.imgCall.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callAction(_:))))
            cell.imgTwitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitterAction(_:))))
            cell.imgFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookAction(_:))))
            cell.imgMail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mailAction(_:))))
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendCell", for: indexPath) as!  sendCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    @objc func callAction(_ gesture:UITapGestureRecognizer) {
        let location: CGPoint = gesture.location(in: tableviewSend)
        let indexpath: IndexPath? = tableviewSend.indexPathForRow(at: location)
        let strOrderId = ((sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") is NSNull) ? "" : (sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") as! String
        let strBase64OrderId = "https://www.eballoonclub.com/preview/index/" + strOrderId.toBase64()
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonSendViaMail.user_id : UserDefaults.standard.value(forKey: "custid") as! String ,BalloonSendViaMail.phone : ((sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "linkendin_recipent_name") is NSNull ? "" : (sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "linkendin_recipent_name") as! String),BalloonSendViaMail.link: strBase64OrderId,BalloonSendViaMail.order_id : ((sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "order_id") is NSNull ? "" : (sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "order_id") as! String)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_SEND_VIA_TEXT, parseApiMethod: "POST")
    }

    
    internal func parseDictCallThroughBalloonSendApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.showAlertWithReloadData(message: "Successfully sent!")
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
    }
    @objc func twitterAction(_ gesture:UITapGestureRecognizer) {
        let location: CGPoint = gesture.location(in: tableviewSend)
        let indexpath: IndexPath? = tableviewSend.indexPathForRow(at: location)
        let message = ""
        let strOrderId = ((sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") is NSNull) ? "" : (sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") as! String
        let strBase64OrderId = "https://www.eballoonclub.com/preview/index/" + strOrderId.toBase64()
        if let link = NSURL(string: strBase64OrderId) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            activityVC.completionWithItemsHandler = { activity, success, items, error in
                if !success{
                    print("cancelled")
                    return
                }
                
                if activity == .postToFacebook {
                    self.WSSocialSendApiCall(selectOption: "facebook", orderId: strOrderId)
                }
                
                if activity == .postToTwitter {
                    self.WSSocialSendApiCall(selectOption: "twitter", orderId: strOrderId)
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @objc func facebookAction(_ gesture:UITapGestureRecognizer) {
        let location: CGPoint = gesture.location(in: tableviewSend)
        let indexpath: IndexPath? = tableviewSend.indexPathForRow(at: location)
        let message = ""
        let strOrderId = ((sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") is NSNull) ? "" : (sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") as! String
        let strBase64OrderId = "https://www.eballoonclub.com/preview/index/" + strOrderId.toBase64()
        if let link = NSURL(string: strBase64OrderId) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            activityVC.completionWithItemsHandler = { activity, success, items, error in
                if !success{
                    print("cancelled")
                    return
                }
                
                if activity == .postToFacebook {
                    self.WSSocialSendApiCall(selectOption: "facebook", orderId: strOrderId)
                }
                
                if activity == .postToTwitter {
                    self.WSSocialSendApiCall(selectOption: "twitter", orderId: strOrderId)
                }
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func mailAction(_ gesture:UITapGestureRecognizer) {
        let location: CGPoint = gesture.location(in: tableviewSend)
        let indexpath: IndexPath? = tableviewSend.indexPathForRow(at: location)
        let strOrderId = ((sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") is NSNull) ? "" : (sendList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "order_id") as! String
        let strBase64OrderId = "https://www.eballoonclub.com/preview/index/" + strOrderId.toBase64()
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonSendViaMail.user_id : UserDefaults.standard.value(forKey: "custid") as! String ,BalloonSendViaMail.to_email : ((sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "recipent_email") is NSNull ? "" : (sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "recipent_email") as! String),BalloonSendViaMail.link: strBase64OrderId ,BalloonSendViaMail.order_id : ((sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "order_id") is NSNull ? "" : (sendList.object(at: indexpath!.row) as AnyObject).value(forKey: "order_id") as! String)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_SEND_VIA_MAIL, parseApiMethod: "POST")
    }
    internal func parseDictMailThroughBalloonSendApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.showAlertWithReloadData(message: "Successfully sent!")
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
    
    func showAlertWithReloadData(message:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            self.currentPageCount = 0
            self.paginationCall = false
            self.WSGetSend()
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func WSSocialSendApiCall(selectOption:String,orderId:String) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonSendViaMail.type : selectOption, BalloonSendViaMail.order_id:orderId]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_BALLOON_SEND_BALLOON_SOCIAL, parseApiMethod: "POST")
    }
    internal func parseDictSocialThroughBalloonSendApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
             self.showAlertWithReloadData(message: "Successfully sent!")
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: dictJson.value(forKey: "message") as! String)
        }
    }
    
    
    

   
}
