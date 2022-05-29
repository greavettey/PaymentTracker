//
//  Wishlist.PS.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import Foundation

class WishlistStore: ObservableObject {
    @Published var wishes: [WishlistEntry] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("wishlist.data")
    }
    
    static func load(completion: @escaping (Result<[WishlistEntry], Error>) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let wishes = try JSONDecoder().decode([WishlistEntry].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(wishes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(wishes: [WishlistEntry], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(wishes)
                let outfile = try fileURL()
                try data.write(to: outfile)
                
                DispatchQueue.main.async {
                    completion(.success(wishes.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
