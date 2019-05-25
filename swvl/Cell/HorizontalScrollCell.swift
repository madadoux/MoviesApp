//
//  HorizontalScrollCell.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import UIKit

class HorizontalScrollCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    var elements : [String]?
    {
        didSet {
            appsCollectionView.reloadData()
        }
    }
    func setupViews() {
        backgroundColor = .white
        
        contentView.addSubview(appsCollectionView)
        
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        //  appsCollectionView.register(UINib.init(nibName: "ElementCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        appsCollectionView.register(SingleStringCell.self, forCellWithReuseIdentifier: cellId)
        contentView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: appsCollectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SingleStringCell
        if let elements = elements {
            cell.model = elements[indexPath.row]
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let elements = elements {
            return CGSize(width: CGFloat(elements[indexPath.row].count*10) + 16,height:collectionView.bounds.height - 5)
            
            
        }
        return CGSize.zero
    }
    
}
