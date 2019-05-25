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
            self.movies.value = movies.sorted { (m, m2) -> Bool in
                if let t = m.title , let t2 = m2.title {
                    return t < t2
                }
                return false
            }
        }
        
        movies.asObservable()
            .subscribe(onNext: { (movies) in
                self.clusterAndSort(movies)
            }, onError: nil)
            .disposed(by: dbag)
        
    }
    
    func getMatchingContains(keyWord : String)  -> [Movie]{
        let result =  movies.value.filter { (mov) -> Bool in
            if let title = mov.title {
                return title.contains(keyWord)
            }
            return false
        }
        return result
    }
    //contains function
    func search(keyWord:String) {
        
        self.clusterAndSort(getMatchingContains(keyWord: keyWord))
    }
    //starts with
    func getMatchingPrefix( keyWord : String)-> [Movie]{
        let result =  movies.value.map { (m) -> String in
            return m.title?.lowercased() ?? ""
        }
        
        if let searchIndex = binarySearch(inputArr: result,searchItem: keyWord){
            
            var movsResults = [Movie]()
            var incIndex = searchIndex
            var decIndex = searchIndex
            
            while ( incIndex < movies.value.count && movies.value[incIndex].title!.lowercased().hasPrefix(keyWord)) {
                movsResults.append(movies.value[incIndex])
                incIndex = incIndex + 1
            }
            
            while ( decIndex > 0 && movies.value[decIndex].title!.lowercased().hasPrefix(keyWord)) {
                movsResults.append(movies.value[decIndex])
                decIndex = decIndex - 1
            }
            return movsResults
        }
        return []
    }
    
    func searchHasPrefix(keyWord:String) {
        self.clusterAndSort(getMatchingPrefix(keyWord: keyWord))
        
    }
    
    func getAllMovies(){
        self.clusterAndSort(movies.value)
    }
    
    func binarySearch(inputArr:Array<String>, searchItem: String) -> Int? {
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex].hasPrefix(searchItem)) {
                return currentIndex
            } else if (lowerIndex > upperIndex) {
                return nil
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    
}
