//
//  AuthorizationViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.07.2022.
//

import UIKit
import Firebase

final class AuthorizationViewController: UIViewController {
    var authorizedUser: Bool = false
    
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let alert = UIAlertController(title: "Oops...", message: "Incorrectly entered password or email", preferredStyle: .alert)
    
    @IBAction func loginEnterButton(_ sender: Any) {
        if authorizedUser == true {
            let charactersViewController = UIStoryboard (name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainSplitViewController") as! MainSplitViewController
            present(charactersViewController, animated: true)
        } else {
            print("Error")
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true

        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        logicForAuth()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        logicForAuth()
        return true
    }
    
    func logicForAuth() {
        let user = userTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: user, password: password) { result, error in
            if error != nil {
                self.authorizedUser = false
                print("Error \(error)")
                
            }
            if result != nil {
                self.authorizedUser = true
                print("Result \(result)")
            }
        }
    }
}
