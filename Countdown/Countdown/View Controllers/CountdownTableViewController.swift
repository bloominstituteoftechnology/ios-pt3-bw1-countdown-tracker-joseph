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
    
    var userInfoController = CountdownController()
    
//    var countdownList: [CountdownCodableInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
           tableView.reloadData()
       }
    
    func infoFor(indexPath: IndexPath) -> CountdownCodableInfo {
        return userInfoController.countdownInfo[indexPath.row]
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  userInfoController.countdownInfo.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
//              bookController.deleteBook(bookFor(indexPath: indexPath))
            userInfoController.deleteInfo(infoFor(indexPath: indexPath))
              tableView.deleteRows(at: [indexPath], with: .fade)
          }
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            if let addCountdownVC = segue.destination as? AddEditViewController {
                addCountdownVC.delegate = self
            }
        } else if segue.identifier == "TappedCell" {
            guard let VC = segue.destination as? AddEditViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            VC.delegate = self
            VC.countdownInfoToUse = userInfoController.countdownInfo[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell", for: indexPath) as? CountdownTableViewCell else { return UITableViewCell() }
        let countdown = userInfoController.countdownInfo[indexPath.row]
        cell.countdown = countdown
        cell.countdownNameLabel.text = userInfoController.countdownInfo[indexPath.row].name
        return cell
    }
    
}

    //MARK: Extensions

extension CountdownTableViewController: AddCountdownDelegate {
    func countdownWasAdded(_ countdown: CountdownCodableInfo) {
        userInfoController.addUserNotes(name: countdown.name ?? "Error", countdownExistingNotes: countdown.countdownExistingNotes ?? "Error")
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
