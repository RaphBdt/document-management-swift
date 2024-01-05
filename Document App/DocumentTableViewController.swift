//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Raphaël Beaudet on 06/12/2023.
//

import UIKit
import Foundation
extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: Int64(self))
    }
}

class DocumentTableViewController: UITableViewController {
    
    var pictures = [String]()

    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
        
        static var filesData = [DocumentFile]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                    if item.hasPrefix("cat") {
                        let url = URL(fileURLWithPath: path + "/" + item)
                        let resourceValues = try url.resourceValues(forKeys: [.typeIdentifierKey, .nameKey, .fileSizeKey])

                        // Create a new DocumentFile instance
                        let documentFile = DocumentFile(
                            title: resourceValues.name ?? item,
                            size: resourceValues.fileSize ?? 0,
                            imageName: nil,
                            url: url,
                            type: resourceValues.typeIdentifier ?? "unknown"
                        )

                        // Append the new instance to filesData
                        DocumentFile.filesData.append(documentFile)

                        // Append the item to the pictures array
                        pictures.append(item)
                    }
                }
        } catch {
            print("Error: \(error)")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        // print(pictures)
    }

    // MARK: - Table view data source

    // Indique au Controller combien de sections il doit afficher
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DocumentFile.filesData.count
    }
    
    // Indique au Controller comment remplir la cellule avec les données
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        cell.textLabel?.text = DocumentFile.filesData[indexPath.row].title
        cell.detailTextLabel?.text = String(DocumentFile.filesData[indexPath.row].size.formattedSize())
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Récuperer l'index de la ligne sélectionnée
        // 2. Récuperer le document correspondant à l'index
        // 3. Cibler l'instance de DocumentViewController via le segue.destination
        // 4. Caster le segue.destination en DocumentViewController
        // 5. Remplir la variable imageName de l'instance de DocumentViewController avec le nom de l'image du document
        
        if segue.identifier == "ShowDocumentSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let selectedDocument = DocumentFile.filesData[indexPath.row]
                
                if let documentViewController = segue.destination as? DocumentViewController {
                    documentViewController.imageName = selectedDocument.title
                }
            }
        }
    }
}
