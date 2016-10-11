//
//  ChatViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 29/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    var user: User?
    var messages = [Message]()
    let CellId = "cellId"
    
    lazy var inputTextField: UITextField = {
        let TextField = UITextField()
        TextField.delegate = self
        TextField.placeholder = "Enter message..."
        TextField.translatesAutoresizingMaskIntoConstraints = false
        return TextField
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        navigationItem.title = user?.name
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: CellId)
        setupInputContainer()
        observeMessages()
        // Do any additional setup after loading the view.
    }
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    self.collectionView?.reloadData()
                }
                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
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
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let values = ["text": inputTextField.text!, "toid": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
       // childref.updateChildValues(values)
        childref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            let userMessageDatabase = FIRDatabase.database().reference().child("user-messages").child(fromId)
            let messageId = childref.key
            userMessageDatabase.updateChildValues([messageId: 1])
            
            let recipientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessageRef.updateChildValues([messageId: 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
