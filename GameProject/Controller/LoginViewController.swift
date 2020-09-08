//
//  ViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

final class LoginViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var loginFB: UIButton!
    
    // MARK: - Properties
    struct Constant {
        static let clientID = "876601697477-1g020d6pet94m6tn6qbrcj15iu649cs2.apps.googleusercontent.com"
        static let navigationTitle = "Login"
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    @IBAction func clickLoginFB(_ sender: Any) {
        loginFace()
    }
    func loginFace(){
        let login = LoginManager()
        login.logIn(permissions: [.publicProfile, .email, .userFriends], viewController: self){
            loginResult in
            switch loginResult{
            case .failed(let error):
                print("Log in failed")
            case .success(granted: let granted, declined: let declined, token: let token):
                print("Logged In")
                self.getData()
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "categoryScreen")as!CategoryViewController
                self.navigationController?.pushViewController(vc, animated: true)
                case .cancelled:
                print("User cancelled log in")
            }
        }
    }
    func getData(){
        if ((AccessToken.current) != nil){
                       GraphRequest(graphPath: "me",
                           parameters: ["fields": "id, name"]).start(completionHandler: {
                               (connection, result , error) -> Void in
                               if error == nil {
                                   let dict = result as! [String : AnyObject]
                                   let picutreDic = dict as NSDictionary
                                   let idOfUser = picutreDic.object(forKey: "id") as! String
                                   let nameOfUser = picutreDic.object(forKey: "name") as! String
                               }
                               else {
                                   print(error?.localizedDescription)
                               }
                           })
                   }
                   else {
                       print("Access Token is nil")
                   }
    }
    // MARK: - Setup Data
    private func setupData() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = Constant.clientID
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        navigationItem.title = Constant.navigationTitle
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let email = user.profile.email ?? "No Email"
        guard let categoryScreen = storyboard?.instantiateViewController(identifier: "categoryScreen") as? CategoryViewController else {
            return
        }
        navigationController?.pushViewController(categoryScreen, animated: true)
    }
}
