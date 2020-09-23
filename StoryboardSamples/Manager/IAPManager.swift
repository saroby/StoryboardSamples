//
//  IAPHelper.swift
//  Vaults
//
//  Created by 신희욱 on 2020/09/22.
//
// 주의: 법인 개발자만 유료결제가 가능하다. 개인 개발자 개정에서는 SKProductsRequest결과가 항상 empty이다.

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ products: [SKProduct]?, _ error: Error?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPManager: NSObject  {
    
    public static let shared = IAPManager()
    
    private var isSetuped = false
    private var productIdentifiers: Set<ProductIdentifier> = []
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var serverProducts: [ProductIdentifier:SKProduct] = [:]
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

    public override init() {
        super.init()
        
        // SKPaymentTransactionObserver 등록
        SKPaymentQueue.default().add(self)
    }
    
    public func setup(productIds: Set<ProductIdentifier>, completion: ((Error?)->Void)? = nil) {
        productIdentifiers = productIds

        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)

            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        
        requestProducts { (products, error) in
            self.isSetuped = true
            completion?(error)
        }
    }
}

extension IAPManager {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ productIdentifier: ProductIdentifier) {
        guard isSetuped else { return }
        guard let product = serverProducts[productIdentifier] else { return }
        
        self.buyProduct(product)
    }
    
    public func buyProduct(_ product: SKProduct) {
        guard isSetuped else { return }
        
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        
        serverProducts.removeAll()
        for product in response.products {
            serverProducts[product.productIdentifier] = product
        }
        
        productsRequestCompletionHandler?(response.products, nil)
        clearRequestAndHandler()
    }
    
//    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Failed to load list of products.")
//        print("Error: \(error.localizedDescription)")
//        productsRequestCompletionHandler?(nil, error)
//        clearRequestAndHandler()
//    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
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
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
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
    }
    
    private func deliverPurchaseNotificationFor(identifier: String) {
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}
