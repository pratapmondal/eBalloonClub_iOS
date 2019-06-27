//
//  ReminderListViewController.swift
//  E Balloon
//
//  Created by VAP on 12/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class ReminderListCell:UITableViewCell{
    @IBOutlet weak var lblFront: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNotiUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblFront.layer.cornerRadius = 3
        lblFront.clipsToBounds = true
    }
}


class ReminderListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var tableviewReminderList: UITableView!
    var reminderList:NSMutableArray = NSMutableArray()
    
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    
    var footerLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewReminderList.delegate = self
        tableviewReminderList.dataSource = self
        tableviewReminderList.reloadData()
        
        self.title = "Reminder List"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.WSGetReminder()
    }
    
    //MARK: Webservice Api call...
    func WSGetReminder() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [ReminderList.cust_id : UserDefaults.standard.value(forKey: "custid") as! String]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_REMINDERLIST, parseApiMethod: "POST")
    }
    internal func parseDictGetReminderApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            //reminderList = (dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as! NSArray
            
            if ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as AnyObject).count > 0{
                if(paginationCall){
                    
                    //let perPageLimit = Double(((dictJson.value(forKey: "dataset") as AnyObject).value(forKey: "limit") as AnyObject) as! Int)
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
                    
                    let featuredArr = ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as AnyObject) as! NSArray
                    for index in 0 ..< featuredArr.count {
                        reminderList.add(featuredArr.object(at: index))
                    }
                }else{
                    
                    //let perPageLimit = Double(((dictJson.value(forKey: "dataset") as AnyObject).value(forKey: "limit") as AnyObject) as! Int)
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
                    
                    let bb:NSArray = ((dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as AnyObject) as! NSArray
                    for index in 0 ..< bb.count {
                        reminderList.add(bb.object(at: index))
                    }
                }
                self.tableviewReminderList.delegate = self
                self.tableviewReminderList.dataSource = self
                self.tableviewReminderList.reloadData()
            }else{
                if(!paginationCall){
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
                }
                self.tableviewReminderList.isHidden = true
                self.lblNoDataFound.isHidden = false
                lblNoDataFound.text = "Reminder List Not Available"
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            self.tableviewReminderList.isHidden = true
            self.lblNoDataFound.isHidden = false
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            lblNoDataFound.text = errorMsg
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
                self.WSGetReminder()
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
            self.tableviewReminderList.tableFooterView = nil
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }
    
    //MARK:Tableview Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderListCell", for: indexPath) as!  ReminderListCell
            
            cell.lblNotiUserName.text = ((reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull ? "" : (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String) + " " + ((reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "lst_name") is NSNull ? "" : (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "lst_name") as! String)
            cell.lblName.text = (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "email") is NSNull ? "" : (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "email") as! String
            cell.lblName.text = (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") is NSNull ? "" : (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "event_name") as! String
            var strCreateDate = (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "remind_date") is NSNull ? "" : (reminderList.object(at: indexPath.row) as AnyObject).value(forKey: "remind_date") as! String
            if strCreateDate == "0000-00-00" {
                strCreateDate = "2018-10-05"
            }
            cell.lblDate.text = SharedFunctions.dateFormatChange(inputDate: strCreateDate)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderListCell", for: indexPath) as!  ReminderListCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

