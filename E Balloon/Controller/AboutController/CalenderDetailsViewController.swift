//
//  CalenderDetailsViewController.swift
//  E Balloon
//
//  Created by VAP on 23/08/18.
//  Copyright © 2018 VAP. All rights reserved.
//


import UIKit
import FSCalendar

class CalenderDetailsViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource {
    @IBOutlet weak var vwCalender: FSCalendar!
    @IBOutlet weak var lblReminderList: UILabel!
    
    var arrAllEventData:NSMutableArray = NSMutableArray()
    var arrAllData:NSArray = ["2015-10-03", "2015-10-06", "2015-10-12", "2018-10-25"]
    var strYear:String = "2018"
    var strMonth:String = "12"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblReminderList.attributedText = NSAttributedString(string: "VIEW MORE", attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        vwCalender.appearance.titleWeekendColor = UIColor.white
        vwCalender.appearance.headerTitleColor = UIColor.white
        vwCalender.appearance.weekdayTextColor = UIColor.white
        vwCalender.appearance.eventDefaultColor = UIColor.white
        lblReminderList.isUserInteractionEnabled = true
        lblReminderList.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToReminderDetailsPage(_:))))
    }
    
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Reminder"
        self.addMenuToScreen()
        self.WSGetReminderList()
    }
    
    func addMenuToScreen(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu-profile"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 23.0, height: 18.0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        let mainViewController = sideMenuController!
        menuButton.addTarget(mainViewController, action: #selector(mainViewController.showLeftViewAnimated(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func WSGetReminderList() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [ReminderList.cust_id : UserDefaults.standard.value(forKey: "custid") as! String,ReminderList.month : strMonth,ReminderList.year: strYear]
        print(Params)
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_ALL_REMINDERS, parseApiMethod: "POST")
    }
    internal func parseDictGetReminderListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let arrRemainderList = (dictJson.value(forKey: "data") as AnyObject).value(forKey: "result") as! NSArray
            if arrRemainderList.count != 0 {
                for index in 0...arrRemainderList.count - 1 {
                    arrAllEventData.add((arrRemainderList.object(at: index) as AnyObject).value(forKey: "remind_date") as! String)
                }
                vwCalender.delegate = self
                vwCalender.dataSource = self
                vwCalender.reloadData()
            }
            
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: "Error occur!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: FSCalander Delegare and Datasource...
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.arrAllEventData.contains(dateString) {
            return UIColor.green
        }
        return appearance.selectionColor
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.arrAllEventData.contains(dateString) {
            return 2
        }else{
            return 0
        }
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.vwCalender.frame.size.height = bounds.height
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        arrAllEventData.removeAllObjects()
        let currentPageDate = calendar.currentPage
        strMonth = String(Calendar.current.component(.month, from: currentPageDate))
        strYear = String(Calendar.current.component(.year, from: currentPageDate))
        self.WSGetReminderList()
    }
    
    @objc func goToReminderDetailsPage(_ tap: UITapGestureRecognizer) {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ReminderListViewController") as! ReminderListViewController
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }

}
