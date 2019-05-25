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

class MovieDetailViewController  : UIViewController{
    
    @IBOutlet weak var collection:UICollectionView!
    var dbag = DisposeBag()
    var viewModel : MovieDetailViewModel!
    var movie :Movie!
    let elementsBeforePhotos = 3
    var loading = true
    override func awakeFromNib() {
        
    }
    
    override func viewDidLoad() {
        collection.delegate = self
        collection.dataSource = self
        viewModel = MovieDetailViewModel(movie: movie)
        viewModel.getPhotos()
        
        viewModel.photosSubject
            .asObservable()
            .skip(1)
            .subscribe { (photos) in
                self.collection.reloadData()
                self.loading = false
                print(photos)
            }
            .disposed(by: dbag)
       
        collection.register(HorizontalScrollCell.self, forCellWithReuseIdentifier: "horizontalCell")
        
          collection.register(SingleStringCell.self, forCellWithReuseIdentifier: "singleElement")
        collection.insetsLayoutMarginsFromSafeArea = true
        
    }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left:4, bottom: 0, right: 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  let cellIndex = CellIndex.init(rawValue: indexPath.row) {
            switch cellIndex {
            case .description:
                return CGSize(width: collectionView.bounds.width, height: 200)
            case .genere:
                return CGSize(width: collectionView.bounds.width, height: 50)
                
            case .cast:
                return CGSize(width: collectionView.bounds.width, height: 50)
            }}
        else {
            
             if viewModel.photosSubject.value.count > 0{
            //case photos:
            
            return CGSize(width: collectionView.bounds.width/2 - 14, height:collectionView.bounds.width/2 - 14 )
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: 60)

            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  elementsBeforePhotos + ((viewModel.photosSubject.value.count > 0) ? viewModel.photosSubject.value.count : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  let cellIndex = CellIndex.init(rawValue: indexPath.row) {
            switch cellIndex {
            case .description:
                return generateDescriptionCell(collectionView, indexPath: indexPath)
            case .genere:
                return generateHorizontalCell(collectionView, indexPath: indexPath, elements: movie.genres,title: "Genre:")
                
            case .cast:
                return generateHorizontalCell(collectionView, indexPath: indexPath, elements: movie.cast,title: "Cast:")
                
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
    func generateHorizontalCell(_ collectionView: UICollectionView, indexPath : IndexPath,  elements: [String]?, title : String) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as!HorizontalScrollCell
        cell.elements =  elements
        cell.title = title
        return cell
    }
    
    
    func generatePhotosCell(_ collectionView: UICollectionView, indexPath : IndexPath ) -> UICollectionViewCell{
       
        if ( viewModel.photosSubject.value.count > 0 ) {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.model = self.viewModel.photosSubject.value[indexPath.row-elementsBeforePhotos]
            return cell

        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleElement", for: indexPath) as! SingleStringCell
            cell.model = (loading) ? "Loading ..." : "No images were retured (Flickr Down)"
            cell.lbl.textAlignment = .center
            cell.makeRoundedWith(7)

            return cell
        }
    }
}
