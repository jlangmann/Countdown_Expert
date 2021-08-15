//
//  BackgroundViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/28/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [0x2d0a68, 0x59027c, 0xa11da0, 0xde3276, 0xf35752, 0xf7823b, 0xffa85a,0xffc468,0x000000]
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UICollectionView!
    var selColor:UIColor = UIColor.white
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
        let w = (collectionView.bounds.width / 3.0) - 20
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           let offset = CGFloat(20)
           return UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
       }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) 
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.backgroundColor = getColorByHex(rgbHexValue: UInt32(self.items[indexPath.item]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedItems = self.tableView.indexPathsForSelectedItems
        if (selectedItems?.count)! > 0
        {
            let hex = self.items[selectedItems![0].item]
            selColor = getColorByHex(rgbHexValue:UInt32(hex))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive=true
        
        NSLayoutConstraint(item: tableView!, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1, constant: 0).isActive=true
        
        NSLayoutConstraint(item: tableView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive=true
        
        NSLayoutConstraint(item: tableView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
