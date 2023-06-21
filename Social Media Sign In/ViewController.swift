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


class ViewController: UIViewController {
    
    @IBOutlet weak var fbBtn: UIButton!
    
    let appleSignInBtn = ASAuthorizationAppleIDButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton(isLoggedIn: (AccessToken.current != nil))
        updateMessage(with: Profile.current?.name)
        
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

    
    @objc func appleSignIn(){
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.fullName,.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    @IBAction func googleBtn(_ sender: UIButton) {
        //GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }

            print("Google login Sucessful")
//            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//                guard error == nil else { return }
//                guard let signInResult = signInResult else { return }
//
//                let user = signInResult.user
//
//                let emailAddress = user.profile?.email
//
//                let fullName = user.profile?.name
//                let givenName = user.profile?.givenName
//                let familyName = user.profile?.familyName
//
//                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//
//                print(emailAddress)
//                print(fullName)
//                print(profilePicUrl)
//            }
          }
        
    }
    //MARK: - Spare Google SignIn
    
//    @IBAction func googleBtn(_ sender: UIButton) {
//        GIDSignIn.sharedInstance.signOut() // Optional: You can sign out the user before initiating the sign-in process
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//            if let error = error {
//                print("Google sign-in error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let signInResult = signInResult else {
//                print("Google sign-in result is nil")
//                return
//            }
//
//            let user = signInResult.user
//
//            let emailAddress = user.profile!.email
//            let fullName = user.profile!.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//
//            let profilePicUrl = user.profile!.imageURL(withDimension: 320)
//
//            print("Email Address: \(emailAddress ?? "")")
//            print("Full Name: \(fullName ?? "")")
//            print("Profile Picture URL: \(profilePicUrl?.absoluteString ?? "")")
//        }
//    }
    
    //MARK: - Google SignOut
    
    //@IBAction func signOut(sender: Any) {
      //GIDSignIn.sharedInstance.signOut()
    //}
    
    
    @IBAction func facebookBtn(_ sender: UIButton) {
        
        // 1
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            // Access token available -- user already logged in
            // Perform log out
            
            // 2
            loginManager.logOut()
            updateButton(isLoggedIn: false)
            updateMessage(with: nil)
            
        } else {
            // Access token not available -- user already logged out
            // Perform log in
            
            // 3
            loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
                
                // 4
                // Check for error
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    return
                }
                
                // 5
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
              
                // Successfully logged in
                // 6
                self?.updateButton(isLoggedIn: true)
                
                // 7
                Profile.loadCurrentProfile { (profile, error) in
                    self?.updateMessage(with: Profile.current?.name)
                }
            }
        }
        
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed to Login!!")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential{
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            
            print(firstName)
            print(lastName)
            print(email)
            
            break
        default:
            break
        }
        
    }
}
//Google
extension ViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//Facebook
extension ViewController {
    
    private func updateButton(isLoggedIn: Bool) {
        // 1
        let title = isLoggedIn ? "Log out 👋🏻" : "Log in 👍🏻"
        print(title)
    }
    
    private func updateMessage(with name: String?) {
        // 2
        guard let name = name else {
            // User already logged out
            print("Please log in with Facebook.")
            return
        }
        
        // User already logged in
        print("Hello, \(name)!")
    }
}


//Before you can go live, an app admin must complete business verification. Once your business account has been verified, you can come back to this page and go live. Learn more about business verification.

