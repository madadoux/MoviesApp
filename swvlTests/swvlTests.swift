//
//  swvlTests.swift
//  swvlTests
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import XCTest
@testable import swvl
import RxSwift
import ObjectMapper
class swvlTests2: XCTestCase {
    let dbag = DisposeBag()

    var vm: MovieDetailViewModel!
    
    override func setUp() {
       vm =  MovieDetailViewModel(movie: Movie(JSON: ["title" : "Inside Out"])!)

    }
    func testGetPhotos() {
        let expectation = self.expectation(description: "getPhotos")
        vm.getPhotos()
        vm.photosSubject.asObservable().subscribe (onNext:{ (photos) in
            XCTAssert(photos.count > 1 , "no photos returned from api ")
            expectation.fulfill()
        })
        .disposed(by: dbag)
        
        waitForExpectations(timeout: 3.0, handler: nil)

    }
}
class swvlTests: XCTestCase {
    let vm = MoviesViewModel(jsonName: "movies")
    let dbag = DisposeBag()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testSearchingWithPrefix() {
        let expectation = self.expectation(description: "loading")
        
        vm.load()
        
        vm.movies.asObservable().subscribe(onNext: { (m) in
            let   results = self.vm.getMatchingPrefix(keyWord: "In".lowercased())
            XCTAssert(results.count == 31, "prefix search fail")
            expectation.fulfill()
            
        })
            .disposed(by: dbag)
        waitForExpectations(timeout: 3.0, handler: nil)
        
    }
    
    func testContainsSearching() {
        let expectation = self.expectation(description: "loading")
        
        vm.load()
        
        vm.movies.asObservable().subscribe(onNext: { (m) in
            let   results = self.vm.getMatchingContains(keyWord: "In".lowercased())
            XCTAssert(results.count == 392, "prefix search fail")
            expectation.fulfill()
            
        })
            .disposed(by: dbag)
        waitForExpectations(timeout: 3.0, handler: nil)
        
    }
    
    func testLoadingMovies() {
        let expectation = self.expectation(description: "loading")
        
        vm.load()
        
        vm.movies.asObservable().subscribe(onNext: { (m) in
       
            XCTAssert(m.count == 2272, "prefix search fail")
            expectation.fulfill()
            
        })
            .disposed(by: dbag)
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
