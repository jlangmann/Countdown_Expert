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
    
    @IBOutlet var oneDayCB: UIImageView!
    @IBOutlet var oneWeekCB: UIImageView!
    @IBOutlet var oneHourCB: UIImageView!
    
    @IBOutlet var oneWeekLbl: UITableViewCell!
    @IBOutlet var oneDayLbl: UILabel!
    @IBOutlet var oneHourLbl: UILabel!
    
    let defaults = UserDefaults.standard
    let sortByDateConstant = "sortByDate"
    let notificationAccess = "notificationAccess"
    let notifyOneWeek = "notifyOneWeek"
    let notifyOneDay = "notifyOneDay"
    let notifyOneHour = "notifyOneHour"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (defaults.bool(forKey: sortByDateConstant)) {
            sortByDateBtn.isSelected = true
        } else {
            sortByCreatedBtn.isSelected = true
        }
        tableView.tableFooterView = UIView()
        pushNotificationSwitch.isOn = defaults.bool(forKey: notificationAccess)
        setNotificationDefaults(isOn: pushNotificationSwitch.isOn)
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
    
    func setNotificationDefaults(isOn:Bool)
    {
        if (!isOn)
        {
            oneDayCB.isHidden = true
            oneWeekCB.isHidden = true
            oneHourCB.isHidden = true
            oneDayLbl.isHidden = true
            oneWeekLbl.isHidden = true
            oneHourLbl.isHidden = true
        }
        else
        {
            oneDayLbl.isHidden = false
            oneWeekLbl.isHidden = false
            oneHourLbl.isHidden = false
            oneWeekCB.isHidden = !defaults.bool(forKey: notifyOneWeek)
            oneDayCB.isHidden = !defaults.bool(forKey: notifyOneDay)
            oneHourCB.isHidden = !defaults.bool(forKey:notifyOneHour)
        }
    }

    @IBAction func pushNotificationAction(_ sender: Any) {
        let visible = pushNotificationSwitch.isOn
        defaults.set(visible, forKey: notificationAccess)
        setNotificationDefaults(isOn: visible)
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2
        {
            defaults.set(oneWeekCB.isHidden, forKey: notifyOneWeek)
            oneWeekCB.isHidden = !oneWeekCB.isHidden
        }
        else if indexPath.row == 3
        {
            defaults.set(oneDayCB.isHidden, forKey: notifyOneDay)
            oneDayCB.isHidden = !oneDayCB.isHidden
        }
        else if indexPath.row == 4
        {
            defaults.set(oneHourCB.isHidden, forKey: notifyOneHour)
            oneHourCB.isHidden = !oneHourCB.isHidden
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
