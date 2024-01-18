//
//  ContentView.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @StateObject private var toLogoutAuth = ToLogoutAuth()
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        if isLoggedIn && toLogoutAuth.isLoggedIn{
            BooksView()
                .environmentObject(toLogoutAuth)
        }
        else {
            LandingPage(isLoggedIn: $isLoggedIn)
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(toLogoutAuth)
        }

    }
    
}

#Preview {
    ContentView()
}
