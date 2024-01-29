//
//  CellView.swift
//  MedicareApp
//
//  Created by Arrax on 16/01/24.
//

import SwiftUI
import CoreData

struct CellView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CellData.title, ascending: true)],
        animation: .default) var coreDataCellData: FetchedResults<CellData>
    @State var title: String
    @State var imageURL: String
    @State var author: String
    @State var ratings: String
    @State var notes: String
    @State var isBookmarked: Bool
    @State private var isPresentInCoreData = false
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 350, height: 80)
            .foregroundStyle(Color.white)
            .overlay(
                HStack {
                    ImageView(imageUrl: self.imageURL)
                    VStack {
                        HStack {
                            Text(title)
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            Text(author)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 1)
                            HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                    .font(.footnote)
                                    .foregroundColor(.yellow)
                                Text(ratings)
                                    .font(.footnote)
                            }
                            HStack(spacing: 5) {
                                Image(systemName: "note.text")
                                    .font(.footnote)
                                    .foregroundColor(.yellow)
                                Text(notes)
                                    .font(.footnote)
                            }
                        }
                    }
                    
                    Button(action: {
                        isBookmarked.toggle()
                    }) {
                        Text(Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark"))
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding()
                    }
                    .onChange(of: isBookmarked) { newValue in
                        if newValue{
                            if !isPresentInCoreData{
                                AddFilesViewModel(viewContext: viewContext).addCellDataInCoreData(title: self.title, imageURL: self.imageURL, author: self.author, ratings: self.ratings, notes: self.notes)
                            }
                        }
                        else{
                                AddFilesViewModel(viewContext: viewContext).deleteCellDataFromCoreData(title: self.title, imageURL: self.imageURL, author: self.author, ratings: self.ratings, notes: self.notes)
                        }
                    }
                }
            )
            .task {
                let titleToCheck = self.title
                let fetchRequest: NSFetchRequest<CellData> = CellData.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@", titleToCheck)
                
                do {
                    let results = try viewContext.fetch(fetchRequest)
                    
                    if !results.isEmpty {
                        // Title is present in Core Data
                        self.isBookmarked = true
                        self.isPresentInCoreData = true
                    }
                } catch {
                    print("Error fetching cell data: \(error.localizedDescription)")
                }
            }
    }
}

struct ImageView: View {
    @State private var downloadedImage: UIImage? = nil
    
    let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
        downloadImage()
    }
    
    var body: some View {
        Group {
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.leading, 5)
            } else {
                ProgressView()
                    .frame(width: 70, height: 70)
                    .padding(.leading, 5)
            }
        } .onAppear {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    downloadedImage = image
                }
            }
        }.resume()
    }
}

#Preview {
    CellView(title: "The Player of Games", imageURL: "https://covers.openlibrary.org/b/id/8561531-M.jpg", author: "Ayush Jha", ratings: "4.47", notes: "89", isBookmarked: false)
}
