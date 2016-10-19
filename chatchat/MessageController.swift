//
//  ViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 14/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    var users = [User]()
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.sizeToFit()
        search.placeholder = "Search"
        search.tintColor = UIColor(red: 55/255, green: 95/255, blue: 162/255, alpha: 1)
        search.showsCancelButton = true
        search.setShowsCancelButton(false, animated: false)
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel Button is pressed")
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(searchBar)
        searchBar.delegate = self
        
        let image = UIImage(named: "SpeechBubble3")
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewChat))
        fetchUser()
       // observeMessage()
        messages.removeAll()
        messageDictionnary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        //observeUserMessages()
    }
    
    func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let userId = snapshot.key
            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let referenceMessage = FIRDatabase.database().reference().child("messages").child(messageId)
                referenceMessage.observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: NSObject] {
                        let message = Message()
                        message.setValuesForKeys(dictionary)
                        if let chatPartnerId = message.chatPartnerId() {
                            self.messageDictionnary[chatPartnerId] = message
                        }
                        self.attemptToReloadData()     
                    }
                    }, withCancel: nil)
                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    
    private func attemptToReloadData() {
        self.messages = Array(self.messageDictionnary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
        })
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
        self.tableView.reloadData()
    }
    
    func handleReload() {
        self.tableView.reloadData()
    }
    
    var timer: Timer?
    var messages = [Message]()
    var messageDictionnary = [String: Message]()
    
    func handleNewChat() {
        let NewChat = NewMessageController()
        let NewController = UINavigationController(rootViewController: NewChat)
        present(NewController, animated: true, completion: nil)
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
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionnary = snapshot.value as? [String: NSObject] {
                let user = User()
                print(snapshot)
                user.setValuesForKeys(dictionnary)
                self.users.append(user)
                self.tableView.reloadData()
            }
            }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        if let toid = message.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(toid)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImage"] as? String {
                        cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
        
        cell.detailTextLabel?.text = message.text
        if let seconds = message.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timelabel.text = dateFormatter.string(from: timestampDate as Date)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func showChatController(user: User) {
        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        print(message.text)
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let users = User()
            users.setValuesForKeys(dictionary)
            users.id = chatPartnerId
            self.showChatController(user: users)
            }, withCancel: nil)
        
       // showChatController(user: <#T##User#>)
    }
}
