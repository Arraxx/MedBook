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
    @State var showEmailError : Bool = false
    @State var showPasswordError : Bool = false
    @State private var isSecureTextEntry = true
    
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
//                            .onChange(of: emailId){
//                                showEmailError = false
//                                showPasswordError = false
//                            }
                            .onTapGesture {
                                showEmailError = false
                                showPasswordError = false
                            }
                        Divider()
                            .background(.black)
                        HStack{
                            if(showEmailError) {
                                Text("Invalid Email ID.")
                                    .foregroundStyle(.red)
                                    .font(.footnote)
                            }
                            Spacer()
                        }
                    }.padding()
                    VStack{
                        HStack{
                            Group {
                                if isSecureTextEntry {
                                    SecureField("Password", text: $password)
                                } else {
                                    TextField("Password", text: $password)
                                }
                            }
//                            .onChange(of: password){
//                                showEmailError = false
//                                showPasswordError = false
//                            }
                            .textContentType(.password)
                            .onTapGesture {
                                showPasswordError = false
                                showEmailError = false
                            }
                            
                            Button(action: {
                                isSecureTextEntry.toggle()
                            }) {
                                Image(systemName: isSecureTextEntry ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                            .background(.black)
                        HStack {
                            if(showPasswordError) {
                                Text("Invalid Password.")
                                    .foregroundStyle(.red)
                                    .font(.footnote)
                            }
                            Spacer()
                        }
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
                            if coreDataEmail.first(where: { $0.email == emailId }) != nil {
                                print("email present in CD")
                                emailInCD = true }
                            if coreDataPassword.first(where: { $0.password == password }) != nil{
                                print("password present in CD")
                                passwordInCD = true }
                            if(emailInCD && passwordInCD) {
                                isBookViewCalled = true
                                checkLogoutAuth.isLoggedIn = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            } else if(!emailInCD && passwordInCD){
                                emailId = ""
                                password = ""
                                showEmailError = true
                            } else if(emailInCD && !passwordInCD) {
                                password = ""
                                showPasswordError = true
                            } else {
                                emailId = ""
                                password = ""
                                showEmailError = true
                                showPasswordError = true
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
