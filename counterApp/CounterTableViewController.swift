//
//  CounterTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import UserNotifications

import os.log

class CounterTableViewController: UITableViewController, UNUserNotificationCenterDelegate {

    var counters = [Counter]()
    
    var segueDeleteCell:Bool = false
    
    let defaults = UserDefaults.standard
    
    @IBAction func unwindToCounterList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateCounterTableViewController, let counter = sourceViewController.counter {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing counter.
                counters[selectedIndexPath.row] = counter
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new counter.
                counters.append(counter)
                saveCountdowns()

                // Sort countdown list
                counters = sortCountdowns(counters)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindAndDelete(sender: UIStoryboardSegue)
    {
        self.segueDeleteCell = true
    }
    
    @IBAction func deleteCell(_ sender: AnyObject?) {
        let selectedCell = sender?.superview??.superview as! CounterTableViewCell
        
        guard let indexPath = tableView.indexPath(for: selectedCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        counters.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
    
    override func viewDidAppear(_ animated: Bool) {
        if self.segueDeleteCell {
            self.segueDeleteCell = false
            
            let refreshAlert = UIAlertController(title: "Delete Countdown", message: "Are you sure you want to delete this countdown?", preferredStyle: UIAlertControllerStyle.alert)
                
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                guard let indexPath = self.tableView.indexPathForSelectedRow else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                self.counters.remove(at: indexPath.row)
                self.saveCountdowns()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
                
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert,.sound,.badge],
                completionHandler: { (granted,error) in
                    self.defaults.set(granted, forKey: "notificationAccess")
            }
        )
        
        navigationController?.isNavigationBarHidden = false
        let savedCountdowns = loadCountdowns()
        if (savedCountdowns != nil && savedCountdowns! != [])  {
            counters += savedCountdowns!
        }

        counters = sortCountdowns(counters)
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.tableFooterView = UIView()
    }
    
    func sortCountdowns(_ countdowns: [Counter]) -> [Counter] {
        if (defaults.bool(forKey: "sortByDate"))
        {
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
                os_log("Showing settings", log: OSLog.default, type: .debug)

            default:
                print("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    
    }
    

}
