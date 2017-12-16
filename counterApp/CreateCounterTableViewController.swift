//
//  CreateCounterTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 12/3/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log

class CreateCounterTableViewController: UITableViewController {
    
    var timeCellExpanded: Bool = false
    let formatter = DateFormatter()
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var editImgBtn: UIButton!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var counter: Counter?
    var selectedDate:Date = Date()

    @IBAction func timePicked(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss a"
        timeLbl.text = formatter.string(from: timePicker.date)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        // DOne
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "HH:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        timeLbl.text = formatter.string(from: timePicker.date)
        
        formatter.dateFormat = "MM DD YYYY"
        dateLbl.text = formatter.string(from:Date())
        selectedDate = Date()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2
        {
            if timeCellExpanded{
                timeCellExpanded = false
            }
            else {
                timeCellExpanded = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2
        {
            if timeCellExpanded {
                return 250
            }
        }
        return 50
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo1 = photoImageView.image
        if (name == "")
        {
            let alertController = UIAlertController(title: "Cannot Save Counter", message: "Invalid counter name", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        counter = Counter(name: name, photo: photo1, date: selectedDate)
        
    }
    @IBAction func unwindFromCalendar(sender: UIStoryboardSegue) {
        if let calendarController = sender.source as? CalendarViewController, let selectedDate2 = calendarController.selectedDate {
            
            selectedDate = selectedDate2
            formatter.dateFormat = "MM DD YYYY"
            dateLbl.text = formatter.string(from:selectedDate)
        }
    }
}
