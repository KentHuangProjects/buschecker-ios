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
        let deleteMenuItem = UIMenuItem(title: "Delete", action: #selector(BusStopItemCollectionViewCell.deleteRoute(_:)))
        
        let menuController = UIMenuController.shared
        var newItems = menuController.menuItems ?? [UIMenuItem]()
        newItems.append(deleteMenuItem)
        menuController.menuItems = newItems
        
        
        //set up the NSFetchRequest for the tableView
        context  = container.viewContext
        let request: NSFetchRequest<BusStopMO> = BusStopMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "creationDate",
            ascending: true
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
        
//        _ = BusStopMO.CreateBusStopMO(stopCode: 33333, bookmarkName: "here is bookmark", busNumber: "25", creation: Date(), in: context)
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
    }
    
    var context: NSManagedObjectContext!
    var container: NSPersistentContainer =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<BusStopMO>!
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopItemCollectionViewCell", for: indexPath) as? BusStopItemCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of BusStopItemCollectionViewCell.")
        }
        let busstop = fetchedResultsController.object(at: indexPath)
        cell.bookmarkName.text = busstop.bookmarkName
        cell.bsVM = BusStopViewModel(busstop.busNumber!,String(busstop.stopCode),busstop.bookmarkName!)
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
    
    //long-press menu
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //long-press menu
    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(BusStopItemCollectionViewCell.deleteRoute(_:))
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
