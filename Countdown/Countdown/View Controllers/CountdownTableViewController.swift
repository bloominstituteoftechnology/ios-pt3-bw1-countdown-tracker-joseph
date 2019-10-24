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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return countdownList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath) as? CountdownTableViewCell else { return  UITableViewCell() }
        let countdown = countdownList[indexPath.row]
        cell.countdown = countdown
        return cell
    }

}

extension CountdownTableViewController: AddCountdownDelegate {
    func countdownWasAdded(_ countdown: Countdown) {
        countdownList.append(countdown)
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    
}
