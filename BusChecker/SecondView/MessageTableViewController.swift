//
//  MessageTableViewController.swift
//  BusChecker
//
//  Created by kenth on 2017-10-23.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit
import CoreData

class MessageTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext!
    var container: NSPersistentContainer =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<MessageMO>!
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    weak var bustop: BusStopMO! {
        didSet {
            viewTitle.title = self.bustop.bookmarkName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //set up the NSFetchRequest for the tableView
        context  = container.viewContext
        let request: NSFetchRequest<MessageMO> = MessageMO.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "creationDate",
            ascending: false
            )]
        request.predicate = NSPredicate.init(format:"ANY busStop.busNumber== %@ ", argumentArray: [bustop])
        fetchedResultsController = NSFetchedResultsController<MessageMO>(
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageItemTableViewCell", for: indexPath) as? MessageItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of MessageItemTableViewCell.")
        }
        let message = fetchedResultsController.object(at: indexPath)

        return cell
    }


}

extension MessageTableViewController {
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
}



extension MessageTableViewController{
    
    
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

