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
    
    var countdownController = CountdownNoteController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countdownController.countdowns.count
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
            VC.countdownToUse = countdownController.countdowns[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath) as? CountdownTableViewCell else { return UITableViewCell() }
        let countdown = countdownController.countdowns[indexPath.row]
//        cell.countdown = countdownController.countdown
        cell.countdownNameLabel.text = countdownController.countdowns[indexPath.row].name
        //cell.countdownNameLabel.text  = "it works"
        
        return cell
    }
}

extension CountdownTableViewController: AddCountdownDelegate {
    func countdownWasAdded(_ countdown: Countdown) {
        print("\(countdown)")
        countdownController.countdowns.append(countdown)
        print("\(countdown.duration)")
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
