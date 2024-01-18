//
//  LogInPage.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI

struct LogInPage: View {
    @EnvironmentObject var checkLogoutAuth : ToLogoutAuth
    @Binding var isLoggedIn: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var emailId : String = ""
    @State var password : String = ""
    @State var isBookViewCalled : Bool = false
    @State var emailInCD : Bool = false
    @State var passwordInCD : Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LoginDetails.email, ascending: true)],
        animation: .default) var coreDataEmail: FetchedResults<LoginDetails>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \LoginDetails.password, ascending: true)],
        animation: .default) var coreDataPassword: FetchedResults<LoginDetails>
    var body: some View {
        ZStack{
            VStack{
                VStack(spacing : 10){
                    HStack{
                        Text("Welcome")
                            .padding(.leading, 15)
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                    HStack{
                        Text("log in to continue")
                            .padding(.leading, 15)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                }
                .padding()
                VStack{
                    VStack{
                        TextField("Email", text: $emailId)
                            .autocorrectionDisabled(true)
                        Divider()
                            .background(.black)
                    }.padding()
                    VStack{
                        SecureField("Password", text: $password)
                            .autocorrectionDisabled(true)
                        Divider()
                            .background(.black)
                    }.padding()
                }
                .padding()
                .padding(.top, 30)
                
                
                Spacer()
                
                NavigationLink(destination: BooksView()
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(checkLogoutAuth), isActive: $isBookViewCalled, label: {
                    Button(action: {
                        print("Logging In")
                        if let emailDetail = coreDataEmail.first(where: { $0.email == emailId }) {
                            print("email present in CD")
                            emailInCD = true }
                        if let passDetail = coreDataPassword.first(where: { $0.password == password }){
                            print("password present in CD")
                            passwordInCD = true }
                        if(emailInCD && passwordInCD) {
                            isBookViewCalled = true
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        } else {
                            emailId = ""
                            password = ""
                        }
                    }){
                        Text("Login")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(Image(systemName: "arrow.right"))
                            .foregroundStyle(.black)
                    }.overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 150, height: 50))
                    .padding(.bottom, 20)
                    
                })
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
        .background(Color.bgColor)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }
}

//#Preview {
//    LogInPage()
//}
