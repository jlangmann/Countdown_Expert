//
//  BackgroundViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/28/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [0x2d0a68, 0x8468e4, 0xd42b88, 0xf35552, 0xfd9139, 0xffce22]

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
