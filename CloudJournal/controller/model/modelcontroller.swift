//
//  modelcontroller.swift
//  CloudJournal
//
//  Created by Gavin Craft on 5/10/21.
//

import Foundation
import CloudKit
class EntryController{
    //MARK: - standard boilerplate
    static let shared = EntryController()
    let container = CKContainer.default().privateCloudDatabase
    var errorDelegate: ErrorDelegate?
    var entries: [Entry] = []
    //MARK: - crud stuff
    func createEntry(title: String, body: String = "", date: Date = Date()){
        let entry = Entry(title: title, body: body, time: date)
        saveEntry(entry)
        entries.insert(entry, at: 0)
    }
    func fetchAllEntries(completion: @escaping(Int)->Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: StringyBois.entryReuseID, predicate: predicate)
        container.perform(query, inZoneWith: nil) { records, err in
            if let error = err{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                DispatchQueue.main.async {
                    self.errorDelegate?.presentErrorToUser(localizedError: error.localizedDescription)
                }
                return
            }
            guard let records = records else {return}
            self.entries = records.compactMap({Entry(record: $0)})
            print(records.compactMap({Entry(record: $0)}))
            return completion(0)
        }
        
    }
    func saveEntry(_ bigBoyEntry: Entry){
        let record = CKRecord(bigBoyEntry)
        container.save(record) { record, error in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                DispatchQueue.main.async {
                    self.errorDelegate?.presentErrorToUser(localizedError: error.localizedDescription)
                }
            }
            
        }
    }
}
