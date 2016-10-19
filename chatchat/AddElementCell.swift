//
//  AddElementCell.swift
//  chatchat
//
//  Created by Antoine Galpin on 16/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit

class AddElementCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let dateContainer: UIView = {
        let dc = UIImageView()
        dc.translatesAutoresizingMaskIntoConstraints = false
        dc.layer.cornerRadius = 24
        dc.backgroundColor = UIColor(red: 32/255, green: 66/255, blue: 124/255, alpha: 1)
        dc.layer.masksToBounds = true
        return dc
    }()
    
    let dateText: UILabel = {
        let dt = UILabel()
        dt.translatesAutoresizingMaskIntoConstraints = false
        dt.textColor = UIColor.white
        return dt
    }()
    
    let timelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(style:UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(dateContainer)
        addSubview(dateText)
        addSubview(timelabel)
        
        dateContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        dateContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dateContainer.widthAnchor.constraint(equalToConstant: 48).isActive = true
        dateContainer.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timelabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timelabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timelabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
        
        //
        dateText.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor).isActive = true
        dateText.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error (inCode) from UserCell")
    }
}
