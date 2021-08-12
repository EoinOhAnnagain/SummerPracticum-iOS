//
//  DBATests.swift
//  DBATests
//
//  Created by Eoin Ó'hAnnagáin on 11/08/2021.
//

import XCTest
@testable import DBA

class DBATests: XCTestCase {
    
    
//MARK: - Test ChatVC
    
    let chat = ChatViewController()
    
    func testProfanityFilter() {
        // Test profanity filter
        
        var result = chat.profanityFilter("I love you")
        XCTAssertFalse(result, "Filter flagged \"I love you\"")
        result = chat.profanityFilter("I love you fucker")
        XCTAssertTrue(result, "Filter failed to flag \"I love you fucker\"")
        result = chat.profanityFilter("I love you bitch")
        XCTAssertTrue(result, "Filter failed to flag \"I love you bitch\"")
        result = chat.profanityFilter("I love you bastard")
        XCTAssertTrue(result, "Filter failed to flag \"I love you bastard\"")
        result = chat.profanityFilter("I love you wanker")
        XCTAssertTrue(result, "Filter failed to flag \"I love you wanker\"")
    }
    
//MARK: - Test BookVC
    
    let book = BookViewController()
    
    func testNumberOfBooks() {
        //Test no books have been removed from the app
        
        let result = K.bookTitles.count
        XCTAssertGreaterThan(result, 20, "There are books misssing from the app. Total is \(K.bookTitles.count)")
    }
    

    

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
