//
//  ViewController.swift
//  TestMigrateCoreData
//
//  Created by Thạnh Dương Hoàng on 17/11/25.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private var notes: [NoteKaka] = []

    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Notes"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 70
        
        fetchNotes()
    }
    
    private func fetchNotes() {
        let request: NSFetchRequest<NoteKaka> = NoteKaka.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            notes = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Lỗi khi fetch notes: \(error.localizedDescription)")
        }
    }
    
    private func saveNote(string: String, address: String) {
        let newNote = NoteKaka(context: context)
        newNote.id = UUID()
        newNote.name = string
        newNote.address = address
        saveContext()
        fetchNotes()
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        guard let text = textField.text, !text.isEmpty else {
            print("Text field is empty.")
            return
        }
        
        guard let address = adressTF.text, !address.isEmpty else {
            print("Address field is empty.")
            return
        }
        
        saveNote(string: text, address: address)
    }
    

}

// MARK: - Swipe action table view to delete
extension ViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let noteToDelete = self.notes[indexPath.row]
            self.context.delete(noteToDelete)
            self.saveContext()
            self.fetchNotes()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableView DataSource & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = (note.name ?? "NO NAME") + " - " + (note.address ?? "NO ADDRESS")
        return cell
    }
}


// MARK: - Core Data Helper Extension
extension ViewController {
    // Thuộc tính tính toán để truy cập View Context
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is missing or invalid.")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // Hàm gọi saveContext từ AppDelegate
    func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
    }
}


