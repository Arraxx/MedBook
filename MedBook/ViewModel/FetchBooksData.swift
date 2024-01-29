//
//  FetchBooksData.swift
//  MedicareApp
//
//  Created by Arrax on 17/01/24.
//

import Foundation
import Combine

class FetchBooksData: ObservableObject {
    @Published var cellData: Books = Books(docs: [])

    var limit: Int = 10
    var offset: Int = 0
    var cancellables: Set<AnyCancellable> = Set()

    func fetchBookData(title: String, completion: @escaping (Books) -> Void) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let api: String = "https://openlibrary.org/search.json?title=" + title + "&limit=" + String(limit)
        print(api)
        guard let url = URL(string: api) else { return }

        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Books.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
            }, receiveValue: { decodedData in
                completion(decodedData)
                print(decodedData.docs.dropFirst(self.offset))
                    DispatchQueue.main.async {
                        self.cellData.docs.append(contentsOf: decodedData.docs.dropFirst(self.offset))
                    }
            })

        dataTaskPublisher.store(in: &cancellables)
    }

    // Function to fetch more results by incrementing the offset and limit
    func fetchMoreResults(title: String, completion: @escaping () -> Void) {
        offset = limit
        limit += 10
        fetchBookData(title: title) { _ in
                    completion()
            }
    }
}

