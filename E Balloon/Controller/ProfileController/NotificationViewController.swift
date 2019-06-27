//
//  NotificationViewController.swift
//  E Balloon
//
//  Created by VAP on 04/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class notificationCell:UITableViewCell{
    
    @IBOutlet weak var imgnotification: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSendBalloon: UILabel!
    
}

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableviewNotification: UITableView!
    var notificationList:NSMutableArray = NSMutableArray()
    
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    var footerLabel : UILabel = UILabel()
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewNotification.rowHeight = UITableViewAutomaticDimension
        self.tableviewNotification.estimatedRowHeight = 1000
        
        self.title = "Notification"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    
    func WSGetNotifaction() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [Notification.user_id : UserDefaults.standard.value(forKey: "custid") as! String ,Notification.page : String(currentPageCount)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_NOTIFICATION, parseApiMethod: "POST")
    }
    
    internal func parseDictGetNotificationApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            print(dictJson)
            
            if (dictJson.value(forKey: "data") as AnyObject).count > 0{
                if(paginationCall){
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
                        notificationList.add(featuredArr.object(at: index))
                    }
                }else{
                    
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
                        notificationList.add(bb.object(at: index))
                    }
                }
                self.tableviewNotification.delegate = self
                self.tableviewNotification.dataSource = self
                self.tableviewNotification.reloadData()
            }else{
                if(!paginationCall){
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
                }
                self.tableviewNotification.isHidden = true
                self.lblNoDataFound.isHidden = false
                let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
                lblNoDataFound.text = errorMsg
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            self.tableviewNotification.isHidden = true
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
                self.WSGetNotifaction()
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
            self.tableviewNotification.tableFooterView = nil
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblNoDataFound.isHidden = true
        self.WSGetNotifaction()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as!  notificationCell
            
            cell.lblSendBalloon.text = (notificationList.object(at: indexPath.row) as AnyObject).value(forKey: "message") is NSNull ? "" : (notificationList.object(at: indexPath.row) as AnyObject).value(forKey: "message") as! String
            
            let strCreateDate = (notificationList.object(at: indexPath.row) as AnyObject).value(forKey: "created_at") is NSNull ? "" : (notificationList.object(at: indexPath.row) as AnyObject).value(forKey: "created_at") as! String
            cell.lblTime.text = SharedFunctions.dateFormatChange(inputDate: strCreateDate)
            let strType = (notificationList.object(at: indexPath.row) as AnyObject).value(forKey: "type") as! String
            if strType == "sent" {
                cell.imgnotification.image = #imageLiteral(resourceName: "notification-calendar")
            }else{
                cell.imgnotification.image = #imageLiteral(resourceName: "notification")
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as!  notificationCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
