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
            }
            else {
                
                /*
                // Set counter bg color here
                let nextIndex = counters.count % 6
                if (nextIndex == 0)
                {
                    counter.bgColor = getColorByHex(rgbHexValue: 0x2d0a68)
                }
                else if nextIndex == 1
                {
                    counter.bgColor = getColorByHex(rgbHexValue: 0x8468e4)
                }
                else if nextIndex == 2
                {
                    counter.bgColor = getColorByHex(rgbHexValue: 0xd42b88)
                }
                else if nextIndex == 3
                {
                   counter.bgColor = getColorByHex(rgbHexValue: 0xf35552)
                }
                else if nextIndex == 4
                {
                    counter.bgColor = getColorByHex(rgbHexValue: 0xfd9139)
                }
                else
                {
                    counter.bgColor = getColorByHex(rgbHexValue: 0xffce22)
                }
                */
                
                // Add a new counter.
                counters.append(counter)
            }
            
            // Remove previous notifications
            
            saveCountdowns()
            // Sort countdown list
            counters = sortCountdowns(counters)
            tableView.reloadData()
        }
        if ((sender.source as? SettingsTableViewController) != nil) {
            counters = sortCountdowns(counters)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindAndDelete(sender: UIStoryboardSegue)
    {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("The selected cell is not being displayed by the table")
        }
        self.deleteCountdown(indexPath: indexPath)
    }

    private func saveCountdowns() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: counters, requiringSecureCoding: false)
            try data.write(to: Counter.ArchiveURL)
            os_log("Countdown successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save countdown...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadCountdowns() -> [Counter]? {
        do {
            let data = try Data(contentsOf:Counter.ArchiveURL)

            if let countdowns = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Counter> {
                return countdowns
            }
        } catch {
            print("Couldn't read file.")
            return nil
        }
        return nil
    }
    
    private func deleteCountdown(indexPath: IndexPath)
    {
        let index = indexPath.row
        let delCounter = self.counters[index]

        self.removeNotifier(counter: delCounter)
        self.counters.remove(at: index)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.saveCountdowns()
    }
    
    private func removeNotifier(counter:Counter)
    {
        let identifier = counter.name + counter.date.description
        var idList = [String]()
        for key in ["notificationAccess", "notifyOneWeek", "notifyOneDay", "notifyOneHour"]
        {
            idList.append(identifier + key)
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.segueDeleteCell {
            self.segueDeleteCell = false
            
            let refreshAlert = UIAlertController(title: "Delete Countdown", message: "Are you sure you want to delete this countdown?", preferredStyle: UIAlertController.Style.alert)
                
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                guard let indexPath = self.tableView.indexPathForSelectedRow else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                self.deleteCountdown(indexPath: indexPath)
            }))
                
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                guard let indexPath = self.tableView.indexPathForSelectedRow else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                self.tableView.deselectRow(at: indexPath, animated: false)
                return
                
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "logo.png"))
        tableView.backgroundView?.contentMode = .scaleAspectFit
        tableView.backgroundView?.alpha = 0.5
        
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
        cell.hexColor = counter.bgColor

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.deleteCountdown(indexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
                selCounter.bgColor = selectedCell.hexColor
                viewController.counter = selCounter
            
            case "ShowSettings":
                os_log("Showing settings", log: OSLog.default, type: .debug)

            default:
                print("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    
    }
    

}
