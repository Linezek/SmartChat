//
//  LoginController.swift
//  chatchat
//
//  Created by Antoine Galpin on 14/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var placeholderChance = ""
    var MytabBarController: MyTabBarController?
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let pi = UIImageView()
        pi.image = UIImage(named: "Contacts3")
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.contentMode = .scaleAspectFill
        pi.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePickAnImage)))
        pi.isUserInteractionEnabled = true
        return pi
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegistrerChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegistrerChange() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.placeholder = ""
            nameTextField.text = "";
            profileImageView.image = UIImage(named: "mytodolist")
        } else {
            profileImageView.image = UIImage(named: "Contacts3")
            nameTextField.placeholder = "Name"
        }
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegistrerView.setTitle(title, for: UIControlState())
        inputsContainerViewHeightAcnhor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 150 : 100
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 0)
        nameTextFieldHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    lazy var loginRegistrerView: UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = UIColor(red: 55/255, green: 95/255, blue: 162/255, alpha: 1)
        Button.setTitle("Register", for: UIControlState())
        Button.setTitleColor(UIColor.white, for: UIControlState())
        Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return Button
    }()
    
    func handleRegisterLogin () {
        setupSpinnerLoadingStart()
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin () {
        guard let password = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: password, completion:
            {(user, error) in
            if error != nil {
                print(error)
                self.setupSpinnerLoadingStop()
                self.alert("Error Login", message: "Bad login or bad password")
                return
            }
            self.MytabBarController?.FetchIfTheUserIsSetupNavBar()
            self.dismiss(animated: true, completion: nil)
            self.setupSpinnerLoadingStop()
        })
    }
    
    let spinnerLoading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 32/255, green: 66/255, blue: 124/255, alpha: 1)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegistrerView)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(spinnerLoading)
        
        titleViewNavigation()
        setupInputsContainer()
        setuploginRegistrerButton()
        setupProfileImage()
        setupRegisterAndLoginSegment()
        setupSpinnerLoadingStop()
    }
    
    func setupSpinnerLoadingStart() {
        spinnerLoading.center = view.center
        spinnerLoading.startAnimating()
    }
    
    func setupSpinnerLoadingStop() {
        spinnerLoading.center = view.center
        spinnerLoading.stopAnimating()
    }
    
    func setupRegisterAndLoginSegment() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setuploginRegistrerButton() {
        loginRegistrerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegistrerView.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegistrerView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegistrerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    var inputsContainerViewHeightAcnhor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor:  NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:  NSLayoutConstraint?
    
    func setupInputsContainer() {
        /* Center the white screen on X and Y */
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAcnhor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAcnhor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)
        
        /* NameTextField */
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        /* NameSeparator*/
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        /* EmailTextfield */
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        /* emailSeparator */
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        /* passwordTextFIeld */
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func titleViewNavigation() {
        let titleButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        titleButton.setTitle("MyToDoList", for: UIControlState())
        titleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 25.0)
        titleButton.setTitleColor(UIColor.red, for: UIControlState())
    }
    /* adapt time/battery/Cell to background color */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle
            .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion:
            nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        self.view.endEditing(true)
    }
}
