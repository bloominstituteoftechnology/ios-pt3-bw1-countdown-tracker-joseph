//
//  CountdownTableViewController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/20/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import UIKit

class CountdownTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var countdownList: [Countdown] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  countdownList.count
    }
    
    //FIXME: prepare for segue, with delgations patterns
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            if let addCountdownVC = segue.destination as? AddEditViewController {
                addCountdownVC.delegate = self
            }
        } else if segue.identifier == "TappedCell" {
            guard let VC = segue.destination as? AddEditViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            VC.delegate = self
            VC.countdownToUse = countdownList[indexPath.row]
            
//            if let editCountdownVC = segue.destination as? AddEditViewController {
//                editCountdownVC.delegate = self
//            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath) as? CountdownTableViewCell else { return UITableViewCell() }
        let countdown = countdownList[indexPath.row]
        cell.countdown = countdown
    cell.countdownNameLabel.text = countdownList[indexPath.row].name
        //cell.countdownNameLabel.text  = "it works"
       
            return cell
    }


}

extension CountdownTableViewController: AddCountdownDelegate {
    func countdownWasAdded(_ countdown: Countdown) {
        print("\(countdown)")
        countdownList.append(countdown)
        print("\(countdown.name)")
        print("\(countdown.duration)")
          tableView.reloadData()
        dismiss(animated: true, completion: nil)
      
    }
    
    
    
}
