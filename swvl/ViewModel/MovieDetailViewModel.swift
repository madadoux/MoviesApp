//
//  MovieDetailViewModel.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class MovieDetailViewModel {
        var movie : Movie!
        init(movie : Movie) {
            self.movie = movie
        }
        
    var photosSubject = Variable<[Photo]>([])
        func getPhotos(){
            API().getPhotosOfMovie(title: movie.title!, onSucess: { (photos) in
                self.photosSubject.value = photos
            }) { (e) in
                print(e)
            }
        }
        
        
        
        
        
}
