//
//  OrderDetailsViewController.swift
//  E Balloon
//
//  Created by VAP on 22/08/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class OrderDetailBalloonCell : UITableViewCell{
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgballoon: UIImageView!
    @IBOutlet weak var lblBalloonTitle: UILabel!
}
class OrderSendStatusCell : UITableViewCell {
    @IBOutlet weak var lblSendStatus: UILabel!
}
class OrderItemSendCell : UITableViewCell {
    @IBOutlet weak var lblsendwith: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
}
class OrderTotalcell : UITableViewCell {
    @IBOutlet weak var imgSendOption: UIImageView!
    @IBOutlet weak var lblSendPrice: UILabel!
    
}
class OrderDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblOrderDetails: UITableView!
    var myProfileNavigationBarSetup = MyProfileViewController()
    var strBalloonId:String?
    var dicOrderDeatils:NSDictionary = NSDictionary()
    private var imageOrderImage = [String:UIImage]()
    var arrMutableRowSelect:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WSGetOrderDetails()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Order Details"
        navigationBarSetup()
    }
    func WSGetOrderDetails() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BalloonSendViaMail.order_id : strBalloonId!]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_ORDER_DETAILS, parseApiMethod: "POST")
    }
    internal func parseDictGetOrderDetailsApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            dicOrderDeatils = dictJson.value(forKey: "data") as! NSDictionary
            self.tblOrderDetails.delegate = self
            self.tblOrderDetails.dataSource = self
            tblOrderDetails.reloadData()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
        }
    }
    
    
    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1960784314, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: Tableview Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else if section == 1 {
            var totalRow:Int = 0
            if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "email_check") != nil {
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "email_check") as! String == "on" {
                    totalRow = totalRow + 1
                    arrMutableRowSelect.insert("mail", at: totalRow - 1)
                }
            }
            if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_check") != nil {
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_check") as! String == "on" {
                    totalRow = totalRow + 1
                    arrMutableRowSelect.insert("facebook", at: totalRow - 1)
                }
            }
            
            if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_check") != nil {
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_check") as! String == "on" {//linkedin_check
                    totalRow = totalRow + 1
                    arrMutableRowSelect.insert("twitter", at: totalRow - 1)
                }
            }
            if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_check") != nil {
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_check") as! String == "on" {
                    totalRow = totalRow + 1
                    arrMutableRowSelect.insert("linkedin", at: totalRow - 1)
                }
            }
            
            return totalRow
        }else if section == 2 {
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 280.0
            }else if indexPath.row == 1 {
                return 50.0
            }else if indexPath.row == 2 {
                return 40.0
            }else{
                return 0.0
            }
        }else if indexPath.section == 1 {
            return 55.0
        }else if indexPath.section == 2 {
            return 40.0
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailBalloonCell", for: indexPath) as! OrderDetailBalloonCell
                
                //MARK:Balloon Background image download...
                let stringURL = ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_bg_image") is NSNull) ? "" : ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_bg_image") as! String)
                let urlNew:String = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                cell.imgBackground.contentMode = .scaleToFill
                cell.imgBackground.image = #imageLiteral(resourceName: "back ground")
                if stringURL != "" {
                    if let img = self.imageOrderImage[urlNew] {
                        cell.imgBackground.image = img
                    }else{
                        let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew)! as URL)
                        let mainQueue = OperationQueue.main

                        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                let image = UIImage(data: data!)
                                self.imageOrderImage[stringURL] = image
                                DispatchQueue.main.async(execute: {
                                    cell.imgBackground.image = image
                                    cell.imgBackground.contentMode = .scaleToFill
                                })
                            }else{
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                    }
                }else{
                    cell.imgBackground.contentMode = .scaleToFill
                    cell.imgBackground.image = #imageLiteral(resourceName: "back ground")
                }
                //-------------Done-------------

                //MARK:Balloon Image Download....
                let stringURL1 = (((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "image_path") is NSNull) ? "" : ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "image_path") as! String)) + (((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "image") is NSNull) ? "" : ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "image") as! String))

                let urlNew1:String = stringURL1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                cell.imgballoon.contentMode = .scaleToFill
                cell.imgballoon.image = #imageLiteral(resourceName: "balloon")
                if stringURL1 != "" {
                    if let img = self.imageOrderImage[urlNew1] {
                        cell.imgballoon.image = img
                    }else{
                        let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew1)! as URL)
                        let mainQueue = OperationQueue.main

                        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                let image = UIImage(data: data!)
                                self.imageOrderImage[stringURL1] = image
                                DispatchQueue.main.async(execute: {
                                    cell.imgballoon.image = image
                                    cell.imgballoon.contentMode = .scaleToFill
                                })
                            }else{
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                    }
                }else{
                    cell.imgballoon.contentMode = .scaleToFill
                    cell.imgballoon.image = #imageLiteral(resourceName: "balloon")
                }
                
                cell.lblBalloonTitle.text = ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_message") is NSNull) ? "" : ((dicOrderDeatils.value(forKey: "eballon_details") as AnyObject).value(forKey: "balloon_message") as! String)
                //--------------Done------------
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSendStatusCell", for: indexPath) as! OrderSendStatusCell
                
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
                cell.lblsendwith.text = "Send With"
                cell.lblsendwith.isHidden = false
                cell.lblTotalPrice.isHidden = true
                cell.lblsendwith.textAlignment = .left
                cell.lblPrice.text = "Price"
                cell.lblPrice.textAlignment = .right
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
                cell.selectionStyle = .none
                return cell
            }

        }else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTotalcell", for: indexPath) as! OrderTotalcell
            if indexPath.row == 0 {
                if arrMutableRowSelect.object(at: 0) as! String == "mail" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-mail")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "email_price") != nil {
                        //cell.lblSendPrice.text = "$ 0." + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "email_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else if arrMutableRowSelect.object(at: 0) as! String == "facebook" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-fb")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else if arrMutableRowSelect.object(at: 0) as! String == "twitter" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-twitter")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else{
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-call")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }
                
            }else if indexPath.row == 1 {
                if arrMutableRowSelect.object(at: 1) as! String == "facebook" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-fb")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "facebook_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else if arrMutableRowSelect.object(at: 1) as! String == "twitter" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-twitter")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else{
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-call")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .right
                }
            }else if indexPath.row == 2 {
                if arrMutableRowSelect.object(at: 2) as! String == "twitter" {
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-twitter")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "twitter_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }else{
                    cell.imgSendOption.image = #imageLiteral(resourceName: "send-call")
                    if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") != nil {
                        //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") as! String)
                        cell.lblSendPrice.text = "$ 0.0"
                    }else{
                        cell.lblSendPrice.text = "$ 0.0"
                    }
                    cell.lblSendPrice.textAlignment = .center
                }
            }else if indexPath.row == 3 {
                cell.imgSendOption.image = #imageLiteral(resourceName: "send-call")
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") != nil {
                    //cell.lblSendPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "linkedin_price") as! String)
                    cell.lblSendPrice.text = "$ 0.0"
                }else{
                    cell.lblSendPrice.text = "$ 0.0"
                }
                cell.lblSendPrice.textAlignment = .center
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
                cell.lblsendwith.text = "Sending Cost"
                cell.lblsendwith.isHidden = false
                cell.lblTotalPrice.isHidden = true
                cell.lblsendwith.textAlignment = .left
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "balloon_amount") != nil {
                    //cell.lblPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "balloon_amount") as! String)
                    cell.lblPrice.text = "$ 0.0"
                }else{
                    cell.lblPrice.text = "$ 0.0"
                }
                cell.lblPrice.textAlignment = .right
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
                cell.lblPrice.textAlignment = .right
                cell.lblsendwith.isHidden = true
                cell.lblTotalPrice.isHidden = false
                if (dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "subtotal") != nil {
                    //cell.lblPrice.text = "$ " + ((dicOrderDeatils.value(forKey: "package_deatils") as AnyObject).value(forKey: "subtotal") as! String)
                    cell.lblPrice.text = "$ 0.0"
                }else{
                    cell.lblPrice.text = "$ 0.0"
                }
                cell.lblTotalPrice.text = "Total Price"
                cell.lblsendwith.textAlignment = .right
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemSendCell", for: indexPath) as! OrderItemSendCell
            cell.selectionStyle = .none
            return cell
        }
    }

}
