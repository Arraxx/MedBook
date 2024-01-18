//
//  LoginDataModel.swift
//  MedBook
//
//  Created by Arrax on 18/01/24.
//

import Foundation
import CoreData
import SwiftUI

class AddLoginViewModel: ObservableObject {
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func addCountries(data : [String]) {
        print("added to core data \(data)")
        for countryName in data{
            let newItem = Item(context: viewContext)
            newItem.countryName = countryName
        }
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
    func addEmail(data : String) {
        print("adding email to core data")
        let newLogin = LoginDetails(context: viewContext)
        newLogin.email = data
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
    
    func addPassword(data : String) {
        print("adding password to core data")
        let newLogin = LoginDetails(context: viewContext)
        newLogin.password = data
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription), \(nsError.userInfo)")
        }
    }
}
