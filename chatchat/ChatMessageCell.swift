//
//  ChatMessageCell.swift
//  chatchat
//
//  Created by Antoine Galpin on 10/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SOME TEXT"
        tv.isUserInteractionEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textColor = UIColor.white
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let bubleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        return bv
    }()
    
    let profileImageVIew: UIImageView = {
        let pv = UIImageView()
        pv.image = UIImage(named: "Contacts")
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.layer.cornerRadius = 16
        pv.layer.masksToBounds = true
        pv.contentMode = .scaleAspectFill
        return pv
    }()
    
    var bubbleWith: NSLayoutConstraint?
    var bubbleRight: NSLayoutConstraint?
    var bubbleLeft: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubleView)
        addSubview(textView)
        addSubview(profileImageVIew)
        
        profileImageVIew.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageVIew.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageVIew.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageVIew.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        bubbleRight = bubleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRight?.isActive = true
        
        bubbleLeft = bubleView.leftAnchor.constraint(equalTo: profileImageVIew.rightAnchor, constant: 8)
        //bubbleLeft?.isActive = false
        
        bubleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWith = bubleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWith?.isActive = true
        bubleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
