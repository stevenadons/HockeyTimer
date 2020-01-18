//
//  Store.swift
//  Discounter
//
//  Created by Steven Adons on 16/03/2019.
//  Copyright © 2019 StevenAdons. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void


class Store: NSObject  {
    
    
    // MARK: - Properties
    
    private (set) var appStoreCountry: String?
    
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var request: SKProductsRequest?
    private var requestCompletionHandler: ProductsRequestCompletionHandler?
    
    
    // MARK: - Life Cycle
    
    init(productIdentifiers: Set<ProductIdentifier>) {
        
        self.productIdentifiers = productIdentifiers
        
        for productIdentifier in productIdentifiers {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}


// MARK: - StoreKit API

extension Store {
    
    // MARK: - Public Methods
    
    func requestProducts(then completionHandler: @escaping ProductsRequestCompletionHandler) {
        
        request?.cancel()
        requestCompletionHandler = completionHandler
        
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request!.delegate = self
        request!.start()
    }
    
    func buy(_ product: SKProduct) {
        
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    func restorePurchases() {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - Class Methods
    
    class func canMakePayments() -> Bool {
        
        return SKPaymentQueue.canMakePayments()
    }
}


// MARK: - SKProductsRequestDelegate

extension Store: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Loaded list of products...")
        
        let products = response.products
        requestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
        
        // Set appStoreCountry
        guard !products.isEmpty else { return }
        let appStoreLocale = products[0].priceLocale
        if let regionCode = appStoreLocale.regionCode {
            appStoreCountry = (appStoreLocale as NSLocale).displayName(forKey: .countryCode, value: regionCode)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        
        requestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        
        request = nil
        requestCompletionHandler = nil
    }
}


// MARK: - SKPaymentTransactionObserver

extension Store: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
        print("complete...")
        
        handlePurchase(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        
        handlePurchase(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        
        print("fail...")
        
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        NotificationCenter.default.post(name: .TransactionEndedNotification, object: nil)
    }
    
    private func handlePurchase(identifier: String?) {
        
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.PremiumMode)
        
        NotificationCenter.default.post(name: .PurchaseNotification, object: identifier)
        NotificationCenter.default.post(name: .TransactionEndedNotification, object: nil)
    }
}

