//
//  BooksView.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var checkLogoutAuth : ToLogoutAuth
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var booksModel : FetchBooksData = FetchBooksData()
    @State var showSort : Bool = false
    @State var searchContext : String = ""
    @State var initialVal : Int = 10
    @State var sortButton : sortType = sortType.Average
    @State private var reachedEnd : Bool = false
    @State private var isLoading : Bool = false
    @State private var isLoadingBooks : Bool = false
    @State var booksArray : Books = Books(docs: [])
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing: 10){
                    VStack(spacing : 30){
                        HStack(spacing: 100){
                            HStack{
                                Text(Image(systemName: "book.fill"))
                                    .font(.title)
                                Text("MedBook")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .padding(.leading, 10)
                            HStack{
                                NavigationLink(destination: BookmarkView()
                                    .environment(\.managedObjectContext, viewContext)){
                                        Text(Image(systemName: "bookmark.fill"))
                                            .font(.title)
                                            .foregroundColor(.black)
                                    }
                                    .padding(.trailing, 10)
                                
                                Button(action: {
                                    checkLogoutAuth.isLoggedIn = false
                                    print("Back to landing Page")
                                }){
                                    Text(Image(systemName: "delete.left"))
                                        .font(.title)
                                        .foregroundColor(.red)
                                    
                                }
                            }
                            .padding(.trailing, 10)
                            
                        }
                        .padding(.top, 30)
                        
                        HStack{
                            Text("Which topic interest you today?")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.gray)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        
                        TextField("Enter Book...", text: $searchContext)
                            .padding()
                            .frame(width: 350, height: 30)
                            .background(Color.white)
                            .clipShape(.buttonBorder)
                            .overlay(
                                Button(action :{
                                    searchContext = ""
                                    booksModel.cellData.docs = []
                                }){
                                    Image(systemName: "multiply")
                                        .padding(.leading,300)
                                        .foregroundColor(Color.gray)
                                }
                            )
                            .onChange(of : searchContext) { newValue in
                                if newValue.count >= 3 {
                                    isLoadingBooks = true
                                    booksModel.fetchBookData(title: newValue){_ in
                                        isLoadingBooks = false
                                    }
                                    
                                } else {
                                    initialVal = 10
                                    booksModel.limit = 10
                                    booksModel.offset = 0
                                    booksModel.cellData.docs = []
                                    isLoading = false
                                    isLoadingBooks = false
                                }
                            }
                    }
                    Spacer()
                    
                    VStack(spacing : 20){
                        if(!booksModel.cellData.docs.isEmpty){
                            HStack(spacing : 40){
                                Text("Sort by: ")
                                    .font(.subheadline)
                                HStack(spacing: 30){
                                    Button(action : { sortButton = sortType.Title }){
                                        Text("Title")
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                            .foregroundStyle(Color.black)
                                    }
                                    Button(action : { sortButton = sortType.Average }){
                                        Text("Average")
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                            .foregroundStyle(Color.black)
                                    }
                                    Button(action : { sortButton = sortType.Hits }){
                                        Text("Hits")
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                            .foregroundStyle(Color.black)
                                    }
                                }
                                Spacer()
                            }
                            .padding([.leading,.trailing], 20)
                            
                            VStack(spacing : 20) {
                                let sortedBooks = booksModel.cellData.docs.sorted { (book1, book2) -> Bool in
                                    if sortButton == sortType.Title {
                                        return book1.title ?? "" < book2.title ?? ""
                                    } else if sortButton == sortType.Hits {
                                        return book1.ratings_count ?? 0 > book2.ratings_count ?? 0
                                    } else {
                                        return book1.ratings_average ?? 0 > book2.ratings_average ?? 0
                                    }
                                }
                                ScrollView {
                                    ScrollViewReader { scrollViewProxy in
                                        LazyVStack {
                                            ForEach(sortedBooks, id: \.self) { bookData in
                                                let imageAPI = "https://covers.openlibrary.org/b/id/\(String( bookData.cover_i))-M.jpg"
                                                
                                                CellView(title: bookData.title ?? "", imageURL: imageAPI , author: bookData.author_name?[0] ?? "", ratings: String(bookData.ratings_count ?? 0), notes: String(format: "%.2f", bookData.ratings_average ?? 0), isBookmarked: false)
                                                    .environment(\.managedObjectContext, viewContext)
                                                    .id(bookData)
                                                    .onAppear {
                                                        // Check if this is the last item in scrollview
                                                        if bookData == sortedBooks.last {
                                                            isLoading = true
                                                            booksModel.fetchMoreResults(title: searchContext) {
                                                                isLoading = false
                                                            }
                                                        }
                                                    }
                                            }
                                            Spacer(minLength: 10)
                                        }
                                        .onReceive(booksModel.$cellData) { _ in
                                            DispatchQueue.main.async {
                                                scrollViewProxy.scrollTo(sortedBooks.first, anchor: .bottom)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if isLoadingBooks {
                            ProgressView()
                                .padding(.bottom, 350)
                        }
                        if isLoading{
                            ProgressView()
                        }
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgColor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

enum sortType {
    case Title
    case Average
    case Hits
}

#Preview {
    BooksView()
}
