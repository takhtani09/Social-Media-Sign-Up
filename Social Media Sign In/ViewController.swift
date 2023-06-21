//
//  ViewController.swift
//  Social Media Sign In
//
//  Created by IPS-108 on 19/06/23.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btngitHub: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func btnClick(){
        print("Hello")
    }

    @IBAction func google(_ sender: UIButton) {
        
    }
    
    @IBAction func apple(_ sender: UIButton) {
        
    }
    
    @IBAction func facebook(_ sender: UIButton) {
        
    }
    
    @IBAction func twitter(_ sender: UIButton) {
        
    }
    
    @IBAction func gitHub(_ sender: UIButton) {
        
    }

}

