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
import HCSStarRatingView
class DescriptionCell : UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var image :UIImageView!
    @IBOutlet weak var rating : HCSStarRatingView!
    
   
    var model : Movie? {
        didSet {
            title.text = model?.title
            if let y = model?.year {
                year.text = "Year: \(y)"
            }
            image.image  = UIImage(named : "movieIcon")
            image.contentMode = .scaleToFill
            image.makeRoundedWith(7)

            rating.value = CGFloat( model?.rating ?? 0)
        }
    }
}


class PhotoCell : UICollectionViewCell {
    @IBOutlet weak var image :UIImageView!
    override func awakeFromNib() {
        self.makeRoundedWith(7)
    }
    var model : Photo? {
        didSet{
            guard let farm = model?.farm, let server = model?.server , let id = model?.id , let secret = model?.secret else {return}
            DataLoader.sharedUrlCache.diskCapacity = 300
            DataLoader.sharedUrlCache.memoryCapacity = 0
            Manager.shared.loadImage(with: URL(string: "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")!) { (res) in
                if let error = res.error {
                    print(error)
                    self.image.image = UIImage(named: "noPreview")
                    return
                }
                self.image.image = res.value

            }
            
        }
    }
}
