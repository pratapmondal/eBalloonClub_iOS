//
//  backgroundImageViewController.swift
//  E Balloon
//
//  Created by VAP on 28/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import AudioToolbox


class ImageCollectionViewCell:UICollectionViewCell{
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
}
class BalloonPreviewCell :UITableViewCell {
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var txtInnnerText: UITextView!
    @IBOutlet weak var constaintWidthImgBalloon: NSLayoutConstraint!
    @IBOutlet weak var constaintHeightImgBalloon: NSLayoutConstraint!
    @IBOutlet weak var constaintTextHeight: NSLayoutConstraint!
    @IBOutlet weak var constaintTextWidth: NSLayoutConstraint!
}

class BackgroundImgeselectCell:UITableViewCell {
    @IBOutlet weak var lblChooseOption: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionViewBackgroundImageSelect: UICollectionView!
    @IBOutlet weak var constaintSegmentControlHeight: NSLayoutConstraint!
    @IBOutlet weak var constaintTopSegment: NSLayoutConstraint!
    @IBOutlet weak var lblClickToSignIn: UILabel!
    @IBOutlet weak var vwSignInDetails: UIView!
    @IBOutlet weak var imgSignIn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwSignInDetails.layer.cornerRadius = vwSignInDetails.layer.bounds.width/2
        vwSignInDetails.clipsToBounds = true
    }
}

class backgroundImageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableviewbackgroundImage: UITableView!
    @IBOutlet weak var pageContolBackgroundImage: UIPageControl!
    var arrBackgroundImage :NSArray = NSArray()
    private var imageAnimationImage = [String:UIImage]()
    private var ownImageDownloadImage = [String:UIImage]()
    var intSelectIndex:Int = -1
    var boolSelectIndex:Bool = false
    var imgSelectedImage:UIImage = #imageLiteral(resourceName: "bg-colour")
    var intCurrentPage:Int = 0
    var imageDownloadTrack:[Int:Bool] = [:]
    var imageDownloadTrack1:[Int:Bool] = [:]
    var segmentControl:Int = 2
    var pickerController = UIImagePickerController()
    var segmentControlSelection:Bool = true
    var strBalloonId:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedGlobalVariables.dicSaveBallonData.setValue(imgSelectedImage, forKey: "BalloonBackgroundImage")
        pageContolBackgroundImage.isHidden = true
        pageContolBackgroundImage.transform = CGAffineTransform(scaleX: 2, y: 2)
        if segmentControlSelection == false {
            self.WSGetOwnBackgroundImage()
        }else{
            self.WSGetBackground()
        }
    }
    
    func WSGetOwnBackgroundImage() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BackgroundImage.cust_id : (UserDefaults.standard.value(forKey: "custid") as? String)!]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_USER_BACKGROUND_IMAGE, parseApiMethod: "POST")
    }
    internal func parseDictGetOwnBackgroundImageListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            arrBackgroundImage = dictJson.value(forKey: "data") as! NSArray
            tableviewbackgroundImage.delegate = self
            tableviewbackgroundImage.dataSource = self
            tableviewbackgroundImage.reloadData()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMessage = dictJson.value(forKey: "message") is NSNull ? "" : dictJson.value(forKey: "message") as! String
            if errorMessage == "No background Image found" {
                arrBackgroundImage = NSArray()
                tableviewbackgroundImage.delegate = self
                tableviewbackgroundImage.dataSource = self
                tableviewbackgroundImage.reloadData()
            }else{
                let errorMsg = dictJson.value(forKey: "message") is NSNull ? "" : dictJson.value(forKey: "message") as! String
                SharedFunctions.ShowAlert(controller: self, message: errorMsg)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") != nil {
            imgSelectedImage = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as! UIImage
        }
        pageContolBackgroundImage.isHidden = true
        self.navigationBarSetUp()
        self.title = "eBalloon Background Image"
    }
    
    
    func navigationBarSetUp() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8745098039, green: 0.1607843137, blue: 0.1960784314, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(self.nextButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    
    
    func WSGetBackground() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BackgroundImage.page : "0"]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_BACKGROUND_IMAGE, parseApiMethod: "POST")
    }
    internal func parseDictGetAnimationListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            arrBackgroundImage = dictJson.value(forKey: "data") as! NSArray
            tableviewbackgroundImage.delegate = self
            tableviewbackgroundImage.dataSource = self
            tableviewbackgroundImage.reloadData()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            let errorMsg = dictJson.value(forKey: "") is NSNull ? "message" : dictJson.value(forKey: "message") as! String
            SharedFunctions.ShowAlert(controller: self, message: errorMsg)
        }
    }
    
    
    @objc func nextButton(){
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") == nil || SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as! UIImage == #imageLiteral(resourceName: "bg-colour") {
            SharedFunctions.ShowAlert(controller: self, message: "Please select Balloon Background image to continue.")
        }else{
           let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonAnimationViewController") as! eBalloonAnimationViewController
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
           self.navigationController?.pushViewController(controllerObj, animated: true)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK:Tableview Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.tableviewbackgroundImage.frame.size.height
        if indexPath.row == 0 {
            return 200.0
        }else{
            if UIScreen.main.bounds.height == 812 {
                return 354.0
            }else{
                return screenHeight - 200.0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalloonPreviewCell", for: indexPath) as!  BalloonPreviewCell
            cell.txtInnnerText.isEditable = false
            let title = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as? String
            print(SharedGlobalVariables.dicSaveBallonData)
            let fontName = SharedFunctions.createFontName(fontName: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as? String)!)
            let ballonFontSize = SharedFunctions.createFontSize(fontSize: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as? String)!)
            let fontColor = SharedFunctions.textToColorCode(colorCode: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String)!)
            
            let myTitle = NSAttributedString(string: title! , attributes: [NSAttributedStringKey.font:UIFont(name: fontName, size: ballonFontSize)!,NSAttributedStringKey.foregroundColor:UIColor(hex:fontColor)])
            
            cell.txtInnnerText.attributedText = myTitle
            cell.txtInnnerText.textAlignment = .center
            
            if strBalloonId == "29" {
                cell.imgBalloon.image = UIImage(named: "flag-balloon")
            }else{
                cell.imgBalloon.image = cell.imgBalloon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
                cell.imgBalloon.tintColor = UIColor(hex : SharedFunctions.textToColorCode(colorCode: balloonColor))
            }
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") != nil{
                imgSelectedImage = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as! UIImage
            }
            
            cell.imgBackGround.image = imgSelectedImage
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BackgroundImgeselectCell", for: indexPath) as!  BackgroundImgeselectCell
            let totalPage:Int = (arrBackgroundImage.count / 12)
            if (arrBackgroundImage.count % 12) == 0 {
                pageContolBackgroundImage.numberOfPages = totalPage
            }else{
                pageContolBackgroundImage.numberOfPages = totalPage + 1
            }
            
            if segmentControlSelection == true {
                cell.vwSignInDetails.isHidden = true
                cell.collectionViewBackgroundImageSelect.isHidden = false
                pageContolBackgroundImage.isHidden = false
                cell.segmentControl.selectedSegmentIndex = 1
                cell.collectionViewBackgroundImageSelect.delegate = self
                cell.collectionViewBackgroundImageSelect.dataSource = self
                cell.collectionViewBackgroundImageSelect.reloadData()
                pageContolBackgroundImage.currentPage = intCurrentPage
                cell.lblClickToSignIn.isUserInteractionEnabled = false
                cell.imgSignIn.isUserInteractionEnabled = false
            }else{
                cell.segmentControl.selectedSegmentIndex = 0
                if UserDefaults.standard.value(forKey: "custid") == nil {
                    cell.vwSignInDetails.isHidden = false
                    cell.collectionViewBackgroundImageSelect.isHidden = true
                    pageContolBackgroundImage.isHidden = true
                    cell.lblClickToSignIn.isUserInteractionEnabled = true
                    cell.lblClickToSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSigninPage(_:))))
                    cell.imgSignIn.isUserInteractionEnabled = true
                    cell.imgSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSigninPage(_:))))
                }else{
                    cell.vwSignInDetails.isHidden = true
                    cell.collectionViewBackgroundImageSelect.isHidden = false
                    pageContolBackgroundImage.isHidden = false
                    cell.collectionViewBackgroundImageSelect.delegate = self
                    cell.collectionViewBackgroundImageSelect.dataSource = self
                    cell.collectionViewBackgroundImageSelect.reloadData()
                    pageContolBackgroundImage.isHidden = false
                    pageContolBackgroundImage.currentPage = intCurrentPage
                    cell.lblClickToSignIn.isUserInteractionEnabled = false
                    cell.imgSignIn.isUserInteractionEnabled = false
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    //MARK:-------------DONE--------------------
    
    
    
    //MARK: CollectionView Delegate and Datasource...
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentControlSelection == false {
            return arrBackgroundImage.count + 1
        }else{
            return arrBackgroundImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        if segmentControlSelection == false {
            if indexPath.row == 0 {
                cell.imgBackground.image = #imageLiteral(resourceName: "camera-placeholder")
                cell.imgSelect.isHidden = true
                cell.actInd.isHidden = true
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
            }else{
                cell.imgSelect.isHidden = true
                if boolSelectIndex == true {
                    if indexPath.row == intSelectIndex {
                        cell.imgSelect.isHidden = false
                        cell.contentView.layer.borderWidth = 2.0
                        cell.contentView.layer.borderColor = UIColor.red.cgColor
                    }else{
                        cell.imgSelect.isHidden = true
                        cell.contentView.layer.borderWidth = 0.0
                        cell.contentView.layer.borderColor = UIColor.white.cgColor
                    }
                }else{
                    cell.imgSelect.isHidden = true
                    cell.contentView.layer.borderWidth = 0.0
                    cell.contentView.layer.borderColor = UIColor.white.cgColor
                }
                
                let stringURL = (arrBackgroundImage.object(at: indexPath.row - 1) as AnyObject).value(forKey: "image") is NSNull ? "" : (arrBackgroundImage.object(at: indexPath.row - 1) as AnyObject).value(forKey: "image") as! String
                let urlNew:String = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                cell.imgBackground.image = #imageLiteral(resourceName: "bg-colour")
                cell.imgBackground.contentMode = .scaleToFill
                
                if stringURL != "" {
                    if let img = self.ownImageDownloadImage[urlNew] {
                        cell.imgBackground.image = img
                        cell.actInd.isHidden = true
                    }else{
                        let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew)! as URL)
                        let mainQueue = OperationQueue.main
                        cell.actInd.isHidden = false
                        cell.actInd.startAnimating()
                        
                        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (responce, data, error) -> Void in
                            
                        })
                        
                        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                let image = UIImage(data: data!)
                                self.ownImageDownloadImage[stringURL] = image
                                DispatchQueue.main.async(execute: {
                                    cell.imgBackground.image = image
                                    cell.actInd.isHidden = true
                                    cell.actInd.stopAnimating()
                                    cell.imgBackground.contentMode = .scaleToFill
                                    self.imageDownloadTrack1[indexPath.row] = true
                                })
                            }else{
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                    }
                }else{
                    cell.imgBackground.contentMode = .scaleToFill
                    cell.imgBackground.image = #imageLiteral(resourceName: "bg-colour")
                }
                if indexPath.row == 0 {
                    cell.imgBackground.isUserInteractionEnabled = false
                }else{
                    cell.imgBackground.isUserInteractionEnabled = true
                }
                let selectBackgroundImage = UITapGestureRecognizer(target: self, action: #selector(selectBackgroundImage(_:)))
                selectBackgroundImage.numberOfTapsRequired = 1
                cell.imgBackground.addGestureRecognizer(selectBackgroundImage)
                
                let selectRemoveImage = UILongPressGestureRecognizer(target: self, action: #selector(selectRemoveImage(_:)))
                cell.imgBackground.addGestureRecognizer(selectRemoveImage)
                
                selectRemoveImage.require(toFail: selectBackgroundImage)
                selectBackgroundImage.require(toFail: selectRemoveImage)
            }
        }else{
            cell.imgSelect.isHidden = true
            if boolSelectIndex == true {
                if indexPath.row == intSelectIndex {
                    cell.imgSelect.isHidden = false
                    cell.contentView.layer.borderWidth = 2.0
                    cell.contentView.layer.borderColor = UIColor.red.cgColor
                }else{
                    cell.imgSelect.isHidden = true
                    cell.contentView.layer.borderWidth = 0.0
                    cell.contentView.layer.borderColor = UIColor.white.cgColor
                }
            }else{
                cell.imgSelect.isHidden = true
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
            }
            
            let stringURL = (arrBackgroundImage.object(at: indexPath.row) as AnyObject).value(forKey: "image") is NSNull ? "" : (arrBackgroundImage.object(at: indexPath.row) as AnyObject).value(forKey: "image") as! String
            let urlNew:String = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            cell.imgBackground.contentMode = .scaleToFill
            cell.imgBackground.image = #imageLiteral(resourceName: "bg-colour")
            if stringURL != "" {
                if let img = self.imageAnimationImage[urlNew] {
                    cell.imgBackground.image = img
                    cell.actInd.isHidden = true
                }else{
                    let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew)! as URL)
                    let mainQueue = OperationQueue.main
                    cell.actInd.isHidden = false
                    cell.actInd.startAnimating()
                    
                    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            let image = UIImage(data: data!)
                            self.imageAnimationImage[stringURL] = image
                            DispatchQueue.main.async(execute: {
                                cell.imgBackground.image = image
                                cell.actInd.isHidden = true
                                cell.actInd.stopAnimating()
                                cell.imgBackground.contentMode = .scaleToFill
                                self.imageDownloadTrack[indexPath.row] = true
                            })
                        }else{
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }else{
                cell.imgBackground.contentMode = .scaleToFill
                cell.imgBackground.image = #imageLiteral(resourceName: "bg-colour")
            }
            cell.imgBackground.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectioViewHeight = (collectionView.frame.size.height - 6) / 3
        return CGSize(width: collectioViewHeight, height: collectioViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentControlSelection == true {
            if imageDownloadTrack[indexPath.row] == true {
                let stringURL = (arrBackgroundImage.object(at: indexPath.row) as AnyObject).value(forKey: "image") is NSNull ? "" : (arrBackgroundImage.object(at: indexPath.row) as AnyObject).value(forKey: "image") as! String
                if indexPath.row == intSelectIndex {
                    boolSelectIndex = false
                    intSelectIndex = -1
                    imgSelectedImage = #imageLiteral(resourceName: "bg-colour")
                }else{
                    boolSelectIndex = true
                    intSelectIndex = indexPath.row
                    imgSelectedImage = self.imageAnimationImage[stringURL]!
                    SharedGlobalVariables.dicSaveBallonData.setValue(imgSelectedImage, forKey: "BalloonBackgroundImage")
                    SharedGlobalVariables.dicSaveBallonData.setValue(stringURL, forKey: "balloon_bg_image")
                }
                self.tableviewbackgroundImage.reloadData()
            }else{
                SharedFunctions.ShowAlert(controller: self, message: "Please wait some time.")
            }
        }else{
            if indexPath.row == 0 {
                self.cameraActionCreate()
            }
        }
    }
    //-----------------DONE--------------------
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth:CGFloat = (scrollView.contentOffset.x) + (scrollView.frame.width + 20)
        let currentPageNumber = Float(scrollViewWidth/(scrollView.frame.width + 20))
        if currentPageNumber > 1.00 {
            intCurrentPage = 1
        }else{
            intCurrentPage = 0
        }
        pageContolBackgroundImage.currentPage = intCurrentPage
    }
    
    
    @objc func cameraActionCreate() {
        //let actionSheet = UIActionSheetDelegate
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.openCamera()
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.allowsEditing = false
            pickerController.modalPresentationStyle = .fullScreen
            self.present(self.pickerController, animated: true, completion: nil)
        }else{
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageView = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        SharedGlobalVariables.logoChangeProfilePicUpload["fileToUpload"] = imageView
        self.WSUploadBackgroundImage()
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PageControl(_ sender: Any) {
        intSelectIndex = -1
        boolSelectIndex = false
        if segmentControl == 1 {
            segmentControl = 2
            segmentControlSelection = true
            self.WSGetBackground()
        }else{
            segmentControl = 1
            segmentControlSelection = false
            if UserDefaults.standard.value(forKey: "custid") == nil {
                tableviewbackgroundImage.reloadData()
            }else{
                self.WSGetOwnBackgroundImage()
            }
        }
    }

    
    func WSUploadBackgroundImage() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BackgroundImage.cust_id : (UserDefaults.standard.value(forKey: "custid") as? String)!]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_UPLOAD_BACKGROUND_IMAGE, parseApiMethod: "UPLOAD")
    }
    internal func parseDictUploadBackgroundImageListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            boolSelectIndex = false
            ownImageDownloadImage = [:]
            self.WSGetOwnBackgroundImage()
        }else{
           ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: "error occour!")
        }
    }
    func WSRemoveBackgroundImage(inageId:String) {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [BackgroundImage.cust_id : (UserDefaults.standard.value(forKey: "custid") as? String)!,BackgroundImage.id : inageId]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_REMOVE_BACKGROUND_IMAGE, parseApiMethod: "POST")
    }
    internal func parseDictRemoveBackgroundImageListApi(controller:UIViewController, dictJson:NSDictionary){
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            boolSelectIndex = false
            self.WSGetOwnBackgroundImage()
        }else{
            ActivityIndicator().hideActivityIndicatory(uiView: self.view)
            SharedFunctions.ShowAlert(controller: self, message: "error occour!")
        }
    }
    
    @objc func selectBackgroundImage(_ gesture:UITapGestureRecognizer) {
        let cell = tableviewbackgroundImage.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! BackgroundImgeselectCell
        let touchPoint = gesture.location(in: cell.collectionViewBackgroundImageSelect)
        let indexPath = cell.collectionViewBackgroundImageSelect.indexPathForItem(at: touchPoint)
        if segmentControlSelection == false {
            if indexPath?.row == 0 {
                self.cameraActionCreate()
            }else{
                if imageDownloadTrack1[(indexPath?.row)!] == true {
                    let stringURL = (arrBackgroundImage.object(at: (indexPath?.row)! - 1) as AnyObject).value(forKey: "image") is NSNull ? "" : (arrBackgroundImage.object(at: (indexPath?.row)! - 1) as AnyObject).value(forKey: "image") as! String
                    if (indexPath?.row)! == intSelectIndex {
                        boolSelectIndex = false
                        intSelectIndex = -1
                        imgSelectedImage = #imageLiteral(resourceName: "bg-colour")
                    }else{
                        boolSelectIndex = true
                        intSelectIndex = (indexPath?.row)!
                        print(imageAnimationImage)
                        print(ownImageDownloadImage)
                        imgSelectedImage = self.ownImageDownloadImage[stringURL]!
                        SharedGlobalVariables.dicSaveBallonData.setValue(imgSelectedImage, forKey: "BalloonBackgroundImage")
                        SharedGlobalVariables.dicSaveBallonData.setValue(stringURL, forKey: "balloon_bg_image")
                    }
                    self.tableviewbackgroundImage.reloadData()
                }else{
                    SharedFunctions.ShowAlert(controller: self, message: "Please wait some time.")
                }
            }
        }
    }
    
    @objc func selectRemoveImage(_ gesture:UILongPressGestureRecognizer) {
        let cell = tableviewbackgroundImage.cellForRow(at: NSIndexPath(row: 1, section: 0) as IndexPath) as! BackgroundImgeselectCell
        let touchPoint = gesture.location(in: cell.collectionViewBackgroundImageSelect)
        let indexPath = cell.collectionViewBackgroundImageSelect.indexPathForItem(at: touchPoint)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        if gesture.state == .began {
            let imageUrlId = (arrBackgroundImage.object(at: (indexPath?.row)! - 1) as AnyObject).value(forKey: "id") is NSNull ? "" : (arrBackgroundImage.object(at: (indexPath?.row)! - 1) as AnyObject).value(forKey: "id") as! String
            self.showDeleteAlertWithPop(imageId: imageUrlId)
        }
    }
    
    func showDeleteAlertWithPop(imageId:String) {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Do you want to delete own uploaded picture?", preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            self.WSRemoveBackgroundImage(inageId: imageId)
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @objc func goToSigninPage(_ gesture:UITapGestureRecognizer) {
        let controllerObjc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
        SharedGlobalVariables.intPageControl = 0
        self.navigationController?.pushViewController(controllerObjc, animated: true)
    }
 
}



