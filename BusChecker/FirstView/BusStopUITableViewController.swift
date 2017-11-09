//
//  BusStopUITableViewController.swift
//  BusChecker
//
//  Created by kenth on 2017-10-19.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit
import CoreData

class BusStopUITableViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the logn-press context menu
        
        //delete menuitem
        let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(BusStopItemTableViewCell.deleteRoute(_:)))
        
        //delete menuitem
        let moveTopMenuItem = UIMenuItem(title: "Move To Top", action: #selector(BusStopItemTableViewCell.moveTopRoute(_:)))
        
        
        let menuController = UIMenuController.shared
        var newItems = menuController.menuItems ?? [UIMenuItem]()
        newItems.append(deleteMenuItem)
        newItems.append(moveTopMenuItem)
        menuController.menuItems = newItems
        
        
        //set up the NSFetchRequest for the tableView
        context  = container.viewContext
        let request: NSFetchRequest<BusStopMO> = BusStopMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "creationDate",
            ascending: false
            )]
        fetchedResultsController = NSFetchedResultsController<BusStopMO>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    var context: NSManagedObjectContext!
    var container: NSPersistentContainer =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<BusStopMO>!
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopItemTableViewCell", for: indexPath) as? BusStopItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of BusStopItemTableViewCell.")
        }
        let busstop = fetchedResultsController.object(at: indexPath)
        cell.bookmarkName.text = busstop.bookmarkName
        cell.bsVM = BusStopViewModel(busstop.busNumber!,busstop.stopCode!,busstop.bookmarkName!)
        return cell
    }
    


}

extension BusStopUITableViewController {
    // MARK: - Table view data source
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Segue to the second view controller
        self.performSegue(withIdentifier: "ToMessage", sender: self)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ToMessage") {
        
            // get a reference to the second view controller
            let secondViewController = segue.destination as! MessageTableViewController
            
            let selectedIndexPath = self.tableView.indexPathForSelectedRow!
            
            //get the tapped BusStopMO object (has all the info for the tapped row)
            let selectedbusstop = fetchedResultsController.object(at: selectedIndexPath)
            
            // set a variable in the second view controller with the data to pass
            secondViewController.bustop = selectedbusstop
        }
    }
    
    //long-press menu
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //long-press menu
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(BusStopItemTableViewCell.deleteRoute(_:))
            || action == #selector(BusStopItemTableViewCell.moveTopRoute(_:))
        
    }
    
    //long-press menu
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        //You can handle standard actions here, but custom actions never trigger this. It still needs to be present for the menu to display, though.
    }
    

    
    

    


}

extension BusStopUITableViewController: NSFetchedResultsControllerDelegate {
    
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
