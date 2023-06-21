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


class ViewController: UIViewController {
    
    let appleSignInBtn = ASAuthorizationAppleIDButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension ViewController: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}
