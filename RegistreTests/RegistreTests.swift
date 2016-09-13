//
//  RegistreTests.swift
//  RegistreTests
//
//  Created by Renan De Souza on 11/09/16.
//  Copyright © 2016 Renan De Souza. All rights reserved.
//

import XCTest
@testable import Registre

class RegistreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewControllers() {
        
        let dashnboard = DashboardsViewController()
        let accounts = AccountsTableViewController()
        let reports = ReportsViewController()
        
        XCTAssertNotNil(dashnboard.view, "View Did Not load")
        XCTAssertNotNil(accounts.view, "View Did Not load")
        XCTAssertNotNil(reports.view, "View Did Not load")
    }
    
}
