//
//  CountdownNotesController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/27/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation

class CountdownNoteController {
    
    //MARK: Properties
    private(set) var countdowns: [CountdownCodableValues] = []
    
    private var countdownListURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return documents.appendingPathComponent("countdowns.plist")
    }
    
    init() {
        loadFromPersistentStore()
    }
    
    //MARK: CRUD Methods
    
    @discardableResult func addCountdown(named: String, countdownExistingNotes: String) -> CountdownCodableValues? {
          let named = named.trimmingCharacters(in: .whitespaces)
          for countdown in countdowns {
            if countdown.name == named {
                  return nil
              }
          }
          let newCountdown = Countdown(name: named, countdownExistingNotes: countdownExistingNotes)
        countdowns.append(newCountdown.countdownStruct)
          saveToPersistentStore()
        return newCountdown.countdownStruct
      }
    
    func deleteCountdown(_ countdown: CountdownCodableValues) {
        guard let i = countdowns.firstIndex(of: countdown) else { return }
           countdowns.remove(at: i)
           saveToPersistentStore()
       }
    
    func updateCountdown(for countdown: CountdownCodableValues, newName: String, newNotes: String) -> CountdownCodableValues? {
           guard let i = countdowns.firstIndex(of: countdown) else {
               // if the specified countdown doesn't exist, just add it
               return addCountdown(named: newName, countdownExistingNotes: newNotes)
           }
        countdowns[i].name = newName
        countdowns[i].countdownExistingNotes = newNotes
           saveToPersistentStore()
           return countdowns[i]
       }
    
    private func saveToPersistentStore() {
        guard let url = countdownListURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let countdownsData = try encoder.encode(countdowns)
            try countdownsData.write(to: url)
        } catch {
            print("Error saving Countdown data: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = countdownListURL, fileManager.fileExists(atPath: url.path) else {return}
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedCountdowns = try decoder.decode([CountdownCodableValues].self, from: data)
            countdowns = decodedCountdowns
        } catch {
            print("Error loading Countdown data: \(error)")
        }
    }

}
