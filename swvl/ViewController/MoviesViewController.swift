//
//  MoviesViewController.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import  UIKit
import RxSwift
import RxCocoa
class MoviesViewController : UIViewController
{
    var dbag = DisposeBag()
    @IBOutlet weak var moviesTableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    let viewModel = MoviesViewModel(jsonName: "movies")
    override func viewDidLoad() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        viewModel.moviesSorted
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe { (map) in
                self.moviesTableView.reloadData()
                // print(map)
            }
            .disposed(by: dbag)
        searchBar.rx.text
            .asObservable()
            .subscribe(onNext: {query in
                if let q = query , !q.isEmpty {
                    self.viewModel.search(keyWord: q)
                }
                else {
                    self.viewModel.getAllMovies()
                }
                
            })
            .disposed(by: dbag)
        
        
        
        
        
    }
    
    override func awakeFromNib() {
        DispatchQueue.global().async {
            self.viewModel.load()
        }
    }
    
    
}

extension MoviesViewController : UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = getMoviesInSection(section: section)?.count {
            return count
        }
        return 0
    }
    
    func getMoviesInSection(section: Int ) -> [Movie]? {
        let year = Array(viewModel.moviesSorted.value.keys)[section]
        if let movies =   viewModel.moviesSorted.value[year]{
            return movies
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movies = getMoviesInSection(section: indexPath.section) {
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")
            {
                
                cell.textLabel?.text = movies[indexPath.row].title
                cell.detailTextLabel?.text = "rating : \( movies[indexPath.row].rating ?? 0 )"
                return cell
            }
            
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.moviesSorted.value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let year = Array(viewModel.moviesSorted.value.keys)[section]
        return String(year)
    }
}

extension MoviesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movies = getMoviesInSection(section: indexPath.section) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "movieDetailVc") as! MovieDetailViewController
            vc.movie = movies[indexPath.row]
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
