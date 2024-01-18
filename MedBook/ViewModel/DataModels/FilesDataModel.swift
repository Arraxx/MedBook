//
//  FilesDataModel.swift
//  MedBook
//
//  Created by Arrax on 18/01/24.
//

import Foundation
import CoreData
import SwiftUI

class AddFilesViewModel: ObservableObject {
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func addCellDataInCoreData(title : String, imageURL : String, author : String, ratings : String, notes : String){
        print("adding cell data in core data")
        let coreData = CellData(context : viewContext)
        coreData.title = title
        coreData.imageUrl = imageURL
        coreData.author = author
        coreData.ratings = ratings
        coreData.notes = notes
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
    
    func deleteCellDataFromCoreData(title: String, imageURL: String, author: String, ratings: String, notes: String) {
        let fetchRequest: NSFetchRequest<CellData> = CellData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND imageUrl == %@ AND author == %@ AND ratings == %@ AND notes == %@", title, imageURL, author, ratings, notes)

        do {
            let matchingCellData = try viewContext.fetch(fetchRequest)

            for cellDataObject in matchingCellData {
                viewContext.delete(cellDataObject)
            }

            try viewContext.save()
            print("Deleted from core data")
        } catch {
            let nsError = error as NSError
            fatalError("Error deleting cell data: \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
}
