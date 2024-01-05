//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Raphaël Beaudet on 06/12/2023.
//

import UIKit
import Foundation
import QuickLook
import MobileCoreServices
extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        return formatter.string(fromByteCount: Int64(self))
    }
}

class DocumentTableViewController: UITableViewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource, UIDocumentPickerDelegate {

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
        
        // Bouton "Ajouter" à la barre de navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
                
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
                            imageName: item,
                            url: url,
                            type: resourceValues.typeIdentifier ?? "unknown"
                        )

                        // Append the new instance to filesData
                        DocumentFile.filesData.append(documentFile)
                    }
                }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Fonction cible du bouton "Ajouter"
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeData as String], in: .open)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true)

        guard url.startAccessingSecurityScopedResource() else {
            return
        }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        loadFileFromAppDirectory(url: url)
    }
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let originalFileName = url.lastPathComponent
        let fileExtension = url.pathExtension
        let fileNameWithoutExtension = URL(fileURLWithPath: originalFileName).deletingPathExtension().lastPathComponent

        var destinationUrl = documentsDirectory.appendingPathComponent(fileNameWithoutExtension)
        var count = 1

        // Generate a new file name if the file already exists
        while FileManager.default.fileExists(atPath: destinationUrl.path) {
            destinationUrl = documentsDirectory.appendingPathComponent("\(fileNameWithoutExtension)_\(count).\(fileExtension)")
            count += 1
        }

        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)

            // If needed, you can perform additional actions after a successful copy here.
            print("File copied successfully to: \(destinationUrl.lastPathComponent)")
        } catch let error as NSError {
            // Handle the error appropriately
            print("Error copying file: \(error.localizedDescription)")
            if let localizedFailureReason = error.localizedFailureReason {
                print("Localized Failure Reason: \(localizedFailureReason)")
            }
        }
    }
    
    func loadFileFromAppDirectory(url: URL) {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.typeIdentifierKey, .nameKey, .fileSizeKey])

            // Create a new DocumentFile instance
            let documentFile = DocumentFile(
                title: resourceValues.name ?? url.lastPathComponent,
                size: resourceValues.fileSize ?? 0,
                imageName: nil,  // Vous pouvez mettre à jour ceci en fonction du type de fichier
                url: url,
                type: resourceValues.typeIdentifier ?? "unknown"
            )

            // Ajouter le nouveau fichier à filesData
            DocumentFile.filesData.append(documentFile)

            // Mettre à jour la table view
            tableView.reloadData()
        } catch {
            print("Error: \(error)")
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = DocumentFile.filesData[indexPath.row]
        instantiateQLPreviewController(withUrl: file.url, imageName: file.imageName)
    }
    
    // Indique au Controller comment remplir la cellule avec les données
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        cell.textLabel?.text = DocumentFile.filesData[indexPath.row].title
        cell.detailTextLabel?.text = String(DocumentFile.filesData[indexPath.row].size.formattedSize())
        
        return cell
    }
    
    func instantiateQLPreviewController(withUrl url: URL, imageName: String?) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        
        // Transférer le nom de l'image directement à la classe QLPreviewControllerDataSource
        previewController.currentPreviewItemIndex = DocumentFile.filesData.firstIndex { $0.url == url } ?? 0
        
        // Présenter le QLPreviewController à l'aide du navigationController
        if let navigationController = self.navigationController {
            navigationController.pushViewController(previewController, animated: true)
        }
    }
    
    // MARK: - QLPreviewControllerDataSource

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return DocumentFile.filesData.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        // Retourner l'URL du document à prévisualiser
        return DocumentFile.filesData[index].url as QLPreviewItem
    }
}
