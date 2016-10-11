//
//  NewMessageController.swift
//  chatchat
//
//  Created by Antoine Galpin on 20/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase


class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TESTTTT"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func handleCancel () {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionnary = snapshot.value as? [String: NSObject] {
                let user = User()
                user.id = snapshot.key
                print(snapshot)
                user.setValuesForKeys(dictionnary)
                self.users.append(user)
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageURL:String = user.profileImage {
            cell.profileImageView.loadImageUsingCache(urlString: profileImageURL)
        }
        
        
        return cell
    }
    
    var MyTarBarCtrl: MyTabBarController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

