//
//  AllCataegoriesViewController.swift
//  E Balloon
//
//  Created by VAP on 25/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class OccassionsViewCell:UICollectionViewCell{
    
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var lblAnniversary: UILabel!
}

class AllCataegoriesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionViewAllCataegories: UICollectionView!
    
    var strPhotoSelection:String?
    var strSelectCategoryName:String?
    var paginationCall : Bool = false
    var currentPageCount : Int = 0
    var totalPageCount : Int = 0
    var pageCount:String = "1"
    var footerLabel : UILabel = UILabel()
    
    var arrCategoryList:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WSGetAllCategories()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetup()
    }
    
    func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1960784314, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    func WSGetAllCategories() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [AllCategory.page : String(currentPageCount),AllCategory.category_id: strPhotoSelection!]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_AllCATEGORY, parseApiMethod: "POST")
    }
    
    internal func parseDictGetAllCategoriesListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            
            if(paginationCall){
                
                //let perPageLimit = Double(((dictJson.value(forKey: "dataset") as AnyObject).value(forKey: "limit") as AnyObject) as! Int)
                let totalCount = Double(dictJson.value(forKey: "total_row") as! Int)
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
                    arrCategoryList.add(featuredArr.object(at: index))
                }
            }else{
                arrCategoryList.removeAllObjects()
                let totalCount = Double(dictJson.value(forKey: "total_row") as! Int)
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
                    arrCategoryList.add(bb.object(at: index))
                }
            }
            self.collectionViewAllCataegories.delegate = self
            self.collectionViewAllCataegories.dataSource = self
            self.collectionViewAllCataegories.reloadData()
           
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
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
                self.WSGetAllCategories()
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
            ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        }
        self.footerLabel.setNeedsDisplay()
    }
    
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.size.width/2, height:collectionView.frame.size.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OccassionsViewCell", for: indexPath as IndexPath) as! OccassionsViewCell
        let strDescription = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
        let data = Data(strDescription.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            cell.lblAnniversary.attributedText = attributedString
        }else{
            cell.lblAnniversary.text = strDescription
        }
        cell.lblAnniversary.textAlignment = .center
        let strBalloonId = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
        if strBalloonId == "29" {
            cell.imgBalloon.image = UIImage(named: "flag-balloon")
        }else{
            cell.imgBalloon.image = cell.imgBalloon.image!.withRenderingMode(.alwaysTemplate)
            let hexaColorCode = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") as! String)
            if hexaColorCode != "" {
                let start = hexaColorCode.index(hexaColorCode.startIndex, offsetBy: 1)
                let hexColor = String(hexaColorCode[start...])
                cell.imgBalloon.tintColor = UIColor(hex: hexColor)
            }else{
                cell.imgBalloon.tintColor = UIColor.red
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
  }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonColorViewController") as! eBalloonColorViewController
        
        let selectedBalloonId = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
        SharedGlobalVariables.dicSaveBallonData.setValue(selectedBalloonId, forKey: "balloon_id")
        
        let strDescription = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
        let data = Data(strDescription.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            SharedGlobalVariables.dicSaveBallonData.setValue(attributedString.string, forKey: "description")
        }else{
            SharedGlobalVariables.dicSaveBallonData.setValue(strDescription, forKey: "description")
        }
        let strAudioLink:String = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "audio") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "audio") as! String)
        SharedGlobalVariables.dicSaveBallonData.setValue(strAudioLink, forKey: "audio")
                
        let strBalloonColor = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "color_code") as! String)
        SharedGlobalVariables.dicSaveBallonData.setValue(strBalloonColor, forKey: "BalloonColor")
        let strBalloonId = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") is NSNull) ? "" : ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
        if strBalloonId == "29" {
            controllerObj.strBalloonId = strBalloonId
        }
        
        
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }

}
