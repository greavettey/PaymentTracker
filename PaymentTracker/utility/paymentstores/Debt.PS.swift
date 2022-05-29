//
//  Debt.PS.swift
//  PaymentTracker
//
//  Created by Axel Greavette on 2022-05-28.
//

import Foundation

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
