//
//  ViewController.swift
//  GameProject
//
//  Created by Vu Xuan Cuong on 9/3/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import GoogleSignIn

final class LoginViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var googleSignInButton: GIDSignInButton!
    
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
