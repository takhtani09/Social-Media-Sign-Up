//
//  ViewController.swift
//  Social Media Sign In
//
//  Created by IPS-108 on 19/06/23.
//

//FBSDKLoginButton
// MARK: - Google Client ID
///    1017714174199-g678psab576v9eprlpmpveq0gk1mgf21.apps.googleusercontent.com

import AuthenticationServices
import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

class ViewController: UIViewController {
    
    var name = String()
    var email = String()
    var profilePicUrl = URL(string: "")
    
    @IBOutlet weak var fbBtn: UIButton!
    let appleSignInBtn = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fb
        updateButton(isLoggedIn: (AccessToken.current != nil))
        
        // Apple
        view.addSubview(appleSignInBtn)
        appleSignInBtn.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonWidth: CGFloat = 300
        let buttonHeight: CGFloat = 50
        let buttonX: CGFloat = (view.bounds.width - buttonWidth) / 2
        let buttonY: CGFloat = 200 // Adjust this value to set the desired distance from the top
        
        appleSignInBtn.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
    }
    
    @objc func appleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.fullName, .email]
        
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @IBAction func googleBtn(_ sender: UIButton) {
        //GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [self] signInResult, error in
            guard error == nil else { return }
            
            print("Google login Sucessful")
            
            
            
            
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            
            self.email = user.profile?.email ?? "nil"
            
            self.name = user.profile?.name ?? "nil"
            
            self.profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            vc.googleLogin = true
            vc.email = email
            vc.name = name
            vc.profilePicUrl = profilePicUrl
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func facebookBtn(_ sender: UIButton) {
        //LoginManager().logOut()
        let loginManager = LoginManager()

        if let _ = AccessToken.current {
            loginManager.logOut()
            updateButton(isLoggedIn: false)
        } else {
            loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }

                self?.updateButton(isLoggedIn: true)
                Profile.loadCurrentProfile { (profile, error) in
                    self?.loadUserData(with: profile?.name, email: profile?.email, profilePic: profile?.imageURL)
                }


            }
        }
    }
    
    private func updateButton(isLoggedIn: Bool) {
        let title = isLoggedIn ? "Log out 👋🏻" : "Log in 👍🏻"
        print(title)
    }
}

//Apple Login
extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed to Login!!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
            case let credentials as ASAuthorizationAppleIDCredential:
                let firstName = credentials.fullName?.givenName
                let lastName = credentials.fullName?.familyName
                let email = credentials.email

                print("Name: \(firstName) \(lastName)")
                print("Email: \(email ?? "nil")")
                print("Profile Picture URL: \(profilePicUrl?.absoluteString ?? "Nil")")

                // Pass the data to HomeVC
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.appleLogin = true
                vc.email = email ?? ""
                vc.name = "\(firstName ?? "") \(lastName ?? "")"
                //vc.profilePicUrl = self.profilePicUrl
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)

            default:
                break
            }
        }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension ViewController {
    func loadUserData(with name: String?, email: String?, profilePic: URL?) {
        // Fetch Facebook user profile data
        if let accessToken = AccessToken.current, !accessToken.isExpired {
            let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email,picture"], tokenString: accessToken.tokenString, version: nil, httpMethod: .get)
            graphRequest.start { _, result, error in
                if let error = error {
                    print("Error fetching Facebook user profile: \(error.localizedDescription)")
                } else if let userData = result as? [String: Any] {
                    let name = userData["name"] as? String
                    let userID = userData["id"] as? String
                    let email = userData["email"] as? String
                    
                    if let pictureData = userData["picture"] as? [String: Any], let picture = pictureData["data"] as? [String: Any], let profilePictureURL = picture["url"] as? String {
                        self.name = name ?? ""
                        self.email = email ?? ""
                        self.profilePicUrl = URL(string: profilePictureURL)
                        
                        // Pass the data to HomeVC
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        vc.fbLogin = true
                        vc.email = self.email
                        vc.name = self.name
                        vc.profilePicUrl = self.profilePicUrl
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
