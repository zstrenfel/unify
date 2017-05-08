//
//  LoginViewController.swift
//  Unify
//
//  Created by Zach Strenfel on 5/8/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var username = "John"
    var password = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkLogin(name: String, password: String) {
        if (username == self.name && password == self.password) {
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
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
    }

}
