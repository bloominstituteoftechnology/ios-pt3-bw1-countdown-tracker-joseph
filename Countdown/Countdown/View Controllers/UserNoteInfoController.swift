//
//  UserNoteInfoController.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/28/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation

class CountdownController {
    private(set) var countdownInfo: [CountdownCodableInfo] = []
    private var userInfoListURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return documents.appendingPathComponent("userinfo.plist")
    }
    
    init() {
        loadFromPersistentStore()
    }
    
    
    //MARK: CRUD methods

    @discardableResult func addUserNotes(name: String, countdownExistingNotes: String) -> CountdownCodableInfo? {
        let name = name.trimmingCharacters(in: .whitespaces)
        for info in countdownInfo {
            if info.name == name{
                return nil
            }
        }
        let newUserInfo = CountdownCodableInfo(name: name, countdownExistingNotes: countdownExistingNotes)
        countdownInfo.append(newUserInfo)
        saveToPersistentStore()
        return newUserInfo
    }
    
    @discardableResult func updateInfo(for userInfo: CountdownCodableInfo) -> CountdownCodableInfo {
        guard let i = countdownInfo.firstIndex(of: userInfo) else { return userInfo }
         saveToPersistentStore()
         return countdownInfo[i]
     }
    
    func deleteInfo(_ info: CountdownCodableInfo) {
//        guard let i = books.firstIndex(of: book) else { return }
//        books.remove(at: i)
        guard let i = countdownInfo.firstIndex(of: info) else {return}
        countdownInfo.remove(at: i)
        saveToPersistentStore()
    }
     
    
    private func saveToPersistentStore() {
        guard let url = userInfoListURL else {return}
        
        do {
            let encoder = PropertyListEncoder()
            let userData = try encoder.encode(countdownInfo)
            try userData.write(to: url)
        }catch {
            print("Error saving User Info: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
          let fileManager = FileManager.default
             guard let url = userInfoListURL, fileManager.fileExists(atPath: url.path) else { return }
             
             do {
                 let data = try Data(contentsOf: url)
                 let decoder = PropertyListDecoder()
                 let decodedInfo = try decoder.decode([CountdownCodableInfo].self, from: data)
                 countdownInfo = decodedInfo
             } catch {
                 print("Error loading User data: \(error)")
             }
    }
}
