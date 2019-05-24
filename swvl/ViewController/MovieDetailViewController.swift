//
//  MovieDetailViewController.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        contentView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: appsCollectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
                if let elements = elements {
                    cell.model = elements[indexPath.row]
                    
        }
        return cell

    return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let elements = elements {
            return CGSize(width: CGFloat(elements[indexPath.row].count*10),height:collectionView.bounds.height - 5)
  
            
        }
        return CGSize.zero
    }
   
}

class AppCell: UICollectionViewCell {
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
        backgroundColor = .gray
        lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(lbl)
        contentView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: lbl)
        contentView.addConstraintsWithFormat("V:|[v0]|", views: lbl)
    }
}

class MovieDetailViewController  : UIViewController{
    
    @IBOutlet weak var collection:UICollectionView!
    var dbag = DisposeBag()
    var viewModel : MovieDetailViewModel!
    var movie :Movie!
    let elementsBeforePhotos = 3
    
    override func awakeFromNib() {
        
    }
    
    override func viewDidLoad() {
        collection.delegate = self
        collection.dataSource = self
        viewModel = MovieDetailViewModel(movie: movie)
        viewModel.getPhotos()
        
        viewModel.photosSubject
            .asObservable()
            .subscribe { (photos) in
                self.collection.reloadData()
                print(photos)
            }
            .disposed(by: dbag)
        collection.register(UINib.init(nibName: "HorizontalScrollCell", bundle: nil) , forCellWithReuseIdentifier: "horizontalCell")
        
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: "horizontalCell")

    }
}


extension MovieDetailViewController : UICollectionViewDelegate   {
    
    
}
extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
enum CellIndex : Int {
    case description = 0
    case genere
    case cast
}
extension MovieDetailViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  let cellIndex = CellIndex.init(rawValue: indexPath.row) {
            switch cellIndex {
            case .description:
                return CGSize(width: collectionView.bounds.width, height: 100)
            case .genere:
                return CGSize(width: collectionView.bounds.width, height: 50)
                
            case .cast:
                return CGSize(width: collectionView.bounds.width, height: 50)
            }}
        else {
            //case photos:
            return CGSize(width: collectionView.bounds.width/2 - 10, height:collectionView.bounds.width/2 - 10 )
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  elementsBeforePhotos + viewModel.photosSubject.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cellIndex = CellIndex.init(rawValue: indexPath.row) {
            switch cellIndex {
            case .description:
                return generateDescriptionCell(collectionView, indexPath: indexPath)
            case .genere:
                return generateHorizontalCell(collectionView, indexPath: indexPath, elements: movie.genres)
                
            case .cast:
                return generateHorizontalCell(collectionView, indexPath: indexPath, elements: movie.cast)
                
            }}
        else {
            // case photos:
            return generatePhotosCell(collectionView,indexPath: indexPath)
        }
        
    }
    
    
    func  generateDescriptionCell(_ collectionView: UICollectionView, indexPath : IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
        cell.model = movie
        
        return cell
    }
    func generateHorizontalCell(_ collectionView: UICollectionView, indexPath : IndexPath,  elements: [String]?) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as!CategoryCell
        cell.elements =  elements
        return cell
    }
    
    
    func generatePhotosCell(_ collectionView: UICollectionView, indexPath : IndexPath ) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.model = self.viewModel.photosSubject.value[indexPath.row-elementsBeforePhotos]
        return cell
    }
}
