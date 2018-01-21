//
//  CreateCounterTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 12/3/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log

class CreateCounterTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerData = [["Anniversary", "Birthday", "Deadline", "Holiday", "Vacation"]]
    var timeCellExpanded: Bool = false
    let formatter = DateFormatter()
    var showNames = false
    
    @IBOutlet var namePicker: UIPickerView!
    @IBOutlet var caretImg: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var editImgBtn: UIButton!

    @IBOutlet var deleteBtn: UIButton!
    
    var counter: Counter?
    var selectedDate: Date = Date()
    
    @IBAction func selectImage(_ sender: Any) {
        _chooseImage()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int
        ) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_
        pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int)
    {
        nameTextField.text = pickerData[component][row]
    }

    @IBAction func startEditing(_ sender: Any) {
        self.showNames = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func stopEditing(_ sender: Any) {
        self.showNames = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    @IBAction func timePicked(_ sender: Any) {
        formatter.dateFormat = "HH:mm:ss a"
        timeLbl.text = formatter.string(from: timePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func _chooseImage() {
        // Select photo from photo gallery
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that
        // lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateFormat = "h:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        namePicker.delegate = self
        namePicker.dataSource = self
        
        nameTextField.delegate = self
        
        if let counter = counter {
            navigationItem.title = counter.name
            nameTextField.text = counter.name
            photoImageView.image = counter.photo
            selectedDate = counter.date
            timePicker.date = counter.time
            self.deleteBtn.isHidden = false
        }
        else
        {
            selectedDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            timePicker.date = selectedDate
            self.deleteBtn.isHidden = true
        }
        timeLbl.text = formatter.string(from: timePicker.date)
        formatter.dateStyle = .long
        dateLbl.text = formatter.string(from:selectedDate)
        
        tableView.tableFooterView = UIView()
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
        
        if (indexPath.row == 2){
            performSegue(withIdentifier: "selectDate", sender: nil)
        }
        else if indexPath.row == 3
        {
            if timeCellExpanded{
                timeCellExpanded = false
                caretImg.image = UIImage(named: "arrowCollapse")
            }
            else {
                timeCellExpanded = true
                caretImg.image = UIImage(named: "arrowExpand")
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else if (indexPath.row == 5)
        {
            _chooseImage()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3
        {
            if timeCellExpanded {
                return 250
            }
        }
        else if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 6)
        {
            return 25
        }
        else if (indexPath.row == 0 && self.showNames) {
            return 200
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let button = sender as? UIBarButtonItem
        if (button != nil && button == saveButton)
        {
            let name = nameTextField.text ?? ""
            if (name == "")
            {
                //nameTextField.text = "Untitled Countdown to " + dateLbl.text!;
                
                let alertController = UIAlertController(title: "Cannot Save Counter", message: "Enter a counter name!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
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
        counter = Counter(name: name, photo: photo1, date: selectedDate, time: timePicker.date, createdAt: Date())
    }

    @IBAction func unwindFromCalendar(sender: UIStoryboardSegue) {
        if let calendarController = sender.source as? CalendarViewController, let selDate = calendarController.selectedDate {
            selectedDate = selDate
            formatter.dateStyle = .long
            dateLbl.text = formatter.string(from:selectedDate)
        }
    }
}
