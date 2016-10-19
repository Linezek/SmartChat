//
//  AddElementViewController.swift
//  chatchat
//
//  Created by Antoine Galpin on 27/09/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class AddElementViewController: UIViewController {

    
    let titleTextField: UITextField = {
        let title = UITextField()
        title.placeholder = "Title"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let datepicker: UIDatePicker = {
       let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
       return dp
    }()
    
    let DescriptionTextField: UITextField = {
        let title = UITextField()
        title.placeholder = "Description"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let DescriptionSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var SaveView: UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = UIColor(red: 55/255, green: 95/255, blue: 162/255, alpha: 1)
        Button.setTitle("Save", for: UIControlState())
        Button.setTitleColor(UIColor.white, for: UIControlState())
        Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return Button
    }()
    
    func handleSave() {
        let ref = FIRDatabase.database().reference().child("items")
        let childRef = ref.childByAutoId()
        let values = ["Title": titleTextField.text!, "desc": DescriptionTextField.text!, "date": datepicker.date.description]
        childRef.updateChildValues(values)
        self.dismiss(animated: true, completion: nil)
             print("MA DATE -> ", datepicker.date.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputContainerView)
        view.addSubview(SaveView)
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleback))
        setupContainer()
        setupSaveButton()
    }
    func handleback() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupContainer() {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -143).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        view.addSubview(titleTextField)
        view.addSubview(titleSeparatorView)
        view.addSubview(DescriptionTextField)
        view.addSubview(DescriptionSeparatorView)
        view.addSubview(datepicker)

        titleTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        titleTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        
        titleSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        titleSeparatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        titleSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        titleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        
        DescriptionTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        DescriptionTextField.topAnchor.constraint(equalTo: titleSeparatorView.topAnchor).isActive = true
        DescriptionTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        DescriptionTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        DescriptionSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        DescriptionSeparatorView.topAnchor.constraint(equalTo: DescriptionTextField.bottomAnchor).isActive = true
        DescriptionSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        DescriptionSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        datepicker.topAnchor.constraint(equalTo: DescriptionSeparatorView.bottomAnchor).isActive = true
        datepicker.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        datepicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
        datepicker.bottomAnchor.constraint(equalTo: SaveView.topAnchor).isActive = true
        
    }
    
    func setupSaveButton() {
        SaveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SaveView.topAnchor.constraint(equalTo: datepicker.bottomAnchor, constant: 0).isActive = true
        SaveView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        SaveView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle
            .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion:
            nil)
    }
}
