//
//  MyTabBarController.swift
//  chatchat
//
//  Created by Antoine Galpin on 26/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
       // UITabBar.appearance().backgroundColor = UIColor(red: 55/255, green: 95/255, blue: 162/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 55/255, green: 95/255, blue: 162/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleout))
        let image = UIImage(named: "Plus-1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewChat))
        checkIfheUserIsLogged()
    }

    func handleNewChat() {
        let addElements = AddElementViewController()
        let NewController = UINavigationController(rootViewController: addElements)
        present(NewController, animated: true, completion: nil)
    }
    
    func checkIfheUserIsLogged() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleout), with: nil, afterDelay: 0)
        } else {
            FetchIfTheUserIsSetupNavBar()
        }
    }
    
    func FetchIfTheUserIsSetupNavBar() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(User: user)
            }
            
            }, withCancel: nil)
    }
    
    func setupNavBarWithUser(User: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = User.profileImage {
            profileImageView.loadImageUsingCache(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = User.name
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleView
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChat)))
    }
    
    func handleChat() {
        print(123)
        let chatLogController = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginCtrl = LoginController()
        loginCtrl.MytabBarController = self
        present(loginCtrl, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = ContactTableViewController()
        let tabOneBarItem = UITabBarItem(title: "List", image: UIImage(named: "Document-1"), selectedImage: UIImage(named: "Document-1"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = MessageController()
        let tabTwoBarItem2 = UITabBarItem(title: "Chat", image: UIImage(named: "SpeechBubble3"), selectedImage: UIImage(named: "SpeechBubble3"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        //Create Tab3
        
        let tabThree = NewMessageController()
        let tabThreeBarItem3 = UITabBarItem(title: "Contact", image: UIImage(named: "Contacts2"), selectedImage: UIImage(named: "Contacts2"))
        
        tabThree.tabBarItem = tabThreeBarItem3
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
    }
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
