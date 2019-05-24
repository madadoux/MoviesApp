//
//  MovieDetailCells.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import UIKit
import Nuke

class DescriptionCell : UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var image :UIImageView!
    
    var model : Movie? {
        didSet {
            title.text = model?.title
            if let y = model?.year {
                year.text = "Year: \(y)"
            }
        }
    }
}
class SingleElementCell : UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    var model : String! {
        didSet {
            title.text = model
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews(){
        backgroundColor = .red
    }
}


class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var image :UIImageView!
    
    var model : Photo? {
        didSet{
            guard let farm = model?.farm, let server = model?.server , let id = model?.id , let secret = model?.secret else {return}
            Manager.shared.loadImage(with: URL(string: "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")!, into: image )
        }
    }
}
