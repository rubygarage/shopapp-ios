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
    
    private var cartId: String?
    
    private lazy var config: Config = {
        return Config(isPopularEnabled: false, isBlogEnabled: false, isOrdersEnabled: false)
    }()

    /**
     Initializer for Magento API.

     - Parameter shopDomain: Domain of shop
     */
    public init(shopDomain: String) {
        BaseRouter.hostUrl = shopDomain
        BaseRouter.baseUrl = defaultBaseUrl

        super.init()
    }
    
    // MARK: - Setup
    
    public func setupProvider(callback: @escaping ApiCallback<Void>) {
        // There is no setup
        callback(nil, nil)
    }

    // MARK: - Config
    public func getConfig() -> Config {
        return config
    }

    // MARK: - Shop info

    public func getShop(callback: @escaping ApiCallback<Shop>) {
        // There is no api to fetch terms
        callback(nil, nil)
    }

    // MARK: - Products

    public func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>) {
        guard let sortBy = sortBy, sortBy.rawValue != SortType.relevant.rawValue else {
            callback([], nil)

            return
        }

        var currentPaginationValue = defaultPaginationValue
        let builder = ProductsParametersBuilder()

        if sortBy.rawValue == SortType.recent.rawValue {
            _ = builder.addSortOrderParameters(field: createdAtField, isRevers: true)
        } else if sortBy.rawValue == SortType.type.rawValue, let keyword = keyword {
            let attributeSetIdPair = (attributeSetIdField, keyword)
            _ = builder.addFilterParameters(pair: attributeSetIdPair)

            if let excludeKeyword = excludeKeyword {
                let namePair = (nameField, excludeKeyword)
                _ = builder.addFilterParameters(pair: namePair, condition: .notEqual)
            }
        }

        if let paginationValue = paginationValue as? String, let castedPaginationValue = Int(paginationValue) {
            currentPaginationValue = castedPaginationValue
        }

        getProductList(perPage: perPage, paginationValue: currentPaginationValue, builder: builder, callback: callback)
    }

    public func getProduct(id: String, callback: @escaping ApiCallback<Product>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            let route = MagentoProductsRoute.getProduct(sku: id)
            let request = MagentoProductsRouter(route: route)

            strongSelf.execute(request) { (response, error) in
                guard error == nil, let json = response as? [String: Any], let response = GetProductResponse.object(from: json) else {
                    callback(nil, error ?? ShopAppError.critical)

                    return
                }

                callback(MagentoProductAdapter.adapt(response, currency: сurrency), nil)
            }
        }
    }

    public func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>) {
        var currentPaginationValue = defaultPaginationValue
        let nameValue = String(format: searchValueFormat, arguments: [query])
        let namePair = (nameField, nameValue)

        let builder = ProductsParametersBuilder()
            .addFilterParameters(pair: namePair, condition: .like)

        if let paginationValue = paginationValue as? String, let castedPaginationValue = Int(paginationValue) {
            currentPaginationValue = castedPaginationValue
        }

        getProductList(perPage: perPage, paginationValue: currentPaginationValue, builder: builder, callback: callback)
    }

    public func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

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
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                let products = response.items.map { MagentoProductAdapter.adapt($0, currency: сurrency) }
                let productVariants = products.map { MagentoProductVariantAdapter.adapt($0) }

                callback(productVariants, nil)
            }
        }
    }

    // MARK: - Categories

    public func getCategories(perPage: Int, paginationValue: Any?, parentCategoryId: String?, callback: @escaping ApiCallback<[ShopApp_Gateway.Category]>) {
        var parameters = Parameters()

        if let parentCategoryId = parentCategoryId {
            parameters[self.parentCategoryId] = parentCategoryId
        }

        let route = MagentoCategoriesRoute.getCategories(parameters: parameters)
        let request = MagentoCategoriesRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self, error == nil, let json = response as? [String: Any], let response = GetCategoryListResponse.object(from: json) else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }
            
            let group = DispatchGroup()
            let category = MagentoCategoryAdapter.adapt(response)
            var childrenCategories: [ShopApp_Gateway.Category] = []
            
            category.childrenCategories.forEach {
                group.enter()

                strongSelf.getCategory(id: $0.id) { (response, error) in
                    guard error == nil, let response = response else {
                        callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                        
                        return
                    }
                    
                    childrenCategories.append(MagentoCategoryAdapter.adapt(response, products: []))
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                let updatedCategory = MagentoCategoryAdapter.update(category, with: childrenCategories)
                
                callback(updatedCategory.childrenCategories, nil)
            }
        }
    }

    public func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<ShopApp_Gateway.Category>) {
        var currentPaginationValue = defaultPaginationValue
        let categoryIdPair = (categoryIdField, id)
        var fieldName: String?
        var reverse = false

        let builder = ProductsParametersBuilder()
            .addFilterParameters(pair: categoryIdPair)

        if let sortBy = sortBy {
            switch sortBy {
            case .name:
                fieldName = nameField
            case .recent:
                fieldName = createdAtField
                reverse = true
            case .priceHighToLow:
                fieldName = priceField
                reverse = true
            case .priceLowToHigh:
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
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            strongSelf.getCategory(id: id) { (response, error) in
                guard error == nil, let response = response else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                callback(MagentoCategoryAdapter.adapt(response, products: products), nil)
            }
        }
    }

    // MARK: - Articles

    public func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>) {
        // There is no api to fetch articles
        callback([], nil)
    }

    public func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        // There is no api to fetch article
        callback(nil, nil)
    }

    // MARK: - Authorization

    public func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, callback: @escaping ApiCallback<Void>) {

        let customer = CustomerRequest(email: email, firstName: firstName, lastName: lastName)
        let signUp = SignUpRequest(customer: customer, password: password)
        let route = MagentoCustomerRoute.signUp(body: signUp)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, response != nil else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            strongSelf.getToken(with: email, password: password) { (_, error) in
                callback(nil, error)
            }
        }
    }

    public func signIn(email: String, password: String, callback: @escaping ApiCallback<Void>) {
        getToken(with: email, password: password) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.cartId = nil
            callback(nil, error)
        }
    }

    public func signOut(callback: @escaping ApiCallback<Void>) {
        sessionService.removeData()
        cartId = nil

        callback(nil, nil)
    }

    public func isSignedIn(callback: @escaping ApiCallback<Bool>) {
        callback(sessionService.isSignedIn, nil)
    }

    public func resetPassword(email: String, callback: @escaping ApiCallback<Void>) {
        let resetPassword = ResetPasswordRequest(email: email)
        let route = MagentoCustomerRoute.resetPassword(body: resetPassword)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { (response, error) in
            guard error == nil, response as? Bool != nil else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            callback(nil, nil)
        }
    }

    // MARK: - Customer

    public func getCustomer(callback: @escaping ApiCallback<Customer>) {
        guard let token = sessionService.data.token else {
            callback(nil, ShopAppError.content(isNetworkError: false))

            return
        }

        let route = MagentoCustomerRoute.getCustomer(token: token)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            let customer = MagentoCustomerAdapter.adapt(response)

            strongSelf.getCountries { (countries, error) in
                guard let countries = countries, error == nil else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                let updatedCustomer = MagentoCustomerAdapter.update(customer, with: countries)

                callback(updatedCustomer, nil)
            }
        }
    }

    public func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>) {
        guard let token = sessionService.data.token, let email = sessionService.data.email else {
            callback(nil, ShopAppError.content(isNetworkError: false))

            return
        }

        let customer = CustomerRequest(email: email, firstName: firstName, lastName: lastName)
        let updateCustomer = UpdateCustomerRequest(customer: customer)
        let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { (response, error) in
            guard error == nil, let json = response as? [String: Any], let response = GetCustomerResponse.object(from: json) else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            callback(MagentoCustomerAdapter.adapt(response), nil)
        }
    }

    public func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>) {
        // There is no api to fetch newsletter subscription
        callback(nil, nil)
    }

    public func updatePassword(password: String, callback: @escaping ApiCallback<Void>) {
        let sessionData = sessionService.data

        guard let token = sessionData.token, let currentPassword = sessionData.password else {
            callback(nil, ShopAppError.content(isNetworkError: false))

            return
        }

        let updatePassword = UpdatePasswordRequest(currentPassword: currentPassword, newPassword: password)
        let route = MagentoCustomerRoute.updatePassword(token: token, body: updatePassword)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { (response, error) in
            guard error == nil, response as? Bool != nil else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            callback(nil, nil)
        }
    }

    public func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let customer = customer, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            strongSelf.getCountries { (countries, error) in
                guard error == nil, let countries = countries else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                let updatedAddress = MagentoAddressAdapter.update(address, with: countries)

                guard let adaptedAddress = MagentoAddressAdapter.adapt(updatedAddress) else {
                    callback(nil, ShopAppError.content(isNetworkError: false))

                    return
                }

                var adaptedAddresses: [AddressRequest] = []
                var addressBody = adaptedAddress

                if !customer.addresses.isEmpty {
                    adaptedAddresses = customer.addresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }

                    guard adaptedAddresses.count == customer.addresses.count else {
                        callback(nil, ShopAppError.content(isNetworkError: false))

                        return
                    }

                    adaptedAddresses.append(addressBody)
                } else {
                    addressBody = AddressRequest.update(addressBody, isDefaultAddress: true)
                    adaptedAddresses = [addressBody]
                }

                let customerBody = CustomerRequest(email: customer.email, firstName: customer.firstName, lastName: customer.lastName, addresses: adaptedAddresses)
                let updateCustomer = UpdateCustomerRequest(customer: customerBody)
                let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
                let request = MagentoCustomerRouter(route: route)

                strongSelf.execute(request) { (_, error) in
                    guard let error = error else {
                        callback(nil, nil)

                        return
                    }

                    callback(nil, error)
                }
            }
        }
    }

    public func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let customer = customer, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            strongSelf.getCountries { (countries, error) in
                guard error == nil, let countries = countries else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                let updatedAddress = MagentoAddressAdapter.update(address, with: countries)

                var adaptedAddresses = customer.addresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }

                guard let adaptedAddress = MagentoAddressAdapter.adapt(updatedAddress), adaptedAddresses.count == customer.addresses.count, let index = adaptedAddresses.index(where: { $0.id == adaptedAddress.id }) else {
                    callback(nil, ShopAppError.content(isNetworkError: false))

                    return
                }

                adaptedAddresses.remove(at: index)
                adaptedAddresses.insert(adaptedAddress, at: index)

                let customerBody = CustomerRequest(email: customer.email, firstName: customer.firstName, lastName: customer.lastName, addresses: adaptedAddresses)
                let updateCustomer = UpdateCustomerRequest(customer: customerBody)
                let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
                let request = MagentoCustomerRouter(route: route)

                strongSelf.execute(request) { (response, error) in
                    guard error == nil, response as? [String: Any] != nil else {
                        callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                        return
                    }

                    callback(nil, nil)
                }
            }
        }
    }

    public func setDefaultShippingAddress(id addressId: String, callback: @escaping ApiCallback<Void>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let customer = customer, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            var adaptedAddresses = customer.addresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }

            guard adaptedAddresses.count == customer.addresses.count, let newDefaultIndex = adaptedAddresses.index(where: { $0.id == Int(addressId) }), let oldDefaultIndex = adaptedAddresses.index(where: { $0.isDefaultAddress == true }) else {
                callback(nil, ShopAppError.content(isNetworkError: false))

                return
            }

            var newDefaultAddress = adaptedAddresses[newDefaultIndex]
            newDefaultAddress = AddressRequest.update(newDefaultAddress, isDefaultAddress: true)
            adaptedAddresses[newDefaultIndex] = newDefaultAddress

            var oldDefaultAddress = adaptedAddresses[oldDefaultIndex]
            oldDefaultAddress = AddressRequest.update(oldDefaultAddress, isDefaultAddress: false)
            adaptedAddresses[oldDefaultIndex] = oldDefaultAddress

            let customerBody = CustomerRequest(email: customer.email, firstName: customer.firstName, lastName: customer.lastName, addresses: adaptedAddresses)
            let updateCustomer = UpdateCustomerRequest(customer: customerBody)
            let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
            let request = MagentoCustomerRouter(route: route)

            strongSelf.execute(request) { (_, error) in
                guard let error = error else {
                    callback(nil, nil)

                    return
                }

                callback(nil, error)
            }
        }
    }

    public func deleteCustomerAddress(id addressId: String, callback: @escaping ApiCallback<Void>) {
        getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let customer = customer, let token = strongSelf.sessionService.data.token else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            var adaptedAddresses = customer.addresses.flatMap { MagentoAddressAdapter.adapt($0, defaultAddress: customer.defaultAddress) }

            guard adaptedAddresses.count == customer.addresses.count, let index = adaptedAddresses.index(where: { $0.id == Int(addressId) }) else {
                callback(nil, ShopAppError.content(isNetworkError: false))

                return
            }

            adaptedAddresses.remove(at: index)

            let customerBody = CustomerRequest(email: customer.email, firstName: customer.firstName, lastName: customer.lastName, addresses: adaptedAddresses)
            let updateCustomer = UpdateCustomerRequest(customer: customerBody)
            let route = MagentoCustomerRoute.updateCustomer(token: token, body: updateCustomer)
            let request = MagentoCustomerRouter(route: route)

            strongSelf.execute(request) { (response, error) in
                guard error == nil, response as? [String: Any] != nil else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                callback(nil, nil)
            }
        }
    }

    // MARK: - Payments

    public func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>) {
        // TODO: Implement api method
    }

    public func getCheckout(id checkoutId: String, callback: @escaping ApiCallback<Checkout>) {
        // TODO: Implement api method
    }

    public func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>) {
        // TODO: Implement api method
    }

    public func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>) {
        // TODO: Implement api method
    }

    public func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>) {
        // TODO: Implement api method
    }

    public func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>) {
        // TODO: Implement api method
    }

    public func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>) {
        // TODO: Implement api method
    }
    
    // MARK: - Countries

    public func getCountries(callback: @escaping ApiCallback<[Country]>) {
        let route = MagentoPaymentsRoute.getCountries
        let request = MagentoPaymentsRouter(route: route)

        execute(request) { (response, error) in
            guard error == nil, let json = response as? [Any], let response = CountryResponse.objects(from: json) else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            let countries = response.map { MagentoCountryAdapter.adapt($0) }

            callback(countries, nil)
        }
    }

    // MARK: - Orders

    public func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>) {
        // There is no api to fetch orders
        callback([], nil)
    }

    public func getOrder(id: String, callback: @escaping ApiCallback<Order>) {
        // There is no api to fetch order
        callback(nil, nil)
    }

    // MARK: - Cart

    public func getCartProducts(callback: @escaping ApiCallback<[CartProduct]>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                
                return
            }
            
            strongSelf.getQuoteId { [weak self] (quoteId, error) in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil, let quoteId = quoteId else {
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                    
                    return
                }
                
                let token = strongSelf.sessionService.data.token
                let route = token == nil ? MagentoCartRoute.getCartProductsUnauthorized(quoteId: quoteId) : MagentoCartRoute.getCartProductsAuthorized(token: token!)
                let request = MagentoCartRouter(route: route)
                
                strongSelf.execute(request) { [weak self] (response, error) in
                    guard let strongSelf = self, error == nil, let json = response as? [Any], let response = CartProductResponse.objects(from: json) else {
                        callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                        
                        return
                    }
                    
                    let group = DispatchGroup()
                    var cartProducts = response.map({ MagentoCartProductAdapter.adapt($0, currency: сurrency) })
                    for index in 0..<cartProducts.count {
                        group.enter()
                        
                        let cartItem = cartProducts[index]
                        strongSelf.getProduct(id: cartItem.id) { (response, error) in
                            guard let product = response else {
                                callback(nil, error)
                                
                                return
                            }
                            
                            cartProducts[index] = MagentoCartProductAdapter.update(cartItem, with: product.images.first)
                            
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) {
                        callback(cartProducts, nil)
                    }
                }
            }
        }
    }
    
    public func addCartProduct(cartProduct: CartProduct, callback: @escaping ApiCallback<Void>) {
        getQuoteId { [weak self] (quoteId, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let quoteId = quoteId else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                
                return
            }
            
            let quantity = String(cartProduct.quantity)
            let addCartProduct = AddCartProductRequest(id: cartProduct.id, quantity: quantity, quoteId: quoteId)
            let token = strongSelf.sessionService.data.token
            let route = token == nil ? MagentoCartRoute.addCartProductUnauthorized(quoteId: quoteId, body: addCartProduct) : MagentoCartRoute.addCartProductAuthorized(token: token!, body: addCartProduct)
            let request = MagentoCartRouter(route: route)
            
            strongSelf.execute(request) { (_, error) in
                callback(nil, error)
            }
        }
    }
    
    public func deleteCartProduct(cartItemId: String, callback: @escaping ApiCallback<Void>) {
        getQuoteId { [weak self] (quoteId, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let quoteId = quoteId else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                
                return
            }
            
            let token = strongSelf.sessionService.data.token
            let route = token == nil ? MagentoCartRoute.deleteCartProductUnauthorized(quoteId: quoteId, itemId: cartItemId) : MagentoCartRoute.deleteCartProductAuthorized(token: token!, quoteId: quoteId, itemId: cartItemId)
            let request = MagentoCartRouter(route: route)
            
            strongSelf.execute(request) { (_, error) in
                callback(nil, error)
            }
        }
    }

    public func deleteCartProducts(cartItemIds: [String], callback: @escaping ApiCallback<Void>) {
        // There is no reason to delete cart products
        callback(nil, nil)
    }

    public func deleteAllCartProducts(callback: @escaping ApiCallback<Void>) {
        // There is no reason to delete all cart products
        cartId = nil
        callback(nil, nil)
    }

    public func changeCartProductQuantity(cartItemId: String, quantity: Int, callback: @escaping ApiCallback<Void>) {
        getQuoteId { [weak self] (quoteId, error) in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil, let quoteId = quoteId else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                
                return
            }
            
            let token = strongSelf.sessionService.data.token
            let quantity = String(quantity)
            let changeCartProductQuantity = ChangeCartProductQuantityRequest(quantity: quantity, quoteId: quoteId)
            let route = token == nil ? MagentoCartRoute.changeCartProductQuantityUnauthorized(quoteId: quoteId, itemId: cartItemId, body: changeCartProductQuantity) : MagentoCartRoute.changeCartProductQuantityAuthorized(token: token!, itemId: cartItemId, body: changeCartProductQuantity)
            let request = MagentoCartRouter(route: route)
            
            strongSelf.execute(request) { (_, error) in
                callback(nil, error)
            }
        }
    }

    // MARK: - Private

    private func getToken(with email: String, password: String, callback: @escaping ApiCallback<String>) {
        let getToken = GetTokenRequest(email: email, password: password)
        let route = MagentoCustomerRoute.getToken(body: getToken)
        let request = MagentoCustomerRouter(route: route)

        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let token = response as? String else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            strongSelf.sessionService.save(token: token, email: email, password: password)

            callback(token, nil)
        }
    }

    private func getProductList(perPage: Int, paginationValue: Int, builder: ProductsParametersBuilder, callback: @escaping ApiCallback<[Product]>) {
        getStoreConfigs { [weak self] (сurrency, error) in
            guard let strongSelf = self else {
                return
            }

            guard error == nil, let сurrency = сurrency else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

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
                    callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                    return
                }

                let nextPaginationValue = response.nextPaginationValue(perPage: perPage, currentPaginationValue: paginationValue)
                let products = response.items.map { MagentoProductAdapter.adapt($0, currency: сurrency, paginationValue: nextPaginationValue) }

                callback(products, nil)
            }
        }
    }

    private func getStoreConfigs(callback: @escaping ApiCallback<String>) {
        let route = MagentoStoreRoute.getConfigs
        let request = MagentoStoreRouter(route: route)

        execute(request) { (response, error) in
            guard error == nil, let json = response as? [Any], let response = StoreConfigResponse.objects(from: json) else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))

                return
            }

            callback(response.first?.сurrencyСode ?? "", nil)
        }
    }
    
    private func getCategory(id: String, callback: @escaping ApiCallback<GetCategoryDetailsResponse>) {
        let route = MagentoCategoriesRoute.getCategory(id: id)
        let request = MagentoCategoriesRouter(route: route)
        
        execute(request) { (response, error) in
            guard error == nil, let json = response as? [String: Any], let response = GetCategoryDetailsResponse.object(from: json) else {
                callback(nil, error ?? ShopAppError.critical)
                
                return
            }
            
            callback(response, nil)
        }
    }
    
    private func getQuoteId(callback: @escaping ApiCallback<String>) {
        if let quoteId = cartId {
            callback(quoteId, nil)
        } else {
            createCustomerCart(callback: callback)
        }
    }
    
    private func createCustomerCart(callback: @escaping ApiCallback<String>) {
        let token = sessionService.data.token
        let route = token == nil ? MagentoCartRoute.createQuoteUnauthorized : MagentoCartRoute.createQuoteAuthorized(token: token!)
        let request = MagentoCartRouter(route: route)
        
        execute(request) { [weak self] (response, error) in
            guard let strongSelf = self, error == nil, let quoteId = response as? String else {
                callback(nil, error ?? ShopAppError.content(isNetworkError: false))
                
                return
            }
            
            strongSelf.cartId = quoteId
            callback(quoteId, nil)
        }
    }
}
