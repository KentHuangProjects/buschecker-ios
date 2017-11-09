//
//  MessageTableViewController.swift
//  BusChecker
//
//  Created by kenth on 2017-10-23.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Foundation

class MessageTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext!
    var container: NSPersistentContainer =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<MessageMO>!
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    weak var bustop: BusStopMO! {
        didSet {
            viewTitle.title = self.bustop.bookmarkName
            routenumADD = self.bustop.busNumber
            stopcodeADD = self.bustop.stopCode
        }
    }
    
    //activity indicator
    var loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    func createAndconfigureActivityIndicatorView() {
        
        loadingalert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        loadingIndicator.hidesWhenStopped = true // Setting this true means, when you stop the activity indicator, its automatically hidden (see below)
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        loadingIndicator.startAnimating() // To start animation
        loadingIndicator.isHidden = false
    
        //loadingIndicator.center = CGPoint(x:tableView.bounds.width / 2.0, y:tableView.bounds.height / 2.0)
        loadingIndicator.startAnimating()
        loadingalert?.view.addSubview(loadingIndicator)
        
        
    }
    
     var loadingalert: UIAlertController!
    
    


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createAndconfigureActivityIndicatorView()
        
        self.present(loadingalert!, animated: true, completion: nil)
        
        
        

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
        
        
        
        
        
        //set up the url for this http request
        thisBaseUrl = "\(baseUrl)\(stopcodeADD!)/estimates"
        
        print(thisBaseUrl)
        
        //set up the sessionManager for sending http request(setting timeout to be 8 seconds)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        makeARequest()
        
        tableView.reloadData()
        
        
        
        
        
        
        
    }
    
    

    let baseUrl = "https://api.translink.ca/rttiapi/v1/stops/"
    
    var thisBaseUrl:String!
    
    //bus number; set in the didset of the bustop object
    var routenumADD : String!
    //stop code; set in the didset of the bustop object
    var stopcodeADD :String!
    
    
    func errorAlert(errormessage : String) {
        let alertController = UIAlertController(title: "Error", message: errormessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    var sessionManager:SessionManager!


    
    // make a request to get the info about time of next buses
    func makeARequest() {
        //when internet not available
//        if(!Reachability.isConnectedToNetwork()) {
//            errorAlert(errormessage: "Internet not available")
//            return
//        }
        
        //netwrok available
        
        //set up url parameters
        let parameters: Parameters = [
            "apiKey": "FuuOpcbs0O9UIjdreXwE",
            "RouteNo": routenumADD,
            "Count" : 3
        ]
        
        //set up the header
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        //sending request
        sessionManager.request(thisBaseUrl, parameters: parameters, headers: headers).responseJSON { [weak self] response in
            
            print("inside request")
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                self?.loadingalert.dismiss(animated: true, completion: nil)
            }
            
            let when1 = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when1){
                // your code with delay
                if let alertbool = self?.loadingalert.isBeingDismissed, !alertbool  {
                    self?.loadingalert.dismiss(animated: true, completion: nil)
                }
            }
            
            
            switch (response.result) {
            case .success:
                //Success
                if response.response?.statusCode == 200 {
                    print("Success with JSON: \(String(describing: response.result.value))")
                    
                }
                    //other errors
                    //Alamofire treats sent requests to be successful
                else {
                    print("fail with JSON: \(String(describing: response.result.value))")
                    print("Response: \(String(describing: response.response))") // http url response
                }
                
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    self?.errorAlert(errormessage: "Internet not available")
                } else {
                    //other errors
                    self?.errorAlert(errormessage: error.localizedDescription)
                }
                
                print("\n\nAuth request failed with error:\n \(error)")
            }
            
            
            
            
        }
        
        
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
