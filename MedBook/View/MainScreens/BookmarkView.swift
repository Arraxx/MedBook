//
//  BookmarkView.swift
//  MedBook
//
//  Created by Arrax on 18/01/24.
//

import SwiftUI

struct BookmarkView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \CellData.title, ascending: true)],
            animation: .default) var coreDataCellData: FetchedResults<CellData>

    var body: some View {
        ZStack{
            VStack(spacing: 20){
                HStack{
                    Text("Bookmarks")
                        .foregroundStyle(Color.black)
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    Spacer()
                }
                    
                Spacer()
                VStack(spacing : 20){
                    ScrollView{
                        ForEach(coreDataCellData, id: \.self) { cellData in
                            CellView(title: cellData.title ?? "", imageURL: cellData.imageUrl ?? "", author: cellData.author ?? "", ratings: cellData.ratings ?? "", notes: cellData.notes ?? "", isBookmarked : true)
                        }
                    }
                }
            }
            
        } .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
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

#Preview {
    BookmarkView()
}
