//
//  CategoryViewController.swift
//  E Balloon
//
//  Created by VAP on 21/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class CategoryCell:UITableViewCell{
    
    @IBOutlet weak var btnCategoryName: UIButton!
    
    
}

class CategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableviewCategory: UITableView!
    var arrCategoryList:NSArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WSGetCategory()       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetup()
    }
    
    func navigationBarSetup() {
        self.title = "Categories"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func WSGetCategory() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [Category.page : "0"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_CATEGORY, parseApiMethod: "POST")
    }
    internal func parseDictGetCategoryListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            arrCategoryList = dictJson.value(forKey: "data") as! NSArray
            print(arrCategoryList)
            tableviewCategory.delegate = self
            tableviewCategory.dataSource = self
            tableviewCategory.reloadData()
        }else{
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategoryList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as!  CategoryCell
            let cellCategoriesName = "  " + ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String) //id
                
            cell.btnCategoryName.setTitle(cellCategoriesName, for: .normal)
            cell.btnCategoryName.addTarget(self, action: #selector(CategoriesTap(_:)), for: .touchUpInside)
            
        
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as!  CategoryCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AllCataegoriesViewController") as! AllCataegoriesViewController
        controllerObj.strPhotoSelection = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "id") as! String)
        controllerObj.title = ((arrCategoryList.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func CategoriesTap(_ btn:UIButton) {
        let tableCell = btn.superview?.superview as! UITableViewCell
        let indexpath = self.tableviewCategory.indexPath(for: tableCell)
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AllCataegoriesViewController") as! AllCataegoriesViewController
        controllerObj.strPhotoSelection = ((arrCategoryList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "id") as! String)
        controllerObj.title = ((arrCategoryList.object(at: (indexpath?.row)!) as AnyObject).value(forKey: "name") as! String)
       self.navigationController?.pushViewController(controllerObj, animated: true)
    }


}
