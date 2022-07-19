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
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func loginEnterButton(_ sender: Any) {
        logicForAuth()
        if authorizedUser == true {
            let charactersViewController = UIStoryboard (name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainSplitViewController") as! MainSplitViewController
            present(charactersViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Incorrectly entered password or email", preferredStyle: .alert)
            print("Error")
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.endEditing(true)

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notificaton:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.becomeFirstResponder()
        return true
    }
}

extension AuthorizationViewController {
    
    @objc private func keyboardWillShow(notificaton: NSNotification) {
//      let keyboardFrame: NSValue = notificaton.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
//      let keyboardHeight = keyboardFrame.cgRectValue.height
//      let textField = self.view.frame.height - (passwordTextField.frame.origin.y + passwordTextField.frame.height)
        self.view.frame.origin.y -= 100
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    func logicForAuth() {
        let user = emailTextField.text!
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
