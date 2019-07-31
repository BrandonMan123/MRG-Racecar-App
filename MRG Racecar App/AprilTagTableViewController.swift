//
//  AprilTagTableViewController.swift
//  MRG Racecar App
//
//  Created by Brandon Man on 24/7/2019.
//  Copyright © 2019 Brandon Man. All rights reserved.
//

import UIKit

class AprilTagTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var aprilTagList = [Int32]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func viewDidAppear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        aprilTagList = tabbar.tags
        print ("April tags recieved in april tag view controller: ", aprilTagList)
        print ("aprilTagList size: \(aprilTagList.count)")
        self.tableView.reloadData()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print ("Table view function is called")
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        aprilTagList = tabbar.tags
        if aprilTagList.count == 0{
            return 1
        }else{
            return aprilTagList.count
        }
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        
        aprilTagList = tabbar.tags
        if aprilTagList.count == 0{
            cell.textLabel?.text = "No april tags detected"
            
        
            
        }else{
            cell.textLabel?.text = "Tag ID: \(aprilTagList[indexPath.row])"
            
            
        }
        // Configure the cell...
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
