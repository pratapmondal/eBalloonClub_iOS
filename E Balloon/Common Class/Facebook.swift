
import Foundation

let FB = Facebook();

class Facebook {
    
    var fbSession:FBSession?;
    
    init(){
        self.fbSession = FBSession.active();
    }
    
    func hasActiveSession() -> Bool{
        let fbsessionState = FBSession.active().state;
        if ( fbsessionState == FBSessionState.open
            || fbsessionState == FBSessionState.openTokenExtended ){
                self.fbSession = FBSession.active();
                return true;
        }
        return false;
    }
    
    func login(callback: @escaping () -> Void){
        
        let permission = ["public_profile", "email", "user_friends"];
        
        let activeSession = FBSession.active();
        let fbsessionState = activeSession?.state;
        var showLoginUI = true;
        
        if(fbsessionState == FBSessionState.createdTokenLoaded){
            showLoginUI = false;
        }
        
        if(fbsessionState != FBSessionState.open
            && fbsessionState != FBSessionState.openTokenExtended){
                FBSession.openActiveSession(withReadPermissions: permission, allowLoginUI: showLoginUI, completionHandler: { (session, state, error) in
                    if(error != nil){
                        print("Session Error: \(error)")
                    }
                    
                    self.fbSession = session
                    
                    callback()
                })
            
                return
        }
        
        callback()
        
    }
    
    func logout(){
        self.fbSession?.closeAndClearTokenInformation();
        self.fbSession?.close();
    }
    
    func getInfo(Controller:UIViewController){

        FBRequest.forMe().start(completionHandler: {(connection,result,error) in
            if(error != nil){
                print("Error Getting ME: \(error)");
            }
            
            if result != nil {
                print("FB Result : \(result)");
            }else{
                print("authenticate error")
            }
            
            self.parseFacebookData(result: result as AnyObject!,controller: Controller)
        })
        
    }
    
    func getFaceBookInfo(Controller:UIViewController){
        let login:FBSDKLoginManager = FBSDKLoginManager()
        let facebookReadPermissions = ["public_profile", "email", "user_friends"]
        
        login.loginBehavior = FBSDKLoginBehavior.browser
        
        login.logIn(withReadPermissions: facebookReadPermissions, from: Controller) { (result,error) in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                    print("error occurs")
                    //ActivityIndicator().hideActivityIndicatory(uiView: self.)
                    SharedFunctions.ShowAlert(controller: Controller, message:"User cancelled he Login Process!")
                    UIApplication.shared.statusBarStyle = .lightContent
                    FBSDKLoginManager().logOut()
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    print("success")
                   
                    self.returnUserData(Controller: Controller)
                }
            }
        }
    }
    
    func returnUserData(Controller:UIViewController){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.parseFacebookData(result: result as AnyObject!,controller: Controller)
                }
            })
        }
    }
    
    func parseFacebookData (result:AnyObject!,controller:UIViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
        ActivityIndicator().showActivityIndicatory(uiView: controller.view!)
        if (controller as? SignInViewController != nil) {
            (controller as! SignInViewController).FacebookGetResult(result: result)
        }else if (controller as? SignUpViewController != nil) {
            (controller as! SignUpViewController).SignUpFacebookGetResult(result: result)
        }
    }
    
    func handleDidBecomeActive(){
        FBAppCall.handleDidBecomeActive();
    }
    
}
