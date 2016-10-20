//
//  ProfilViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 18/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class ProfilViewController: UIViewController {

    lazy var logoutButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.tintColor = UIColor.white
        lb.setTitle("Log out", for: UIControlState())
        lb.backgroundColor = UIColor.red
        lb.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    var MyTarBarCtrl: MyTabBarController?
    
    func handleLogOut() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginCtrl = LoginController()
        loginCtrl.ProfilViewCtrl = self
        present(loginCtrl, animated: true, completion: nil)
    }
    
    let profiImage: UIImageView = {
        let pi = UIImageView()
        pi.translatesAutoresizingMaskIntoConstraints = false
        pi.layer.cornerRadius = 50
        pi.image = UIImage(named: "Mr-Robot")
        pi.layer.masksToBounds = true
        return pi
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profiImage)
        view.addSubview(logoutButton)
        navigationItem.title = "Profil"
        view.backgroundColor = UIColor.white
        setupProfilImage()
        setupLogOutButton()
    }
    
    func setupProfilImage(){
        profiImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profiImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profiImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profiImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setupLogOutButton() {
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
