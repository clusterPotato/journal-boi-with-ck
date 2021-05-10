//
//  Entry.swift
//  CloudJournal
//
//  Created by Gavin Craft on 5/10/21.
//

import Foundation
import CloudKit
struct StringyBois{
    static let bodyID = "bodyBOI"
    static let titleID = "titleBOI"
    static let timeStampID = "timeID"
    static let entryReuseID = "entryBOI"
}


class Entry{
    var title: String
    var body: String
    var recordId: CKRecord.ID
    var timestamp: Date
    init(title: String, body: String, time: Date = Date(), _ id: CKRecord.ID = CKRecord.ID()){
        self.title = title; self.body = body; self.timestamp = time;self.recordId = id
    }
}
extension Entry{
    convenience init?(record: CKRecord){
        guard let body = record[StringyBois.bodyID] as? String,
              let title = record[StringyBois.titleID] as? String,
              let date = record[StringyBois.timeStampID] as? Date else {return nil}
        self.init(title: title, body: body, time: date)
    }
}
extension CKRecord{
    convenience init(_ entry: Entry){
        self.init(recordType: StringyBois.entryReuseID)
        self.setValuesForKeys([
            StringyBois.titleID: entry.title,
            StringyBois.bodyID: entry.body,
            StringyBois.timeStampID: entry.timestamp
        ])
    }
}
