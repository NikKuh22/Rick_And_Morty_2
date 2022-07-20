//
//  AuthorizationViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.07.2022.
//

import UIKit
import Firebase

final class AuthorizationController {
    func logicForAuth(user: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: user, password: password) { result, error in
            if error != nil {
                completion(false)
//                print("Error \(error)")
                
            }
            if result != nil {
                completion(true)
//                print("Result \(result)")
            }
        }
    }
}


final class AuthorizationViewController: UIViewController {
    
    var controller = AuthorizationController()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var buttonEnter: UIButton!
    
    @IBAction func loginEnterButton(_ sender: Any) {
        buttonEnter.configuration?.showsActivityIndicator = true
        controller.logicForAuth(user: emailTextField.text!, password: passwordTextField!.text!) { success in
            if success == true {
                let charactersViewController = UIStoryboard (name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainSplitViewController") as! MainSplitViewController
                self.present(charactersViewController, animated: true)
            } else {
                let alert = UIAlertController(title: "Oops...", message: "Incorrectly entered password or email", preferredStyle: .alert)
                print("Error")
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
                self.buttonEnter.configuration?.showsActivityIndicator = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnter.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notificaton:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.becomeFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        
        if emailText?.isEmpty == true || passwordText?.isEmpty == true {
            buttonEnter.isEnabled = false
        } else {
            buttonEnter.isEnabled = true
        }
        return true
    }
}

extension AuthorizationViewController {
    
    @objc private func keyboardWillShow(notificaton: NSNotification) {
        if let keyboardFrame: NSValue = notificaton.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let textField = self.view.frame.height - (passwordTextField.frame.origin.y - passwordTextField.frame.height)
            self.view.frame.origin.x -= keyboardHeight - textField
        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
}
