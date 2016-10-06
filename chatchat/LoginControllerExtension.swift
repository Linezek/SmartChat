//
//  LoginControllerExtension.swift
//  chatchat
//
//  Created by Antoine Galpin on 30/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handlePickAnImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let modifiedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = modifiedImage
        }else if let originalimage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalimage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        dismiss(animated: true, completion:  nil)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text , let _ = passwordTextField.text, let name = nameTextField.text
            else {
                print("Form is not valid")
                return
        }
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error) in
            if error != nil {
                print(error)
                self.alert("Error registrer", message: "Bad login or bad password")
                return
            }
            guard let uid = user?.uid else {
                return
            }
                let imageName = UUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
                if let profileImage =  self.profileImageView.image, let uploadData =  UIImageJPEGRepresentation(profileImage, 0.1) {
                  storageRef.put(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                   if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                    
                    let data = ["name": name, "email": email, "profileImage": profileImageUrl]
                    self.registerUserInToDataBase(uid: uid, data: data as [String : AnyObject])
                    }
                  })
            }
        })
    }
    
    private func registerUserInToDataBase(uid: String, data: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://todolistfirebase-fbea6.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(data, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                self.setupSpinnerLoadingStop()
                return
            }
            self.MytabBarController?.navigationItem.title = data["name"] as! String?
            let user = User()
            user.setValuesForKeys(data)
            self.MytabBarController?.setupNavBarWithUser(User: user)
            self.setupSpinnerLoadingStop()
            self.dismiss(animated: true, completion: nil)
        })
    }
}


