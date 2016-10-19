//
//  ProfilViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 18/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {

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
        navigationItem.title = "Profil"
        view.backgroundColor = UIColor.white
        setupProfilImage()
    }
    
    func setupProfilImage(){
        profiImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profiImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profiImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profiImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
