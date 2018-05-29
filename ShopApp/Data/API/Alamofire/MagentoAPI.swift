//
//  MagentoAPI.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Alamofire
import ShopApp_Gateway

public class MagentoAPI: BaseAPI, API {
    private let defaultBaseUrl = "rest/V1/"
    private let defaultPaginationValue = 1
    private let createdAtField = "created_at"
    private let attributeSetIdField = "attribute_set_id"
    private let nameField = "name"
    private let searchValueFormat = "%%%@%%"
    private let typeIdField = "type_id"
    private let simpleValue = "simple"
    private let skuField = "sku"
    private let parentCategoryId = "rootCategoryId"
    private let categoryIdField = "category_id"
    private let priceField = "price"
    private let unauthorizedStatusCode = 401
    private let sessionService = SessionService()
    
    /**
     Initializer for Magento API.
     
     - Parameter shopDomain: Domain of shop
     */
    public init(shopDomain: String) {
        BaseRouter.hostUrl = shopDomain
        BaseRouter.baseUrl = defaultBaseUrl
        
        super.init()
    }
    
    // MARK: - Shop info
    
    public func getShopInfo(callback: @escaping RepoCallback<Shop>) {
        // There is no api to fetch terms
        callback(nil, nil)
    }
    
    // MARK: - Products
    
    public func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, keyPhrase: String?, excludePhrase: String?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {
        guard let sortBy = sortBy, sortBy.rawValue != SortingValue.popular.rawValue else {
            callback([], nil)
            
            return
        }
        
        var currentPaginationValue = defaultPaginationValue
        let builder = ProductsParametersBuilder()
        
        if sortBy.rawValue == SortingValue.createdAt.rawValue {
            _ = builder.addSortOrderParameters(field: createdAtField, isRevers: reverse)
        } else if sortBy.rawValue == SortingValue.type.rawValue, let keyPhrase = keyPhrase {
            let attributeSetIdPair = (attributeSetIdField, keyPhrase)
            _ = builder.addFilterParameters(pair: attributeSetIdPair)
            
            if let excludePhrase = excludePhrase {
                let namePair = (nameField, excludePhrase)
                _ = builder.addFilterParameters(pair: namePair, condition: .notEqual)
            }
        }

        if let paginationValue = paginationValue as? String, let castedPaginationValue = Int(paginationValue) {
            currentPaginationValue = castedPaginationValue
        }
        
        getProductList(perPage: perPage, paginationValue: currentPaginationValue, builder: builder, callback: callback)
    }
    
    public func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let route = MagentoProductsRoute.getProduct(sku: id)
            let request = MagentoProductsRouter(route: route)
            
