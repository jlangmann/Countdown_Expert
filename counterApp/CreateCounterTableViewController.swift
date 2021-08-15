//
//  CreateCounterTableViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 12/3/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log
import UserNotifications

class CreateCounterTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerData = [["Anniversary", "Birthday", "Deadline", "Event", "Holiday", "Vacation"]]
    var timeCellExpanded: Bool = false
    var nameCellExpanded: Bool = false
    let formatter = DateFormatter()
    var showNames = false
    
    @IBOutlet var namePicker: UIPickerView!
    @IBOutlet var caretImg: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var editImgBtn: UIButton!
    @IBOutlet var timeDone: UIButton!
    @IBOutlet var expandNames: UIImageView!
    @IBOutlet var nameDone: UIButton!
    
    @IBOutlet var previewCell: UITableViewCell!
    @IBOutlet var previewImg: UIImageView!
    
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var bgCell: UITableViewCell!
    
    @IBOutlet var bgCellView: UIView!
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
 
    @IBAction func nameDoneClose(_ sender: Any) {
        nameCellExpanded = false
        expandNames.image = UIImage(named: "arrowCollapse")
        nameDone.isHidden = true
        namePicker.isHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    @IBAction func timeDoneClose(_ sender: Any) {
        // time close and done
        timeCellExpanded = false
        caretImg.image = UIImage(named: "arrowCollapse")
        let indexPath = IndexPath(row: 3, section: 0)
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        timeDone.isHidden = true
        timePicker.isHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Set previewImg to display the selected image.
            DispatchQueue.main.async {
                self.previewImg.image = selectedImage
                self.previewImg.setNeedsDisplay()
            }
        }

        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    @IBAction func timePicked(_ sender: Any) {
        formatter.dateFormat = "h:mm a"
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

        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        namePicker.delegate = self
        namePicker.dataSource = self
        nameTextField.delegate = self
        
        timeDone.isHidden = true
        timePicker.isHidden = true
        timeDone.contentHorizontalAlignment = .right
        
        nameDone.isHidden = true
        nameDone.contentHorizontalAlignment = .right

        datePicker.minimumDate = Date()
        datePicker.semanticContentAttribute = .forceRightToLeft
        datePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft

        previewImg.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: previewImg!, attribute: .height, relatedBy: .equal, toItem: previewCell, attribute: .height, multiplier: 0.8, constant: 0).isActive=true
                
        NSLayoutConstraint(item: previewImg!, attribute: .centerX, relatedBy: .equal, toItem: previewCell, attribute: .centerX, multiplier: 1, constant: 0).isActive=true
        
        NSLayoutConstraint(item: previewImg!, attribute: .centerY, relatedBy: .equal, toItem: previewCell, attribute: .centerY, multiplier: 1, constant: 0).isActive=true
        
        
        
        if let counter = counter {
            navigationItem.title = counter.name
            nameTextField.text = counter.name
            previewImg.image = counter.photo
            selectedDate = counter.date
            timePicker.date = counter.time
            self.deleteBtn.isHidden = false
            self.previewCell.backgroundColor = counter.bgColor
            self.previewCell.backgroundColor?.setFill()
        }
        else
        {
            selectedDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            timePicker.date = selectedDate
            self.deleteBtn.isHidden = true
            self.previewCell.backgroundColor = BackgroundViewController.randomColor()
        }
        timeLbl.text = formatter.string(from: timePicker.date)
        formatter.dateStyle = .long
        datePicker.setDate(selectedDate, animated: false)
        
        tableView.tableFooterView = UIView()
        let topInset: CGFloat = 30
        tableView.contentInset.top = topInset
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 1)
        {
            //  Expanding names
            if nameCellExpanded {
                nameCellExpanded = false
                expandNames.image = UIImage(named: "arrowCollapse")
                namePicker.isHidden = true
                nameDone.isHidden = true
            }
            else {
                nameCellExpanded = true
                expandNames.image = UIImage(named: "arrowExpand")
                namePicker.isHidden = false
                nameDone.isHidden = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
        else if indexPath.row == 4
        {
            if timeCellExpanded{
                timeCellExpanded = false
                caretImg.image = UIImage(named: "arrowCollapse")
                timeDone.isHidden = true
                timePicker.isHidden = true
            }
            else {
                timeCellExpanded = true
                caretImg.image = UIImage(named: "arrowExpand")
                timeDone.isHidden = false
                timePicker.isHidden = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        else if (indexPath.row == 6)
        {
            _chooseImage()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 4 && timeCellExpanded {
            return (230 + super.tableView(tableView, heightForRowAt: indexPath))
        }
        
        if indexPath.row == 1 && nameCellExpanded {
            return (150 + super.tableView(tableView, heightForRowAt: indexPath))
        }
        
        if indexPath.row == 8 {
            return UIScreen.main.bounds.width*0.7
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        /*
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
         */
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        var name = nameTextField.text
        let photo1 = previewImg.image
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: timePicker.date)
        let timeDate = calendar.date(from: components)!
        if let counter = counter {
            if (name != counter.name || selectedDate != counter.date)
            {
                // Remove the notifier
                let identifier = counter.name + counter.date.description
                var idList = [String]()
                for key in ["notificationAccess", "notifyOneWeek", "notifyOneDay", "notifyOneHour"]
                {
                    idList.append(identifier + key)
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idList)
            }
            counter.name = name!
            counter.photo = photo1
            counter.date = datePicker.date
            counter.time = timeDate
            counter.bgColor = previewCell.backgroundColor!
        }
        else {
            if name == ""
            {
                name = "Untitled"
            }
            counter = Counter(name: name!, photo: photo1, date: selectedDate, time: timeDate, createdAt: Date(), bgColor: previewCell.backgroundColor!)
        }
    }

    
    @IBAction func unwindFromBackgroundColor(sender: UIStoryboardSegue) {
        if let backgroundController = sender.source as? BackgroundViewController {
            let selColor = backgroundController.selColor
            counter?.bgColor = selColor
            previewCell.backgroundColor = selColor
        }
    }

}
