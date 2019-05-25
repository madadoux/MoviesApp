//
//  SingleStringCell.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import UIKit

class SingleStringCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model :String!{
        didSet {
            lbl.text = model
        }
    }
    var lbl :UILabel!
    func setupViews(){
        backgroundColor = .lightGray
        lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(lbl)
        contentView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: lbl)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: lbl)
    }
}
