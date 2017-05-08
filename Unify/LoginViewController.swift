//
//  LoginViewController.swift
//  Unify
//
// taken from: https://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password
//
//  Created by Zach Strenfel on 5/8/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if (hasLogin) {
            self.loginButton.setTitle("Login", for: .normal)
            self.loginButton.tag = self.loginButtonTag
        } else {
            self.loginButton.setTitle("Sign Up", for: .normal)
            self.loginButton.tag = self.createLoginButtonTag
        }
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            self.nameField.text = storedUsername
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func login(_ sender: UIButton) {
        self._login(sender)
    }
    
    func _login(_ sender: UIButton) {
        if (self.nameField.text == "" || self.passwordField.text == "") {
            let alertView = UIAlertController(title: "Login Problem", message: "Please enter both username and password." as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
        
        self.nameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        if sender.tag == self.createLoginButtonTag {
            let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
            if !hasLoginKey {
                UserDefaults.standard.set(self.nameField.text, forKey: "username")
            }
            
            MyKeychainWrapper.mySetObject(self.passwordField.text, forKey: kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            UserDefaults.standard.set(true, forKey: "hasLoginKey")
            UserDefaults.standard.synchronize()
            
            loginButton.tag = loginButtonTag
            performSegue(withIdentifier: "showMain", sender: self)
        } else if sender.tag == loginButtonTag {
            if (self.checkLogin(name: self.nameField.text!, password: self.passwordField.text!)) {
                performSegue(withIdentifier: "showMain", sender: self)
            } else {
                let alertView = UIAlertController(title: "Login Problem", message: "Wrong username or password." as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func checkLogin(name: String, password: String) -> Bool {
        if password == MyKeychainWrapper.myObject(forKey: "v_data") as? String && name == UserDefaults.standard.value(forKey: "username") as? String {
            return true
        }
        return false
    }

}
