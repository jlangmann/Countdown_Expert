//
//  CounterTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log

class CounterTableViewController: UITableViewController {

    var counters = [Counter]()
    
    let defaults = UserDefaults.standard
    
    @IBAction func unwindToCounterList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateCounterTableViewController, let counter = sourceViewController.counter {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing counter.
                counters[selectedIndexPath.row] = counter
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                saveCountdowns()
                
                // Add a new counter.
                let newIndexPath = IndexPath(row: counters.count, section: 0)
                
                counters.append(counter)
                counters = sortCountdowns(counters)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.beginUpdates()
                tableView.endUpdates()
                
            }
        }
    }
    
    private func saveCountdowns() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(counters, toFile: Counter.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Countdown successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save countdowns...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadCountdowns() -> [Counter]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Counter.ArchiveURL.path) as? [Counter]
    }

    /*
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.counters[sourceIndexPath.row]
        print("*** MOVING AT poS: ")
        print(sourceIndexPath.row)
        counters.remove(at: sourceIndexPath.row)
        counters.insert(movedObject, at: destinationIndexPath.row)
        os_log("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(counters)")
        // To check for correctness enable: self.tableView.reloadData()
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let savedCountdowns = loadCountdowns()
        if (savedCountdowns! != [])  {
            counters += savedCountdowns!
        }
        
        print("Calling view did load")
        counters = sortCountdowns(counters)
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func sortCountdowns(_ countdowns: [Counter]) -> [Counter] {
        if (defaults.bool(forKey: "sortByDate"))
        {
            print("**** SORTING By DATE!!!!")
            return countdowns.sorted(by: { $0.date < $1.date })
        }
        else {
            return countdowns.sorted(by: { $0.createdAt < $1.createdAt })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CounterTableViewCell", for: indexPath) as? CounterTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let counter = counters[indexPath.row]
        
        cell.counterNameLbl.text = counter.name
        cell.img.image = counter.photo
        
        // Get combined date from date and tim
        let combinedDate = combineDateWithTime(date: counter.date, time: counter.time)
        cell.setupCounter(date: combinedDate!)
        return cell
    }

    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            counters.remove(at: indexPath.row)
            saveCountdowns()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "AddItem":
                os_log("Adding a new counter.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let viewController = segue.destination as? CreateCounterTableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedCell = sender as? CounterTableViewCell else {
                    fatalError("Unexpected sender: \(sender ?? "")")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selCounter = counters[indexPath.row]
                viewController.counter = selCounter
            
            case "ShowSettings":
                print("Show settings")

            default:
                print("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    
    }
    

}
