//
//  SettingsTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/7/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var cellExpanded: Bool = false
    @IBOutlet var sortByDateBtn: UIButton!
    @IBOutlet var sortByCreatedBtn: UIButton!
    @IBOutlet var pushNotificationSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    let sortByDateConstant = "sortByDate"
    let notificationAccess = "notificationAccess"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defaults.bool(forKey: sortByDateConstant)) {
            sortByDateBtn.isSelected = true
        } else {
            sortByCreatedBtn.isSelected = true
        }
        tableView.tableFooterView = UIView()
    }

    @IBAction func createdBtnClick(_ sender: UIButton) {
        sortByCreatedBtn.isSelected = true
        sortByDateBtn.isSelected = false
        defaults.set(false, forKey: sortByDateConstant)
    }
    @IBAction func buttonClick(_ sender: UIButton) {
        sortByCreatedBtn.isSelected = false
        sortByDateBtn.isSelected = true
        defaults.set(true, forKey: sortByDateConstant)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushNotificationAction(_ sender: Any) {
        defaults.set(pushNotificationSwitch.isOn, forKey: notificationAccess)
    }
    

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if cellExpanded {
                cellExpanded = false
            }
            else {
                cellExpanded = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            //if cellExpanded {
            //    return 200
            //}
        }
        return 50
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
