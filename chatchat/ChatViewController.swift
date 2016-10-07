//
//  ChatViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 29/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate {

    var user: User?
    
    lazy var inputTextField: UITextField = {
        let TextField = UITextField()
        TextField.delegate = self
        TextField.placeholder = "Enter message..."
        TextField.translatesAutoresizingMaskIntoConstraints = false
        return TextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.name
        collectionView?.backgroundColor = UIColor.white
        setupInputContainer()
        // Do any additional setup after loading the view.
    }
    
    func setupInputContainer() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        
        view.addSubview(container)
        
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        container.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        container.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        separator.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func handleSend() {
        print(inputTextField.text)
        let ref = FIRDatabase.database().reference().child("messages")
        let childref = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let values = ["text": inputTextField.text!, "toid": toId, "fromId": fromId]
        childref.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
