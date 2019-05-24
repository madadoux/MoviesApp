//
//  MoviesViewModel.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import RxSwift
class MoviesViewModel {
    var dbag = DisposeBag()
    var moviesSorted = Variable< [Int : [Movie]]>([:])
    var movies = Variable<[Movie]>([]);
    var jsonName :String!
    var error = PublishSubject<String>();
    init(jsonName: String) {
        self.jsonName = jsonName
    }
    
    fileprivate func clusterAndSort(_ movies: ([Movie])) {
        var moviesSorted = [Int : [Movie]] ();
        
        for mov in movies {
            if let year = mov.year {
                
                if moviesSorted[year] == nil {
                    moviesSorted[year] = []
                }
                
                moviesSorted[year]?.append(mov)
            }
        }
        for element in moviesSorted {
            moviesSorted[element.key] = element.value.sorted(by: { (a, b) -> Bool in
                guard let rA = a.rating , let rB = b.rating else {return false }
                
                return rA > rB
            })
        }
        
        self.moviesSorted.value = moviesSorted
    }
    
    func load()
    {
        guard let  path = Bundle.main.url(forResource: jsonName, withExtension: "json")
            ,  let jsonStr = try? String(contentsOf: path, encoding: String.Encoding.utf8)
            
            else {
                error.onNext("loading file failed");
                return
        }
        
        let moviesObj = MoviesResponce(JSONString: jsonStr)
        if let movies = moviesObj?.movies {
            self.movies.value = movies;
        }
        
        movies.asObservable()
            .subscribe(onNext: { (movies) in
                self.clusterAndSort(movies)
            }, onError: nil)
            .disposed(by: dbag)
        
    }
    
    func search(keyWord:String) {
        
       let result =  movies.value.filter { (mov) -> Bool in
            if let title = mov.title {
           return title.contains(keyWord)
            }
            return false
        }
        
        self.clusterAndSort(result)
    }
    
    func getAllMovies(){
        self.clusterAndSort(movies.value)
    }
    
    
    
}
