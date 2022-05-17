//
//  PaymentStore.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-02-06.
//

import Foundation
import SwiftUI

class DebtPaymentStore: ObservableObject {
    @Published var debts: [DebtPaymentEntry] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("debts.data")
    }
    
    static func load(completion: @escaping (Result<[DebtPaymentEntry], Error>) -> Void ) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let debts = try JSONDecoder().decode([DebtPaymentEntry].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(debts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(debts: [DebtPaymentEntry], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(debts)
                let outfile = try fileURL()
                try data.write(to: outfile)
                
                DispatchQueue.main.async {
                    completion(.success(debts.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}


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
