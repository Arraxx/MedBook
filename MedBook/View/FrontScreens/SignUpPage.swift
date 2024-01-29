//
//  SignInPage.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI
import Foundation

struct SignUpPage: View {
    
    @EnvironmentObject var checkLogoutAuth : ToLogoutAuth
    @Binding var isLoggedIn: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var countries : countryDataFetch = countryDataFetch()
    @ObservedObject var currentCountry : countryDataFetch = countryDataFetch()
    @State var isBookViewCalled : Bool = false
    @State var showAlert : Bool = false
    @State private var countryArray : [String] = []
    @State private var selectedCountry : String = ""
    @State var emailId : String = ""
    @State var password : String = ""
    @State private var isSecureTextEntry = true
    @State private var showPasswordError = false
    @State private var showEmailError = false
    // password check
    @State var checkForSize : Bool = false
    @State var checkForCapital : Bool = false
    @State var checkForSpecialChar : Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.countryName, ascending: true)],
        animation: .default) var coreDataCountries: FetchedResults<Item>
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    VStack(spacing : 10){
                        HStack{
                            Text("Welcome")
                                .padding(.leading, 15)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        HStack{
                            Text("sign up to continue")
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
//                                .onChange(of: emailId){
//                                    showEmailError = false
//                                    showPasswordError = false
//                                }
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
                                            .textContentType(.password)
                                    } else {
                                        TextField("Password", text: $password)
                                            .textContentType(.password)
                                    }
                                }
                                .onChange(of: password) { value in
//                                    showEmailError = false
//                                    showPasswordError = false
                                    checkForCapital = value.contains {$0.isUppercase}
                                    if(value.count >= 8) { checkForSize = true } else { checkForSize = false }
                                    checkForSpecialChar = value.contains { !($0.isLetter || $0.isNumber) }
                                }
                                .onTapGesture {
                                    showEmailError = false
                                    showPasswordError = false
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
                            HStack{
                                if(showPasswordError) {
                                    Text("Invalid password.")
                                        .foregroundStyle(.red)
                                        .font(.footnote)
                                }
                                Spacer()
                            }
                        }.padding()
                    }
                    .padding()
                    
                    VStack(spacing : 30){
                        HStack{
                            Image(systemName: checkForSize ? "square.fill" : "square")
                            Text("At least 8 characters")
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: checkForCapital ? "square.fill" : "square")
                            Text("At least 1 Uppercase Character ")
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: checkForSpecialChar ? "square.fill" : "square")
                            Text("At least 1 Special Character")
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                    }
                    .padding(.leading, 30)
                    
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(countryArray, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Spacer()
                    
                    NavigationLink(destination: BooksView()
                        .environment(\.managedObjectContext, viewContext)
                        .environmentObject(checkLogoutAuth), isActive: $isBookViewCalled, label: {
                        Button(action: {
                            checkLogoutAuth.isLoggedIn = true
                            print("Going to Books Page")
                            if(VerificationForSignUp(email: emailId, password: password)){
                                AddLoginViewModel(viewContext: viewContext).addEmail(data: emailId)
                                AddLoginViewModel(viewContext: viewContext).addPassword(data: password)
                                isBookViewCalled = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            } else {
                                showEmailError = true
                                showPasswordError = true
                                print("Incorrect Email/Password")
                                emailId = ""
                                password = ""
                            }
                        }){
                            Text("Let's Go")
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
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.bgColor)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .task {
                if(coreDataCountries.isEmpty){
                    countries.getCountries { countryArray in
                        //                        print("countries data \(countryArray)")
                        self.countryArray = countryArray
                        self.countryArray.sort()
                        AddLoginViewModel(viewContext: viewContext).addCountries(data: countryArray)
                    }
                    print("Adding to core data - countries val")
                } else {
                    self.countryArray = coreDataCountries.compactMap({$0.countryName})
                    print("Already present in core data")
                }
                currentCountry.getCurrentCountry { currentCountry in
                    self.selectedCountry = currentCountry.country ?? "India"
                }
            }
        }
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
//    SignUpPage()
//}
