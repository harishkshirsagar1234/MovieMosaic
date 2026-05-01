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
           XCTAssertTrue(searchField.exists, "Search field should exist")
           searchField.tap()
           searchField.typeText("Alice")
           
           // Dismiss keyboard (if needed)
           app.keyboards.buttons["Return"].tap()
           
           // 2️⃣ Wait for the first list item to appear
           let firstCell = app.tables["UsersList"].cells.element(boundBy: 0)
           let existsPredicate = NSPredicate(format: "exists == true")
           expectation(for: existsPredicate, evaluatedWith: firstCell, handler: nil)
           waitForExpectations(timeout: 5, handler: nil)
           
           // 3️⃣ Tap the first cell
           firstCell.tap()
           
           // 4️⃣ Verify detail view appears
           let detailLabel = app.staticTexts["UserDetailNameLabel"]
           XCTAssertTrue(detailLabel.exists, "Detail page should be displayed")
           XCTAssertEqual(detailLabel.label, "Alice")
       }
   }
