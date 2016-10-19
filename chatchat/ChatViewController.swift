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
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        collectionView?.alwaysBounceVertical = true
        navigationItem.title = user?.name
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: CellId)
        collectionView?.keyboardDismissMode = .interactive
        //setupInputContainer()
        observeMessages()
        // Do any additional setup after loading the view.
       // setupKeyboardObserve()
    }
    
    func setupKeyboardObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var inputContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        
        container.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        container.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        container.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        separator.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return container
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func handleKeyboardHide(notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        containerViewAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardShow(notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        print(keyboardFrame)
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        containerViewAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                self.collectionView?.reloadData()
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                
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
        setupColorCell(cell: cell, message: message)
        cell.bubbleWith?.constant = estimateTextSize(text: message.text!).width + 32
        return cell
    }
    
    private func setupColorCell(cell: ChatMessageCell, message: Message) {
        if let profileUrlImage = self.user?.profileImage {
            cell.profileImageVIew.loadImageUsingCache(urlString: profileUrlImage)
        }
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            cell.bubleView.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
            cell.textView.textColor = UIColor.white
            cell.profileImageVIew.isHidden = true
            cell.bubbleRight?.isActive = true
            cell.bubbleLeft?.isActive = false
            
        } else {
            cell.bubleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.bubbleRight?.isActive = false
            cell.bubbleLeft?.isActive = true
            cell.profileImageVIew.isHidden = false
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80;
        
        if let text = messages[indexPath.item].text {
            height = estimateTextSize(text: text).height + 20
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
   
    private func estimateTextSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options:
            options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    var containerViewAnchor: NSLayoutConstraint?
    
    func setupInputContainer() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        
        view.addSubview(container)
        
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewAnchor = container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewAnchor?.isActive = true
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
        childref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            let userMessageDatabase = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childref.key
            userMessageDatabase.updateChildValues([messageId: 1])
            
            let recipientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessageRef.updateChildValues([messageId: 1])
        }
        inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent?) {
        self.view.endEditing(true)
    }

}
