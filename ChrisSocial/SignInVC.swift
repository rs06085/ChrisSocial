//
//  SignInVC.swift
//  ChrisSocial
//
//  Created by Christos Karolemeas on 22/11/2016.
//  Copyright © 2016 Christos Karolemeas. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("CHRIS: Unable to authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("CHRIS: User cancelled authentication")
            } else {
                print("CHRIS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("CHRIS: Unable to authenticate with Firebase")
            } else {
                print("CHRIS: Succesfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("CHRIS: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("CHRIS: Unable to authenticate with Firebase using Email")
                        } else {
                            print("CHRIS Successfully authenticated with Firebase")
                        }
                    
                    })
                }
            })
        }
        
    }
    
}

