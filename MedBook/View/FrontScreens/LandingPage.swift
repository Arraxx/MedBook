//
//  LandingPage.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI

struct LandingPage: View {
    @EnvironmentObject var checkLogoutAuth : ToLogoutAuth
    @Binding var isLoggedIn: Bool
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Text("MedBook")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    Image(.github)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    HStack(spacing: 120){
                        NavigationLink(destination: SignUpPage(isLoggedIn: $isLoggedIn)
                            .environment(\.managedObjectContext, viewContext)
                            .environmentObject(checkLogoutAuth)){
                            Text("Signup")
                                .foregroundStyle(.black)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 150, height: 50))
                        }
                        NavigationLink(destination: LogInPage(isLoggedIn: $isLoggedIn)
                            .environment(\.managedObjectContext, viewContext)
                            .environmentObject(checkLogoutAuth)){
                            Text("Login")
                                .foregroundStyle(.black)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 150, height: 50))
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth : .infinity, maxHeight : .infinity)
            .background(Color.bgColor)
        }
    }
}

//#Preview {
//    LandingPage()
//}
