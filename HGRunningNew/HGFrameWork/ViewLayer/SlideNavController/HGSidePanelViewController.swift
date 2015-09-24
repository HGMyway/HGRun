//
//  HGSidePanelViewController.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/17.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit


//@objc
protocol HGSidePanelViewControllerDelegate : class{
    
    func panelCellClick(selectedModel : HGSideCellModel)
    
}

class HGSidePanelViewController: UIViewController {
    
    var sideDelegate: HGSidePanelViewControllerDelegate?
    
    var sideCellList :Array<HGSideCellModel>!

    struct TableView {
        struct CellIdentifiers {
            static let sideLiseCell = "HGSideCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideCellList = HGSideCellModel.allCellData()

    }
 

}

class HGSideCell: UITableViewCell {
    func  configureForSidePannalCell(cellModel:HGSideCellModel){
        
        self.textLabel?.text = cellModel.title
    }

}

//MARK:  Table View Data Source
extension HGSidePanelViewController : UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideCellList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.sideLiseCell) as! HGSideCell
        cell.configureForSidePannalCell(sideCellList[indexPath.row])
        
        return cell

    }
    
    
    
}


// Mark: Table View Delegate
extension HGSidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //     let selectedAnimal = animals[indexPath.row]
        //    delegete?.animalSelected(selectedAnimal)
        
        let selectedModel  =  sideCellList[indexPath.row]
        
    sideDelegate?.panelCellClick(selectedModel)
        
        
    }
    
}






