//
//  AppDelegate.swift
//  E Balloon
//
//  Created by VAP on 06/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MediaPlayer
import ContactsUI
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInUIDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var authGooglePlus:GTMOAuth2Authentication = GTMOAuth2Authentication()
    var contactStore = CNContactStore()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UserDefaults.standard.set("sourav.dey@vaptech.in", forKey: "userEmail")
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.black
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "eBalloonClubViewController")], animated: false)
        
        navigationController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(8))
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarStyle = .lightContent
        
        IQKeyboardManager.shared.enable = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "674825998526-qemg2l5oj67e8if8gon1baro42k1f7i4.apps.googleusercontent.com"

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        self.askForContactAccess()
        return true
    }
    func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async {
//                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
//                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
//                            }
//                            alertController.addAction(dismissAction)
//                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            })
            break
        default:
            break
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if UserDefaults.standard.value(forKey: "loginSocial") as! String == "google" {
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        }else if UserDefaults.standard.value(forKey: "loginSocial") as! String == "facebook"  {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }/*else if UserDefaults.standard.value(forKey: "loginSocial") as! String == "twitter"  {
             return Twitter.sharedInstance().application(application, open: url)
         }*/else{
            return true
        }/*else{
         // Linkedin sdk handle redirect
         if LISDKCallbackHandler.shouldHandle(url) {
         return LISDKCallbackHandler.application(application, open:url, sourceApplication:sourceApplication, annotation:annotation)
         }
         
         return true
         }*/
        
    }
    
    @available(iOS 9.0, *)
    internal func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if UserDefaults.standard.value(forKey: "loginSocial") as! String == "google" {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else if UserDefaults.standard.value(forKey: "loginSocial") as! String == "facebook" {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }/*else if UserDefaults.standard.value(forKey: "loginSocial") as! String == "twitter"  {
             return Twitter.sharedInstance().application(app, open: url, options: options)
         }*/else{
            // Linkedin sdk handle redirect
            /*if LISDKCallbackHandler.shouldHandle(url) {
             return LISDKCallbackHandler.application(app, open:url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation:options[UIApplicationOpenURLOptionsKey.annotation])
             }*/
            
            return true
        }
    }
    
    // Google Sign delegate methods
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        UIApplication.shared.statusBarStyle = .lightContent
        if (error == nil) {
            if SharedGlobalVariables.GoogleLogInContollerCheck == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE"), object: nil, userInfo: ["statusText":"User data received","userName": (user.profile.name as String),"userEmail": (user.profile.email as String),"userId": (user.userID as String),"userHasImage":(String(user.profile.hasImage.hashValue)),"userImage":user.profile.imageURL(withDimension: 100)])
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE_SIGNUP"), object: nil, userInfo: ["statusText":"User data received","userName": (user.profile.name as String),"userEmail": (user.profile.email as String),"userId": (user.userID as String),"userHasImage":(String(user.profile.hasImage.hashValue)),"userImage":user.profile.imageURL(withDimension: 100)])
            }
            setAuthorizerForSignIn(signIn: signIn,user: user)
            
        }else {
            print("\(error.localizedDescription)")
            //ActivityIndicator().hideActivityIndicatory()
            // ActivityIndicator().hideActivityIndicatory(uiView: self.inputView!)
            if SharedGlobalVariables.GoogleLogInContollerCheck == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE"), object: nil, userInfo: ["statusText": error.localizedDescription as String])
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE_SIGNUP"), object: nil, userInfo: ["statusText": error.localizedDescription as String])
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("\(error.localizedDescription)")
        if SharedGlobalVariables.GoogleLogInContollerCheck == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE"), object: nil, userInfo: ["statusText": error.localizedDescription as String])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GOOGLE_SIGN_IN_RESPONSE_SIGNUP"), object: nil, userInfo: ["statusText": error.localizedDescription as String])
        }
    }
    
    func setAuthorizerForSignIn(signIn: GIDSignIn, user:GIDGoogleUser) {
        let auth: GTMOAuth2Authentication = GTMOAuth2Authentication()
        
        //Create GTMOAuth2Authentication
        auth.clientID = "734483589209-na8400ks37rm57gcasq80a6gbdegi7s7.apps.googleusercontent.com"
        auth.accessToken = user.authentication.accessToken
        auth.userEmail = user.profile.email
        auth.userID = user.userID
        auth.refreshToken = user.authentication.refreshToken
        auth.expirationDate = user.authentication.accessTokenExpirationDate
        
        //Get app delegate and set GTMOAuth2Authentication
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.authGooglePlus = auth;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

