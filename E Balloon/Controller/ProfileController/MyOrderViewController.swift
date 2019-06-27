//
//  MyOrderViewController.swift
//  E Balloon
//
//  Created by VAP on 04/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class MyOrderCell:UITableViewCell{
    @IBOutlet weak var imgMyOrder: UIImageView!
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblOrderPrice: UILabel!
    @IBOutlet weak var lblorderDetails: UILabel!
    @IBOutlet weak var lblorderDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgBalloon: UIImageView!
    
    @IBOutlet weak var BtnStatus: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    
}

class MyOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableviewMyOrder: UITableView!
    var myProfileViewController = MyProfileViewController()
    var arrMyOrderList:NSMutableArray = NSMutableArray()
    
    
    private var imageOrderImage = [String:UIImage]()
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    var footerLabel : UILabel = UILabel()
    
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func WSGetMyOrder() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [GetOrderList.user_id : UserDefaults.standard.value(forKey: "custid") as! String,GetOrderList.page : String(currentPageCount)]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_ORDER_LIST, parseApiMethod: "POST")
    }
    
    internal func parseDictGetMyOrderApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
            
            if (dictJson.value(forKey: "data") as AnyObject).count > 0{
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
                    
                    let featuredArr = dictJson.value(forKey: "data") as! NSArray
                    for index in 0 ..< featuredArr.count {
                        arrMyOrderList.add(featuredArr.object(at: index))
                    }
                }else{
                    arrMyOrderList.removeAllObjects()
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
                    
                    
                    let bb:NSArray = dictJson.value(forKey: "data") as! NSArray
                    for index in 0 ..< bb.count {
                        arrMyOrderList.add(bb.object(at: index))
                    }
                }
                self.tableviewMyOrder.delegate = self
                self.tableviewMyOrder.dataSource = self
                self.tableviewMyOrder.reloadData()
            }else{
                if(!paginationCall){
                    ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
                }
                self.tableviewMyOrder.isHidden = true
                self.lblNoDataFound.isHidden = false
                let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
                lblNoDataFound.text = errorMsg
            }
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            lblNoDataFound.isHidden = false
            self.tableviewMyOrder.isHidden = true
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
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
                self.WSGetMyOrder()
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
            self.tableviewMyOrder.tableFooterView = nil
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblNoDataFound.isHidden = true
        self.title = "My Order"
        myProfileViewController.NavigationBarSetUp()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        
        self.currentPageCount = 0
        self.paginationCall = false
        WSGetMyOrder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyOrderList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as!  MyOrderCell
            cell.lblOrderName.text = (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "sub_cat_name") is NSNull) ? "" : (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "sub_cat_name") as! String)
            
            let strCreateDate = (arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "order_date") is NSNull ? "" : (arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "order_date") as! String
            cell.lblorderDate.text = SharedFunctions.dateFormatChange(inputDate: strCreateDate)
            
            cell.lblPrice.text = "$ " + ((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "order_amount") is NSNull ? "" : (arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "order_amount") as! String)
            
            //MARK:Balloon Background image download...
            let stringURL = (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_bg_image") is NSNull) ? "" : (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_bg_image") as! String)
            let urlNew:String = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            cell.imgMyOrder.contentMode = .scaleToFill
            cell.imgMyOrder.image = #imageLiteral(resourceName: "back ground")
            if stringURL != "" {
                if let img = self.imageOrderImage[urlNew] {
                    cell.imgMyOrder.image = #imageLiteral(resourceName: "back ground")
                    cell.imgMyOrder.image = img
                }else{
                    let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew)! as URL)
                    let mainQueue = OperationQueue.main
                    
                    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            self.imageOrderImage[stringURL] = image
                            DispatchQueue.main.async(execute: {
                                cell.imgMyOrder.image = image
                                cell.imgMyOrder.contentMode = .scaleToFill
                            })
                        }else{
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }else{
                cell.imgMyOrder.contentMode = .scaleToFill
                cell.imgMyOrder.image = #imageLiteral(resourceName: "back ground")
            }
            //-------------Done-------------
            
            //MARK:Balloon Image Download....
            let stringURL1 = (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "image_path") as! String) + (((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "eballon_details") as AnyObject).value(forKey: "image") as! String)
            
            let urlNew1:String = stringURL1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            cell.imgBalloon.contentMode = .scaleToFill
            cell.imgBalloon.image = #imageLiteral(resourceName: "balloon")
            if stringURL1 != "" {
                if let img = self.imageOrderImage[urlNew1] {
                    cell.imgBalloon.image = img
                }else{
                    let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew1)! as URL)
                    let mainQueue = OperationQueue.main
                    
                    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            self.imageOrderImage[stringURL1] = image
                            DispatchQueue.main.async(execute: {
                                cell.imgBalloon.image = image
                                cell.imgBalloon.contentMode = .scaleToFill
                            })
                        }else{
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }else{
                cell.imgBalloon.contentMode = .scaleToFill
                cell.imgBalloon.image = #imageLiteral(resourceName: "balloon")
            }
            
            //--------------Done------------
            let strDelivaryStatus = ((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "deliver_status") is NSNull) ? "" : ((arrMyOrderList.object(at: indexPath.row) as AnyObject).value(forKey: "deliver_status") as! String)
            if strDelivaryStatus == "1" {
                cell.BtnStatus.setImage(UIImage(named: "status-sent"), for: .normal)
            }else{
                cell.BtnStatus.setImage(UIImage(named: "status"), for: .normal)
            }
            
            cell.btnDownload.addTarget(self, action: #selector(downloadPdf(_:)), for: .touchUpInside)
            cell.btnView.addTarget(self, action: #selector(balloonListView(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as!  MyOrderCell
            cell.selectionStyle = .none
            return cell
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func downloadPdf(_ btn:UIButton) {
        let pointInTable: CGPoint = btn.convert(btn.bounds.origin, to: self.tableviewMyOrder)
        let cellIndexPath = self.tableviewMyOrder.indexPathForRow(at: pointInTable)
        let strDownloadUrl = (arrMyOrderList.object(at: (cellIndexPath?.row)!) as AnyObject).value(forKey: "download_item") is NSNull ? "" : (arrMyOrderList.object(at: (cellIndexPath?.row)!) as AnyObject).value(forKey: "download_item") as! String
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PdfViewerViewController") as! PdfViewerViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        controllerObj.strPdflink = strDownloadUrl
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    @objc func balloonListView(_ btn:UIButton){
        let pointInTable: CGPoint = btn.convert(btn.bounds.origin, to: self.tableviewMyOrder)
        let cellIndexPath = self.tableviewMyOrder.indexPathForRow(at: pointInTable)
        print(arrMyOrderList.object(at: (cellIndexPath?.row)!) as AnyObject)
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        controllerObj.strBalloonId = (arrMyOrderList.object(at: (cellIndexPath?.row)!) as AnyObject).value(forKey: "id") as? String
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
  
}
