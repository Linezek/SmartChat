//
//  ContactTableViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 07/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class ContactTableViewController: UITableViewController, UISearchBarDelegate {
    
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
        tableView.register(UserCellListContact.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewChat))
        fetchUser()
        observeList()
    }
    
    var allItems = [ItemClass]()
    
    func observeList() {
        let ref = FIRDatabase.database().reference().child("items")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: NSObject] {
                let item = ItemClass()
                item.id = snapshot.key
                item.setValuesForKeys(dictionary)
                self.allItems.append(item)
                self.tableView.reloadData()
                print(item.id)
            }
            }, withCancel: nil)
    }
    
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
        return allItems.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let items = allItems[indexPath.row]
        cell.textLabel?.text = items.title
        cell.detailTextLabel?.text = items.desc
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.allItems.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("testt")
    }
}

class UserCellListContact: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override init(style:UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error (inCode) from UserCell")
    }
}
