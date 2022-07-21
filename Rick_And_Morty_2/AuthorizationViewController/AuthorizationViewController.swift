//
//  AuthorizationViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.07.2022.
//

import UIKit
import Firebase

final class AuthorizationController {
    var email = ""
    var password = ""
    
    func logicForAuth(completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
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
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func loginEnterButton() {
        buttonEnter.configuration?.showsActivityIndicator = true
        buttonEnter.isUserInteractionEnabled = false
        controller.logicForAuth { [weak self] success in
            self?.buttonEnter.configuration?.showsActivityIndicator = false
            self?.buttonEnter.isUserInteractionEnabled = true
            
            if success == true {
                let charactersViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainSplitViewController") as! MainSplitViewController
                self?.present(charactersViewController, animated: true)
            } else {
                let alert = UIAlertController(title: "Oops...", message: "Incorrectly entered password or email", preferredStyle: .alert)
                print("Error")
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        buttonEnter.isEnabled = false
        
        buttonEnter.configuration?.imagePadding = 16
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else { return true }
        
        let firstIndex = text.index(text.startIndex, offsetBy: range.lowerBound)
        let lastIndex = text.index(text.startIndex, offsetBy: range.upperBound)
        text.replaceSubrange(firstIndex..<lastIndex, with: string)
        
//        print(text)
        
        if textField === emailTextField {
            controller.email = text
        } else if textField === passwordTextField {
            controller.password = text
        }
        
        buttonEnter.isEnabled = !controller.email.isEmpty && !controller.password.isEmpty
        return true
    }
}

extension AuthorizationViewController {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let animationCurveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw) else {
            return
        }
        bottomConstraint.constant = keyboardEndFrame.height + 16
        
        let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: animationCurve) {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let animationCurveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRaw) else {
            return
        }
        
        bottomConstraint.constant = 16
        
        let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: animationCurve) {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
}
