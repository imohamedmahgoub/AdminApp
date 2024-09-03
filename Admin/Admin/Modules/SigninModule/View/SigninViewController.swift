//
//  SigninViewController.swift
//  Admin
//
//  Created by Mohamed Mahgoub on 02/09/2024.
//

import UIKit

class SigninViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let username = "Admin"
    let password = "admin"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didSelectSignin(_ sender: Any) {
        if InternetConnection.hasInternetConnect(){
            if (usernameTextField.text == username && passwordTextField.text == password) {
                let vc = storyboard?.instantiateViewController(withIdentifier: "nav") as? nav
                guard let vc = vc else { return }
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                // self.navigationController?.pushViewController(vc, animated: true)
                usernameTextField.text = ""
                passwordTextField.text = ""
            }else{
                let alert = UIAlertController(title: "Failed", message: "Please enter username and password correctly", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive) { _ in
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
                alert.addAction(dismissAction)
                self.present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Poor internet connection", message: "Please make sure that you are connected to internet", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
            alert.addAction(dismissAction)
            self.present(alert, animated: true)
        }
    }
    

}
