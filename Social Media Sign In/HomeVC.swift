//
//  HomeVC.swift
//  Social Media Sign In
//
//  Created by IPS-108 on 22/06/23.
//


import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Kingfisher
import AuthenticationServices

class HomeVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var fbLogin = Bool()
    var googleLogin = Bool()
    var appleLogin = Bool()
    
    var name = String()
    var email = String()
    var profilePicUrl = URL(string: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let n = name.isEmpty ? "Nil" : name
        let e = email.isEmpty ? "Nil" : email
        let p = profilePicUrl?.absoluteString.isEmpty ?? true ? "Nil" : profilePicUrl?.absoluteString
        
        print(n)
        
        let url = URL(string: p ?? "user")

        img.kf.setImage(with: url)
        username.text = "Name: \(n)"
        userEmail.text = "E-mail: \(e)"
        
    }
 
    @IBAction func logOut(_ sender: UIButton) {
        if googleLogin {
            GIDSignIn.sharedInstance.signOut()
            self.dismiss(animated: true, completion: nil)
        } else if fbLogin {
            LoginManager().logOut()
            self.dismiss(animated: true, completion: nil)
        } else if appleLogin {
            performAppleSignOut()
            
        }
    }
    
    func performAppleSignOut() {
            let alertController = UIAlertController(
                title: "Sign Out",
                message: "To sign out from Apple, please go to your device settings and sign out from there.",
                preferredStyle: .alert
            )
            
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in 
            self.dismiss(animated: true, completion: nil)
        }))
            
            present(alertController, animated: true, completion: nil)
        }
    
}

