//
//  afazerUITests.swift
//  afazerUITests
//
//  Created by Bruno Corrêa on 26/02/2018.
//  Copyright © 2018 Bruno Lemgruber. All rights reserved.
//

import XCTest

class afazerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChecklist() {
        
        snapshot("Main")
        let app = XCUIApplication()
        app.navigationBars["Checklists"].buttons["Add"].tap()
        snapshot("Add_Checklist")
        app.navigationBars["Adicionar checklist"].buttons["Cancelar"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["More Info, Ainda falta 1 item., Lista 1"]/*[[".cells.buttons[\"More Info, Ainda falta 1 item., Lista 1\"]",".buttons[\"More Info, Ainda falta 1 item., Lista 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Edit_Checklist")
        app.navigationBars["Editar Checklist"].buttons["Cancelar"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lista 1"]/*[[".cells.staticTexts[\"Lista 1\"]",".staticTexts[\"Lista 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testChecklistItem(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Lista 1"]/*[[".cells.staticTexts[\"Lista 1\"]",".staticTexts[\"Lista 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Checklist_Items")
        app.navigationBars["Lista 1"].buttons["Add"].tap()
        snapshot("Add_Checklist_Item")
        app.navigationBars["Adicionar item"].buttons["Cancelar"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["More Info, Item for Lista 1"]/*[[".cells.buttons[\"More Info, Item for Lista 1\"]",".buttons[\"More Info, Item for Lista 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Edit_Checklist_Item")
        app.navigationBars["Editar item"].buttons["Cancelar"].tap()
        
        
    }
}
