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
    //    @StateObject var countriesUserData = CountriesDataModel()
    @ObservedObject var countries : countryDataFetch = countryDataFetch()
    @ObservedObject var currentCountry : countryDataFetch = countryDataFetch()
    @State var isBookViewCalled : Bool = false
    @State var showAlert : Bool = false
    @State private var countryArray : [String] = []
    @State private var selectedCountry : String = ""
    @State var emailId : String = ""
    @State var password : String = ""
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
                    
                    VStack(spacing : 30){
                        HStack{
                            Image(systemName: "square")
                            Text("At least 8 characters")
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "square")
                            Text("At least 1 Uppercase Character ")
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "square")
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
                        .environment(\.managedObjectContext, viewContext), isActive: $isBookViewCalled, label: {
                        Button(action: {
                            checkLogoutAuth.isLoggedIn = true
                            print("Going to Books Page")
                            if(VerificationForSignUp(email: emailId, password: password)){
                                AddLoginViewModel(viewContext: viewContext).addEmail(data: emailId)
                                AddLoginViewModel(viewContext: viewContext).addPassword(data: password)
                                isBookViewCalled = true
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            } else {
                                print("Incorrect Email/Password")
                                emailId = ""
                                password = ""
                                showAlert = true
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
                        .alert(isPresented: $showAlert){
                            Alert(title: Text("Invalid Credentials"),
                                  dismissButton: .default(Text("Dismiss"), action: {
                                showAlert = false
                            })
                            )
                        }
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
