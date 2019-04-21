//
//  TaboolaHomeAssignmentTests.swift
//  TaboolaHomeAssignmentTests
//
//  Created by Alon Harari on 20/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

import XCTest
@testable import TaboolaHomeAssignment

class TaboolaHomeAssignmentTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchJSON(){
        let urlString = "https://api.myjson.com/bins/ct1nw"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let parseData = try decoder.decode([Amazon].self, from: data)

                    print(parseData)
                } catch let jsonErr {
                    print("Failed tp decode:", jsonErr)
                }
            }
            }.resume()
    }


}
