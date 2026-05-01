//
//  SearchFlowUITests.swift
//  MovieMosaicTests
//
//  Created by Harish Kshirsagar on 01/01/26.
//

import XCTest

final class SearchFlowUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
          super.setUp()
          continueAfterFailure = false
          app = XCUIApplication()
          app.launch()
      }
    
    override func tearDown() {
            app = nil
            super.tearDown()
        }
    
    func testSearchAndOpenDetail() {
           // 1️⃣ Type in the search field
           let searchField = app.textFields["SearchUsersField"] // accessibilityIdentifier
           XCTAssertTrue(searchField.waitForExistence(timeout: 5))
           XCTAssertTrue(searchField.exists, "Search field should exist")
           searchField.tap()
           searchField.typeText("Alice")
           
           // Dismiss keyboard (if needed)
           app.keyboards.buttons["Return"].tap()
           
           // 2️⃣ Wait for the first list item to appear
       
          let firstCell = app.cells.element(boundBy: 0)
          XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

                           // 3️⃣ Tap the first cell
           firstCell.tap()
           
           // 4️⃣ Verify detail view appears
           let detailLabel = app.staticTexts["Alice in Wonderland"]
           XCTAssertTrue(detailLabel.waitForExistence(timeout: 5))
           XCTAssertTrue(detailLabel.exists)
       }
   }
