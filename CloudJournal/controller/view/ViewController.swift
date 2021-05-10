//
//  ViewController.swift
//  CloudJournal
//
//  Created by Gavin Craft on 5/10/21.
//

import UIKit
class MainViewController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        cell.textLabel?.text = "\(EntryController.shared.entries[indexPath.row].title)"
        let dateformat = DateFormatter()
        dateformat.dateStyle = .short
        cell.detailTextLabel?.text = dateformat.string(from: EntryController.shared.entries[indexPath.row].timestamp)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailVC"){
            guard let destinationVC = segue.destination as? DetailViewController else {return}
            guard let index = tableView.indexPathForSelectedRow else {return}
            destinationVC.entry = EntryController.shared.entries[(index).row]
        }
    }
    func setup(){
        EntryController.shared.fetchAllEntries { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("\(EntryController.shared.entries.count)")
        }
    }
}
class DetailViewController: UIViewController, UITextFieldDelegate {
    //MARK: - iboutlet
    @IBOutlet var saveBTN: UIBarButtonItem!
    @IBOutlet var detailPane: UITextView!
    @IBOutlet var ckearButton: UIButton!
    @IBOutlet var textField: UITextField!
    var entry: Entry?
    
    weak var errDelegate: ErrorDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.addTarget(self,action: #selector(enterPressed), for: .editingDidEndOnExit)
        if let entry = entry{
            setup()
        }
    }
    //MARK: - ibaction
    @IBAction func buttonSave(_ sender: Any) {
        save()
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
        textField.text = ""
        detailPane.text = ""
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
    }
    //MARK: - custom func
    private func save(){
        guard let title = textField.text, !title.isEmpty,
              let body = detailPane.text, !body.isEmpty else{
            self.presentErrorToUser(localizedError: "You didnt put anything in so i have nothing to save")
            return
        }
        EntryController.shared.createEntry(title: title, body: body)
        
        navigationController?.popViewController(animated: true)
    }
    @objc func enterPressed(){
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        save()
    }
    func setup(){
        guard let entry = entry else {return}
        textField.text = entry.title
        detailPane.text = entry.body
        saveBTN.isEnabled = false
        textField.allowsEditingTextAttributes = false
        detailPane.isEditable = false
        ckearButton.isEnabled = false
    }
}