            strongSelf.execute(request) { (response, error) in
                guard error == nil, let json = response as? [String: Any], let response = GetProductResponse.object(from: json) else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                callback(MagentoProductAdapter.adapt(response, currency: сurrency), nil)
            }
        }
    }
    
    public func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        var currentPaginationValue = defaultPaginationValue
        let nameValue = String(format: searchValueFormat, arguments: [searchQuery])
        let namePair = (nameField, nameValue)
        
        let builder = ProductsParametersBuilder()
            .addFilterParameters(pair: namePair, condition: .like)
        
        if let paginationValue = paginationValue as? String, let castedPaginationValue = Int(paginationValue) {
            currentPaginationValue = castedPaginationValue
        }
        
        getProductList(perPage: perPage, paginationValue: currentPaginationValue, builder: builder, callback: callback)
    }
    
    public func getProductVariantList(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let typeIdPair = (strongSelf.typeIdField, strongSelf.simpleValue)
            let skuPairs = ids.map { (strongSelf.skuField, $0) }
            
            let parameters = ProductsParametersBuilder()
                .addFilterParameters(pair: typeIdPair)
                .addFilterParameters(pairs: skuPairs)
                .build()
            
            let route = MagentoProductsRoute.getProducts(parameters: parameters)
            let request = MagentoProductsRouter(route: route)
            
            strongSelf.execute(request) { (response, error) in
                guard error == nil, let json = response as? [String: Any], let response = GetProductListResponse.object(from: json) else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                let products = response.items.map { MagentoProductAdapter.adapt($0, currency: сurrency) }
                let productVariants = products.map { MagentoProductVariantAdapter.adapt($0) }
                
                callback(productVariants, nil)
            }
        }
    }
    
    // MARK: - Categories
    
    public func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, parentCategoryId: String?, callback: @escaping RepoCallback<[ShopApp_Gateway.Category]>) {
        var parameters = Parameters()
        
        if let parentCategoryId = parentCategoryId {
            parameters[parentCategoryId] = parentCategoryId
        }
        
        let route = MagentoCategoriesRoute.getCategories(parameters: parameters)
        let request = MagentoCategoriesRouter(route: route)
        
        execute(request) { (response, error) in
            guard error == nil, let json = response as? [String: Any], let response = GetCategoryListResponse.object(from: json) else {
                callback(nil, error ?? ContentError())
                
                return
            }

            callback(MagentoCategoryAdapter.adapt(response).childrenCategories, nil)
        }
    }
    
    public func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<ShopApp_Gateway.Category>) {
        var currentPaginationValue = defaultPaginationValue
        let categoryIdPair = (categoryIdField, id)
        var fieldName: String?
        
        let builder = ProductsParametersBuilder()
            .addFilterParameters(pair: categoryIdPair)
        
        if let sortBy = sortBy {
            switch sortBy {
            case .name:
                fieldName = nameField
            case .createdAt:
                fieldName = createdAtField
            case .priceHighToLow, .priceLowToHigh:
                fieldName = priceField
            default:
                break
            }
        }
        
        if let fieldName = fieldName {
            _ = builder.addSortOrderParameters(field: fieldName, isRevers: reverse)
        }
        
        if let paginationValue = paginationValue as? String, let castedPaginationValue = Int(paginationValue) {
            currentPaginationValue = castedPaginationValue
        }
        
        getProductList(perPage: perPage, paginationValue: currentPaginationValue, builder: builder) { [weak self] (products, error) in
            guard let strongSelf = self, let products = products, error == nil else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let route = MagentoCategoriesRoute.getCategory(id: id)
            let request = MagentoCategoriesRouter(route: route)
            
            strongSelf.execute(request) { (response, error) in
                guard error == nil, let json = response as? [String: Any], let response = GetCategoryDetailsResponse.object(from: json) else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                callback(MagentoCategoryAdapter.adapt(response, products: products), nil)
            }
        }
    }
    
    // MARK: - Articles
    
    public func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {
        // There is no api to fetch articles
        callback([], nil)
    }
    
    public func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        // There is no api to fetch article
        callback(nil, nil)
    }
    
    // MARK: - Customer
    
    public func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        guard let firstName = firstName, let lastName = lastName else {
            callback(nil, ContentError())
            
            return
        }
        
        let customer = CustomerRequestBody(email: email, firstName: firstName, lastName: lastName)
        let signUp = SignUpRequestBody(customer: customer, password: password)
        let route = MagentoCustomerRoute.signUp(body: signUp)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, response != nil else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            strongSelf.getToken(with: email, password: password) { (token, error) in
                callback(token != nil, error)
            }
        }
    }
    
    public func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        getToken(with: email, password: password) { (token, error) in
            callback(token != nil, error)
        }
    }
    
    public func logout(callback: RepoCallback<Bool>) {
        sessionService.removeData()

        callback(true, nil)
    }
    
    public func isLoggedIn() -> Bool {
        return sessionService.isLoggedIn
    }
    
    public func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        let resetPassword = ResetPasswordRequestBody(email: email)
        let route = MagentoCustomerRoute.resetPassword(body: resetPassword)
        let request = MagentoCustomerRouter(route: route)
        
        execute(request) { (response, error) in
            guard error == nil, response as? Bool != nil else {
                callback(false, error ?? ContentError())
                
                return
            }
            
            callback(true, nil)
        }
    }
    
    public func getCustomer(callback: @escaping RepoCallback<Customer>) {
        guard let token = sessionService.data.token else {
            callback(nil, ContentError())
            
            return
        }
        
        let route = MagentoCustomerRoute.getCustomer(token: token)
        let request = MagentoCustomerRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                strongSelf.removeSessionDataIfNeeded(error)
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let customer = MagentoCustomerAdapter.adapt(response)
            
            strongSelf.getCountries { (countries, error) in
                guard let countries = countries, error == nil else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                MagentoCustomerAdapter.update(customer, with: countries)
                
                callback(customer, nil)
            }
        }
    }
    
    public func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        guard let token = sessionService.data.token, let firstName = firstName, let lastName = lastName else {
            callback(nil, ContentError())
            
            return
        }
        
        let customer = CustomerRequestBody(email: email, firstName: firstName, lastName: lastName)
        let updateCustomer = UpdateCustomerRequestBody(customer: customer)
        let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
        let request = MagentoCustomerRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                strongSelf.removeSessionDataIfNeeded(error)
                callback(nil, error ?? ContentError())
                
                return
            }
            
            callback(MagentoCustomerAdapter.adapt(response), nil)
        }
    }
    
    public func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        // There is no api to fetch newsletter subscription
        callback(nil, nil)
    }
    
    public func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        let sessionData = sessionService.data
        
        guard let token = sessionData.token, let currentPassword = sessionData.password else {
            callback(nil, ContentError())
            
            return
        }
        
        let updatePassword = UpdatePasswordRequestBody(currentPassword: currentPassword, newPassword: password)
        let route = MagentoCustomerRoute.updatePassword(token: token, body: updatePassword)
        let request = MagentoCustomerRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, response as? Bool != nil else {
                strongSelf.removeSessionDataIfNeeded(error)
                callback(nil, error ?? ContentError())
                
                return
            }
            
            strongSelf.getCustomer(callback: callback)
        }
    }
    
    public func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let customer = customer, let firstName = customer.firstName, let lastName = customer.lastName, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            strongSelf.getCountries { (countries, error) in
                guard error == nil, let countries = countries else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                MagentoAddressAdapter.update(address, with: countries)
                
                guard let adaptedAddress = MagentoAddressAdapter.adapt(address) else {
                    callback(nil, ContentError())
                    
                    return
                }
                
                var adaptedAddresses: [AddressRequestBody] = []
                var addressBody = adaptedAddress
                
                if let customerAddresses = customer.addresses, !customerAddresses.isEmpty {
                    adaptedAddresses = customerAddresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }
                    
                    guard adaptedAddresses.count == customerAddresses.count else {
                        callback(nil, ContentError())
                        
                        return
                    }
                    
                    adaptedAddresses.append(addressBody)
                } else {
                    addressBody.isDefaultAddress = true
                    adaptedAddresses = [addressBody]
                }
                
                let customerBody = CustomerRequestBody(email: customer.email, firstName: firstName, lastName: lastName, addresses: adaptedAddresses)
                let updateCustomer = UpdateCustomerRequestBody(customer: customerBody)
                let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
                let request = MagentoCustomerRouter(route: route)
                
                strongSelf.execute(request) { [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }

                    guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                        strongSelf.removeSessionDataIfNeeded(error)
                        callback(nil, error ?? ContentError())

                        return
                    }
                    
                    let id = MagentoAddressAdapter.idOfAddedAddress(customerAddresses: customer.addresses, responseAddresses: response.addresses)

                    callback(id, nil)
                }
            }
        }
    }
    
    public func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let customer = customer, let firstName = customer.firstName, let lastName = customer.lastName, let customerAddresses = customer.addresses, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            strongSelf.getCountries { (countries, error) in
                guard error == nil, let countries = countries else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                MagentoAddressAdapter.update(address, with: countries)
                
                var adaptedAddresses = customerAddresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }
                
                guard let adaptedAddress = MagentoAddressAdapter.adapt(address), adaptedAddresses.count == customerAddresses.count, let index = adaptedAddresses.index(where: { $0.id == adaptedAddress.id }) else {
                    callback(nil, ContentError())
                    
                    return
                }
                
                adaptedAddresses.remove(at: index)
                adaptedAddresses.insert(adaptedAddress, at: index)
                
                let customerBody = CustomerRequestBody(email: customer.email, firstName: firstName, lastName: lastName, addresses: adaptedAddresses)
                let updateCustomer = UpdateCustomerRequestBody(customer: customerBody)
                let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
                let request = MagentoCustomerRouter(route: route)
                
                strongSelf.execute(request) { [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard error == nil, response as? [String: Any] != nil else {
                        strongSelf.removeSessionDataIfNeeded(error)
                        callback(false, error ?? ContentError())
                        
                        return
                    }
                    
                    callback(true, nil)
                }
            }
        }
    }
    
    public func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let customer = customer, let firstName = customer.firstName, let lastName = customer.lastName, let customerAddresses = customer.addresses, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            var adaptedAddresses = customerAddresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }
            
            guard adaptedAddresses.count == customerAddresses.count, let newDefaultIndex = adaptedAddresses.index(where: { $0.id == Int(addressId) }), let oldDefaultIndex = adaptedAddresses.index(where: { $0.isDefaultAddress == true }) else {
                callback(nil, ContentError())
                
                return
            }
            
            var newDefaultAddress = adaptedAddresses[newDefaultIndex]
            newDefaultAddress.isDefaultAddress = true
            adaptedAddresses[newDefaultIndex] = newDefaultAddress
            
            var oldDefaultAddress = adaptedAddresses[oldDefaultIndex]
            oldDefaultAddress.isDefaultAddress = false
            adaptedAddresses[oldDefaultIndex] = oldDefaultAddress
            
            let customerBody = CustomerRequestBody(email: customer.email, firstName: firstName, lastName: lastName, addresses: adaptedAddresses)
            let updateCustomer = UpdateCustomerRequestBody(customer: customerBody)
            let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
            let request = MagentoCustomerRouter(route: route)
            
            strongSelf.execute(request) { [weak self] (response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                    strongSelf.removeSessionDataIfNeeded(error)
                    callback(nil, error ?? ContentError())
                    
                    return
                }

                callback(MagentoCustomerAdapter.adapt(response), nil)
            }
        }
    }
    
    public func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let customer = customer, let firstName = customer.firstName, let lastName = customer.lastName, let customerAddresses = customer.addresses, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            var adaptedAddresses = customerAddresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }
            
            guard adaptedAddresses.count == customerAddresses.count, let index = adaptedAddresses.index(where: { $0.id == Int(addressId) }) else {
                callback(nil, ContentError())
                
                return
            }
            
            adaptedAddresses.remove(at: index)
            
            let customerBody = CustomerRequestBody(email: customer.email, firstName: firstName, lastName: lastName, addresses: adaptedAddresses)
            let updateCustomer = UpdateCustomerRequestBody(customer: customerBody)
            let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
            let request = MagentoCustomerRouter(route: route)
            
            strongSelf.execute(request) { [weak self] (response, error) in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil, response as? [String: Any] != nil else {
                    strongSelf.removeSessionDataIfNeeded(error)
                    callback(false, error ?? ContentError())
                    
                    return
                }
                
                callback(true, nil)
            }
        }
    }
    
    // MARK: - Payments
    
    public func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        // TODO: Implement api method
    }
    
    public func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        // TODO: Implement api method
    }
    
    public func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        // TODO: Implement api method
    }
    
    public func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        // TODO: Implement api method
    }
    
    public func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        // TODO: Implement api method
    }
    
    public func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        // TODO: Implement api method
    }
    
    public func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        // TODO: Implement api method
    }
    
    public func getCountries(callback: @escaping RepoCallback<[Country]>) {
        let route = MagentoPaymentsRoute.getCountries
        let request = MagentoPaymentsRouter(route: route)
        
        execute(request) { (response, error) in
            guard error == nil, let json = response as? [Any], let response = CountryResponse.objects(from: json) else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let countries = response.map { MagentoCountryAdapter.adapt($0) }
            
            callback(countries, nil)
        }
    }

    // MARK: - Orders
    
    public func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
        // There is no api to fetch orders
        callback([], nil)
    }
    
    public func getOrder(id: String, callback: @escaping RepoCallback<Order>) {
        // There is no api to fetch order
        callback(nil, nil)
    }
    
    // MARK: - Private
    
    private func getToken(with email: String, password: String, callback: @escaping RepoCallback<String>) {
        let getToken = GetTokenRequestBody(email: email, password: password)
        let route = MagentoCustomerRoute.getToken(body: getToken)
        let request = MagentoCustomerRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let token = response as? String else {
                callback(nil, error ?? ContentError())
                
                return
            }

            strongSelf.sessionService.save(token: token, email: email, password: password)
            
            callback(token, nil)
        }
    }
    
    private func removeSessionDataIfNeeded(_ error: RepoError?) {
        if let error = error, error.statusCode == unauthorizedStatusCode {
            sessionService.removeData()
        }
    }
    
    private func getProductList(perPage: Int, paginationValue: Int, builder: ProductsParametersBuilder, callback: @escaping RepoCallback<[Product]>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            let typeIdPair = (strongSelf.typeIdField, strongSelf.simpleValue)
            
            let parameters = builder
                .addFilterParameters(pair: typeIdPair)
                .addPaginationParameters(pageSize: perPage, currentPage: paginationValue)
                .build()
            
            let route = MagentoProductsRoute.getProducts(parameters: parameters)
            let request = MagentoProductsRouter(route: route)
            
            strongSelf.execute(request) { (response, error) in
                guard error == nil, let json = response as? [String: Any], let response = GetProductListResponse.object(from: json) else {
                    callback(nil, error ?? ContentError())
                    
                    return
                }
                
                let nextPaginationValue = response.nextPaginationValue(perPage: perPage, currentPaginationValue: paginationValue)
                let products = response.items.map { MagentoProductAdapter.adapt($0, currency: сurrency, paginationValue: nextPaginationValue) }
                
                callback(products, nil)
            }
        }
    }
    
    private func getStoreConfigs(callback: @escaping RepoCallback<String>) {
        let route = MagentoStoreRoute.getConfigs
        let request = MagentoStoreRouter(route: route)
        
        execute(request) { (response, error) in
            guard error == nil, let json = response as? [Any], let response = StoreConfigResponse.objects(from: json) else {
                callback(nil, error ?? ContentError())
                
                return
            }
            
            callback(response.first?.сurrencyСode ?? "", nil)
        }
    }
}
