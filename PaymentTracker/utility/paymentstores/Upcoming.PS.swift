//
//  Upcoming.PS.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import Foundation

class UpcomingPaymentStore: ObservableObject {
    @Published var upcomings: [UpcomingPaymentEntry] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("upcomings.data")
    }
    
    static func load(completion: @escaping (Result<[UpcomingPaymentEntry], Error>) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let upcomings = try JSONDecoder().decode([UpcomingPaymentEntry].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(upcomings))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(upcomings: [UpcomingPaymentEntry], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(upcomings)
                let outfile = try fileURL()
                try data.write(to: outfile)
                
                DispatchQueue.main.async {
                    completion(.success(upcomings.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
