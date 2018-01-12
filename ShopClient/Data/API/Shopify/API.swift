//
//  API.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import KeychainSwift

private let kShopifyStorefrontAccessToken = "317392940ba3519bcfa070943900b1de"
private let kShopifyStorefrontURL = "blablablstore.myshopify.com"
private let kShopifyItemsMaxCount: Int32 = 250

class API: NSObject, APIInterface {
    var client: Graph.Client?
    
    override init() {
        super.init()
        
        setup()
    }
    
    func setup() {
        client = Graph.Client(
            shopDomain: kShopifyStorefrontURL,
            apiKey: kShopifyStorefrontAccessToken
        )
    }
    
    // MARK: - APIInterface
    
    // MARK: - shop info
    func getShopInfo(callback: @escaping RepoCallback<Shop>) {
        let query = Storefront.buildQuery { $0
            .shop { $0
                .name()
                .description()
                .privacyPolicy(policyQuery())
                .refundPolicy(policyQuery())
                .termsOfService(policyQuery())
                .paymentSettings(self.paymentSettingsQuery())
            }
        }
        
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            let shopObject = Shop(shopObject: response?.shop)
            let error = self?.process(error: error)
            callback(shopObject, error)
        })
        run(task: task, callback: callback)
    }
    
    // MARK: - products
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {
        let query = productsListQuery(with: perPage, after: paginationValue, searchPhrase: nil, sortBy: sortBy, reverse: reverse)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            var products = [Product]()
            let currency = response?.shop.paymentSettings.currencyCode.rawValue
            if let edges = response?.shop.products.edges {
                for edge in edges {
                    if let product = Product(with: edge, currencyValue: currency) {
                        products.append(product)
                    }
                }
            }
            let responseError = self?.process(error: error)
            callback(products, responseError)
        })
        run(task: task, callback: callback)
    }
    
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        let query = productDetailsQuery(id: id)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            let productNode = response?.node as? Storefront.Product
            let currency = response?.shop.paymentSettings.currencyCode.rawValue
            let productObject = Product(with: productNode, currencyValue: currency)
            let responseError = self?.process(error: error)
            callback(productObject, responseError)
        })
        run(task: task, callback: callback)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        let query = productsListQuery(with: perPage, after: paginationValue, searchPhrase: searchQuery, sortBy: nil, reverse: false)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            var products = [Product]()
            let currency = response?.shop.paymentSettings.currencyCode.rawValue
            if let edges = response?.shop.products.edges {
                for edge in edges {
                    if let product = Product(with: edge, currencyValue: currency) {
                        products.append(product)
                    }
                }
            }
            let responseError = self?.process(error: error)
            callback(products, responseError)
        })
        run(task: task, callback: callback)
    }
    
    // MARK: - categories
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Category]>) {
        let query = categoryListQuery(perPage: perPage, after: paginationValue, sortBy: sortBy, reverse: reverse)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            var categories = [Category]()
            let currency = response?.shop.paymentSettings.currencyCode.rawValue
            if let categoryEdges = response?.shop.collections.edges {
                for categoryEdge in categoryEdges {
                    if let category = Category(with: categoryEdge, currencyValue: currency) {
                        categories.append(category)
                    }
                }
            }
            let responseError = self?.process(error: error)
            callback(categories, responseError)
        })
        run(task: task, callback: callback)
    }
    
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<Category>) {
        let query = categoryDetailsQuery(id: id, perPage: perPage, after: paginationValue, sortBy: sortBy, reverse: reverse)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            let categoryNode = response?.node as! Storefront.Collection
            let currency = response?.shop.paymentSettings.currencyCode.rawValue
            let category = Category(with: categoryNode, currencyValue: currency)
            let responseError = self?.process(error: error)
            callback(category, responseError)
        })
        run(task: task, callback: callback)
    }
    
    // MARK: - articles
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {
        let query = articleListQuery(perPage: perPage, after: paginationValue, reverse: reverse)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            var articles = [Article]()
            if let articleEdges = response?.shop.articles.edges {
                for articleEdge in articleEdges {
                    if let article = Article(with: articleEdge) {
                        articles.append(article)
                    }
                }
            }
            let responseError = self?.process(error: error)
            callback(articles, responseError)
        })
        run(task: task, callback: callback)
    }
    
    func getArticle(id: String, callback: @escaping RepoCallback<Article>) {
        let query = articleRootQuery(id: id)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            let article = Article(with: response?.node as? Storefront.Article)
            let responseError = self?.process(error: error)
            callback(article, responseError)
        })
        run(task: task, callback: callback)
    }
    
    // MARK: - authentification
    func signUp(with email: String, firstName: String?, lastName: String?, password: String, phone: String?, callback: @escaping RepoCallback<Bool>) {
        let query = signUpQuery(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone)
        let task = client?.mutateGraphWith(query, completionHandler: { [weak self] (response, error) in
            if response?.customerCreate?.customer != nil {
                self?.getToken(with: email, password: password, callback: { (token, error) in
                    let success = token != nil
                    callback(success, RepoError(with: error))
                })
            } else if let responseError = response?.customerCreate?.userErrors.first {
                let error = self?.process(error: responseError)
                callback(false, error)
            } else {
                callback(false, ContentError())
            }
        })
        run(task: task, callback: callback)
    }
    
    func login(with email: String, password: String, callback: @escaping RepoCallback<Bool>) {
        getToken(with: email, password: password) { [weak self] (token, error) in
            if let token = token {
                self?.saveSessionData(with: token, email: email)
                callback(true, nil)
            } else if let error = error {
                callback(false, error)
            }
        }
    }
    
    func logout(callback: RepoCallback<Bool>) {
        removeSessionData()
        callback(true, nil)
    }
    
    func resetPassword(with email: String, callback: @escaping RepoCallback<Bool>) {
        let query = resetPasswordQuery(email: email)
        let task = client?.mutateGraphWith(query) { [weak self] (response, error) in
            if let responseError = response?.customerRecover?.userErrors.first {
                let error = self?.process(error: responseError)
                callback(false, error)
            } else {
                callback(true, nil)
            }
        }
        run(task: task, callback: callback)
    }
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        if let token = sessionData().token, let email = sessionData().email {
            getCustomer(with: token, email: email, callback: callback)
        } else {
            callback(nil, ContentError())
        }
    }
    
    // MARK: - payments
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        let query = checkoutCreateQuery(cartProducts: cartProducts)
        let task = client?.mutateGraphWith(query, completionHandler: { [weak self] (response, error) in
            if let checkout = response?.checkoutCreate?.checkout {
                let checkoutItem = Checkout(with: checkout)
                callback(checkoutItem, nil)
            } else if let error = response?.checkoutCreate?.userErrors.first {
                let responseError = self?.process(error: error)
                callback(nil, responseError)
            } else {
                callback(nil, ContentError())
            }
        })
        run(task: task, callback: callback)
    }
    
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        let query = checkoutGetQuery(with: checkoutId)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            if let checkout = Checkout(with: response?.node as? Storefront.Checkout) {
                callback(checkout, nil)
            } else if let error = error {
                let responseError = self?.process(error: error)
                callback(nil, responseError)
            } else {
                callback(nil, ContentError())
            }
        })
        run(task: task, callback: callback)
    }
    
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        let shippingAddress = Storefront.MailingAddressInput.create()
        shippingAddress.update(with: address)
        let checkoutId = GraphQL.ID.init(rawValue: checkoutId)
        let query = updateShippingAddressQuery(shippingAddress: shippingAddress, checkoutId: checkoutId)
        let task = client?.mutateGraphWith(query, completionHandler: { (response, error) in
            if response != nil {
                callback(true, nil)
            }
            if let responseError = ContentError(with: error) {
                callback(false, responseError)
            }
        })
        run(task: task, callback: callback)
    }
    
    func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        if let token = sessionData().token {
            updateCustomerDefaultAddress(with: token, addressId: addressId, callback: callback)
        } else {
            callback(false, ContentError())
        }
    }
    
    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        if let token = sessionData().token {
            updateCustomerAddress(with: token, address: address, callback: callback)
        } else {
            callback(false, ContentError())
        }
    }
    
    func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        if let token = sessionData().token {
            createCustomerAddress(with: token, address: address, callback: callback)
        } else {
            callback(nil, ContentError())
        }
    }
    
    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        if let token = sessionData().token {
            deleteCustomerAddress(with: token, addressId: addressId, callback: callback)
        } else {
            callback(false, ContentError())
        }
    }
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        let checkoutId = GraphQL.ID.init(rawValue: checkoutId)
        let query = getShippingRatesQuery(checkoutId: checkoutId)
        let task = client?.queryGraphWith(query, completionHandler: { (response, error) in
            if let shippingRates = (response?.node as? Storefront.Checkout)?.availableShippingRates?.shippingRates {
                var rates = [ShippingRate]()
                for shippingRate in shippingRates {
                    if let rate = ShippingRate(with: shippingRate) {
                        rates.append(rate)
                    }
                }
                callback(rates, nil)
            }
            if let responseError = ContentError(with: error) {
                callback(nil, responseError)
            }
        })
        run(task: task, callback: callback)
    }
    
    func updateCheckout(with rate: ShippingRate, checkout: Checkout, callback: @escaping RepoCallback<Checkout>) {
        let checkoutId = GraphQL.ID.init(rawValue: checkout.id)
        let query = updateShippingLineQuery(checkoutId: checkoutId, shippingRateHandle: rate.handle)
        let task = client?.mutateGraphWith(query, completionHandler: { (response, error) in
            if let checkout = Checkout(with: response?.checkoutShippingLineUpdate?.checkout) {
                callback(checkout, nil)
            } else if let responseError = ContentError(with: error) {
                callback(nil, responseError)
            } else {
                callback(nil, ContentError())
            }
        })
        run(task: task, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Bool>) {
        let query = cardVaultUrlQuery()
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            if let responseError = ContentError(with: error) {
                callback(false, responseError)
            }
            if let cardVaultUrl = response?.shop.paymentSettings.cardVaultUrl {
                self?.pay(with: card, checkout: checkout, cardVaultUrl: cardVaultUrl, address: billingAddress, callback: callback)
            }
        })
        run(task: task, callback: callback)
    }
    
    // MARK: - orders
    func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
        if let token = sessionData().token {
            getOrderList(with: token, perPage: perPage, paginationValue: paginationValue, callback: callback)
        } else {
            callback(nil, ContentError())
        }
    }
    
    func getOrder(id: String, callback: @escaping RepoCallback<Order>) {
        let id = GraphQL.ID(rawValue: id)
        let query = Storefront.buildQuery { $0
            .node(id: id) { $0
                .onOrder { $0
                    .id()
                    .currencyCode()
                    .orderNumber()
                    .processedAt()
                    .subtotalPrice()
                    .totalShippingPrice()
                    .totalPrice()
                    .shippingAddress(self.mailingAddressQuery())
                    .lineItems(first: kShopifyItemsMaxCount, self.lineItemConnectionQuery())
                }
            }
        }
        let task = client?.queryGraphWith(query) { [weak self] (response, error) in
            var responseOrder: Order?
            if let node = response?.node as? Storefront.Order, let order = Order(with: node) {
                responseOrder = order
            }
            let responseError = self?.process(error: error)
            callback(responseOrder, responseError)
        }
        run(task: task, callback: callback)
    }
    
    // MARK: - private
    private func getShippingRates(checkoutId: GraphQL.ID, callback: @escaping RepoCallback<[ShippingRate]>) {
        let query = getShippingRatesQuery(checkoutId: checkoutId)
        let task = client?.queryGraphWith(query, completionHandler: { (response, error) in
            if let shippingRates = (response?.node as? Storefront.Checkout)?.availableShippingRates?.shippingRates {
                var rates = [ShippingRate]()
                for shippingRate in shippingRates {
                    if let rate = ShippingRate(with: shippingRate) {
                        rates.append(rate)
                    }
                }
                callback(rates, nil)
            }
            if let responseError = ContentError(with: error) {
                callback(nil, responseError)
            }
        })
        run(task: task, callback: callback)
    }
    
    private func pay(with card: CreditCard, checkout: Checkout, cardVaultUrl: URL, address: Address, callback: @escaping RepoCallback<Bool>) {
        let creditCard = Card.CreditCard(firstName: card.firstName, lastName: card.lastName, number: card.cardNumber, expiryMonth: card.expireMonth, expiryYear: card.expireYear, verificationCode: card.verificationCode)
        let cardClient = Card.Client.init()
        
        let task = cardClient.vault(creditCard, to: cardVaultUrl) { [weak self] (token, error) in
            if let token = token {
                self?.completePay(checkout: checkout, cardVaultToken: token, address: address, callback: callback)
            }
            if let responseError = ContentError(with: error) {
                callback(false, responseError)
            }
        }
        run(task: task, callback: callback)
    }
    
    private func completePay(checkout: Checkout, cardVaultToken: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        let amount = checkout.totalPrice ?? 0
        let idempotencyKey = UUID().uuidString
        let billingAddress = Storefront.MailingAddressInput.create()
        billingAddress.update(with: address)
        let paymentInput = Storefront.CreditCardPaymentInput.create(amount: amount, idempotencyKey: idempotencyKey, billingAddress: billingAddress, vaultId: cardVaultToken)
        let checkoutId = GraphQL.ID.init(rawValue: checkout.id)
        
        let query = completePayQuery(checkoutId: checkoutId, paymentInput: paymentInput)
        let task = client?.mutateGraphWith(query, completionHandler: { [weak self] (response, error) in
            let mutation = response?.checkoutCompleteWithCreditCard
            if let checkout = mutation?.checkout, let payment = mutation?.payment {
                let success = checkout.ready && payment.ready
                callback(success, nil)
            } else if let error = response?.checkoutCompleteWithCreditCard?.userErrors.first {
                let responseError = self?.process(error: error)
                callback(nil, responseError)
            } else {
                callback(false, ContentError(with: error))
            }
        })
        run(task: task, callback: callback)
    }
    
    private func getToken(with email: String, password: String, callback: @escaping (_ token: Storefront.CustomerAccessToken?, _ error: RepoError?) -> Void) {
        let query = tokenQuery(email: email, password: password)
        let task = client?.mutateGraphWith(query, completionHandler: { [weak self] (response, error) in
            if let token = response?.customerAccessTokenCreate?.customerAccessToken {
                self?.saveSessionData(with: token, email: email)
                callback(token, nil)
            } else if let error = response?.customerAccessTokenCreate?.userErrors.first {
                let responseError = self?.process(error: error)
                callback(nil, responseError)
            } else {
                callback(nil, ContentError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func getCustomer(with token: String, email: String, callback: @escaping RepoCallback<Customer>) {
        let query = customerQuery(with: token)
        let task = client?.queryGraphWith(query, completionHandler: { (response, error) in
            if let customer = Customer(with: response?.customer) {
                callback(customer, nil)
            } else if let responseError = error {
                callback(nil, RepoError(with: responseError))
            } else {
                callback(nil, RepoError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func createCustomerAddress(with token: String, address: Address, callback: @escaping RepoCallback<String>) {
        let query = customerAddressCreateQuery(customerAccessToken: token, address: address)
        let task = client?.mutateGraphWith(query, completionHandler: { (response, error) in
            if let addressId = response?.customerAddressCreate?.customerAddress?.id.rawValue {
                callback(addressId, nil)
            } else if let repoError = RepoError(with: error) {
                callback(nil, repoError)
            } else {
                callback(nil, RepoError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func updateCustomerDefaultAddress(with token: String, addressId: String, callback: @escaping RepoCallback<Bool>) {
        let query = customerUpdateDefaultAddressQuery(customerAccessToken: token, addressId: addressId)
        let task = client?.mutateGraphWith(query, completionHandler: { (result, error) in
            if result != nil {
                callback(true, nil)
            } else if let repoError = RepoError(with: error) {
                callback(false, repoError)
            } else {
                callback(false, RepoError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func updateCustomerAddress(with token: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        let query = customerAddressUpdateQuery(customerAccessToken: token, address: address)
        let task = client?.mutateGraphWith(query, completionHandler: { (result, error) in
            if result?.customerAddressUpdate?.customerAddress != nil {
                callback(true, nil)
            } else if let repoError = RepoError(with: error) {
                callback(false, repoError)
            } else {
                callback(false, RepoError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func deleteCustomerAddress(with token: String, addressId: String, callback: @escaping RepoCallback<Bool>) {
        let query = customerAddressDeleteQuery(addressId: addressId, token: token)
        let task = client?.mutateGraphWith(query, completionHandler: { (result, error) in
            if result?.customerAddressDelete?.deletedCustomerAddressId != nil {
                callback(true, nil)
            } else if let repoError = RepoError(with: error) {
                callback(false, repoError)
            } else {
                callback(false, RepoError())
            }
        })
        run(task: task, callback: callback)
    }
    
    private func getOrderList(with token: String, perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
        let query = Storefront.buildQuery { $0
            .customer(customerAccessToken: token) { $0
                .orders(first: Int32(perPage), after: paginationValue as? String, reverse: true, sortKey: .processedAt) { $0
                    .edges { $0
                        .cursor()
                        .node { $0
                            .id()
                            .currencyCode()
                            .orderNumber()
                            .processedAt()
                            .totalPrice()
                            .lineItems(first: kShopifyItemsMaxCount, self.lineItemConnectionQuery())
                        }
                    }
                }
            }
        }
        let task = client?.queryGraphWith(query) { [weak self] (response, error) in
            var orders = [Order]()
            if let edges = response?.customer?.orders.edges {
                for edge in edges {
                    if let order = Order(with: edge) {
                        orders.append(order)
                    }
                }
            }
            let responseError = self?.process(error: error)
            callback(orders, responseError)
        }
        run(task: task, callback: callback)
    }
    
    // MARK: - sorting
    func productSortValue(for key: SortingValue?) -> Storefront.ProductSortKeys? {
        if key == nil {
            return nil
        }
        switch key! {
        case SortingValue.createdAt:
            return Storefront.ProductSortKeys.createdAt
        case SortingValue.name:
            return Storefront.ProductSortKeys.title
        case SortingValue.popular:
            return Storefront.ProductSortKeys.relevance
        }
    }
    
    func productCollectionSortValue(for key: SortingValue?) -> Storefront.ProductCollectionSortKeys? {
        if key == nil {
            return nil
        }
        switch key! {
        case SortingValue.createdAt:
            return Storefront.ProductCollectionSortKeys.created
        case SortingValue.name:
            return Storefront.ProductCollectionSortKeys.title
        case SortingValue.popular:
            return Storefront.ProductCollectionSortKeys.relevance
        }
    }
    
    // MARK: - queries building
    private func productsListQuery(with perPage: Int, after: Any?, searchPhrase: String?, sortBy: SortingValue?, reverse: Bool) -> Storefront.QueryRootQuery {
        let sortKey = productSortValue(for: sortBy)
        
        return Storefront.buildQuery { $0
            .shop { $0
                .name()
                .paymentSettings(self.paymentSettingsQuery())
                .products(first: Int32(perPage), after: after as? String, reverse: reverse, sortKey: sortKey, query: searchPhrase, self.productConnectionQuery())
            }
        }
    }
    
    private func productDetailsQuery(id: String) -> Storefront.QueryRootQuery {
        let nodeId = GraphQL.ID(rawValue: id)
        return Storefront.buildQuery({ $0
            .shop({ $0
                .paymentSettings(self.paymentSettingsQuery())
            })
            .node(id: nodeId, { $0
                .onProduct(subfields: self.productQuery(additionalInfoNedded: true))
            })
        })
    }
    
    private func categoryListQuery(perPage: Int, after: Any?, sortBy: SortingValue?, reverse: Bool) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery({ $0
            .shop({ $0
                .paymentSettings(self.paymentSettingsQuery())
                .collections(first: Int32(perPage), self.collectionConnectionQuery(perPage: perPage, after: after, sortBy: sortBy, reverse: reverse))
            })
        })
    }
    
    private func categoryDetailsQuery(id: String, perPage: Int, after: Any?, sortBy: SortingValue?, reverse: Bool) -> Storefront.QueryRootQuery {
        let nodeId = GraphQL.ID(rawValue: id)
        return Storefront.buildQuery { $0
            .shop({ $0
                .paymentSettings(self.paymentSettingsQuery())
            })
            .node(id: nodeId, { $0
                .onCollection(subfields: self.collectionQuery(perPage: perPage, after: after, sortBy: sortBy, reverse: reverse, productsNeeded: true))
            })
        }
    }
    
    private func articleListQuery(perPage: Int, after: Any?, reverse: Bool) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery({ $0
            .shop({ $0
                .articles(first: Int32(perPage), after: after as? String, reverse: reverse, self.articleConnectionQuery())
            })
        })
    }
    
    private func articleRootQuery(id: String) -> Storefront.QueryRootQuery {
        let nodeId = GraphQL.ID(rawValue: id)
        return Storefront.buildQuery({ $0
            .node(id: nodeId, { $0
                .onArticle(subfields: self.articleQuery())
            })
        })
    }
    
    private func signUpQuery(email: String, password: String, firstName: String?, lastName: String?, phone: String?) -> Storefront.MutationQuery {
        let input = Storefront.CustomerCreateInput.create(email: email, password: password)
        input.firstName = Input<String>(orNull: firstName)
        input.lastName = Input<String>(orNull: lastName)
        input.phone = Input<String>(orNull: phone)
        return Storefront.buildMutation({ $0
            .customerCreate(input: input, { $0
                .customer(self.customerQuery())
                .userErrors(self.userErrorQuery())
            })
        })
    }
    
    private func tokenQuery(email: String, password: String) -> Storefront.MutationQuery {
        let input = Storefront.CustomerAccessTokenCreateInput.create(email: email, password: password)
        return Storefront.buildMutation({ $0
            .customerAccessTokenCreate(input: input, { $0
                .customerAccessToken(self.accessTokenQuery())
                .userErrors(self.userErrorQuery())
            })
        })
    }
    
    private func resetPasswordQuery(email: String) -> Storefront.MutationQuery {
        return Storefront.buildMutation({ $0
            .customerRecover(email: email, { $0
                .userErrors(self.userErrorQuery())
            })
        
        })
    }
    
    private func customerQuery(with accessToken: String) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery({ $0
            .customer(customerAccessToken: accessToken, self.customerQuery())
        })
    }
    
    private func checkoutCreateQuery(cartProducts: [CartProduct]) -> Storefront.MutationQuery {
        return Storefront.buildMutation({ $0
            .checkoutCreate(input: self.checkoutInput(cartProducts: cartProducts), self.checkoutCreatePayloadQuery())
        })
    }
    
    private func checkoutGetQuery(with checkoutId: String) -> Storefront.QueryRootQuery {
        let id = GraphQL.ID.init(rawValue: checkoutId)
        return Storefront.buildQuery({ $0
            .node(id: id, { $0
                .onCheckout(subfields: self.checkoutQuery())
            })
        })
    }
    
    private func checkoutInput(cartProducts: [CartProduct]) -> Storefront.CheckoutCreateInput {
        let checkout = Storefront.CheckoutCreateInput.create()
        checkout.lineItems = Input<[Storefront.CheckoutLineItemInput]>(orNull: checkoutLineItemInput(cartProducts: cartProducts))
        return checkout
    }
    
    private func checkoutLineItemInput(cartProducts: [CartProduct]) -> [Storefront.CheckoutLineItemInput] {
        var inputs = [Storefront.CheckoutLineItemInput]()
        for product in cartProducts {
            let productId = GraphQL.ID.init(rawValue: product.productVariant?.id ?? "")
            inputs.append(Storefront.CheckoutLineItemInput.create(quantity: Int32(product.quantity), variantId: productId))
        }
        return inputs
    }
    
    private func cardVaultUrlQuery() -> Storefront.QueryRootQuery {
        return Storefront.buildQuery({ $0
            .shop { $0
                .paymentSettings({ $0
                    .cardVaultUrl()
                })
            }
        })
    }
    
    private func updateShippingAddressQuery(shippingAddress: Storefront.MailingAddressInput, checkoutId: GraphQL.ID) -> Storefront.MutationQuery {
        return Storefront.buildMutation { $0
            .checkoutShippingAddressUpdate(shippingAddress: shippingAddress, checkoutId: checkoutId, { $0
                .checkout({ $0
                    .ready()
                    .shippingLine({ $0
                        .price()
                    })
                })
            })
        }
    }
    
    private func customerUpdateDefaultAddressQuery(customerAccessToken: String, addressId: String) -> Storefront.MutationQuery {
        let id = GraphQL.ID.init(rawValue: addressId)
        return Storefront.buildMutation({ $0
            .customerDefaultAddressUpdate(customerAccessToken: customerAccessToken, addressId: id, self.customerDefaultAddressUpdatePayloadQuery())
        })
    }
    
    private func customerAddressCreateQuery(customerAccessToken: String, address: Address) -> Storefront.MutationQuery {
        let addressInput = Storefront.MailingAddressInput.create()
        addressInput.update(with: address)
        return Storefront.buildMutation({ $0
            .customerAddressCreate(customerAccessToken: customerAccessToken, address: addressInput, self.customerAddressCreatePayloadQuery())
        })
    }
    
    private func customerAddressUpdateQuery(customerAccessToken: String, address: Address) -> Storefront.MutationQuery {
        let addressId = GraphQL.ID.init(rawValue: address.id)
        let addressInput = Storefront.MailingAddressInput.create()
        addressInput.update(with: address)
        return Storefront.buildMutation({ $0
            .customerAddressUpdate(customerAccessToken: customerAccessToken, id: addressId, address: addressInput, self.customerAddressUpdatePayloadQuery())
        })
    }
    
    private func customerAddressDeleteQuery(addressId: String, token: String) -> Storefront.MutationQuery {
        let id = GraphQL.ID.init(rawValue: addressId)
        return Storefront.buildMutation({ $0
            .customerAddressDelete(id: id, customerAccessToken: token, self.customerAddressDeletePayloadQuery())
        })
    }
    
    private func getShippingRatesQuery(checkoutId: GraphQL.ID) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery { $0
            .node(id: checkoutId) { $0
                .onCheckout { $0
                    .id()
                    .availableShippingRates { $0
                        .ready()
                        .shippingRates { $0
                            .title()
                            .price()
                            .handle()
                        }
                    }
                }
            }
        }
    }
    
    private func updateShippingLineQuery(checkoutId: GraphQL.ID, shippingRateHandle: String) -> Storefront.MutationQuery {
        return Storefront.buildMutation { $0
            .checkoutShippingLineUpdate(checkoutId: checkoutId, shippingRateHandle: shippingRateHandle, { $0
                .checkout(self.checkoutQuery())
                .userErrors(self.userErrorQuery())
            })
        }
    }
    
    private func completePayQuery(checkoutId: GraphQL.ID, paymentInput: Storefront.CreditCardPaymentInput) -> Storefront.MutationQuery {
        return Storefront.buildMutation { $0
            .checkoutCompleteWithCreditCard(checkoutId: checkoutId, payment: paymentInput, { $0
                .payment({ $0
                    .ready()
                    .errorMessage()
                })
                .checkout({ $0
                    .ready()
                })
                .userErrors(self.userErrorQuery())
            })
        }
    }
    
    // MARK: - subqueries
    private func productConnectionQuery() -> (Storefront.ProductConnectionQuery) -> Void {
        return { (query: Storefront.ProductConnectionQuery) in
            query.edges({ $0
                .cursor()
                .node(self.productQuery())
            })
        }
    }
    
    private func productQuery(additionalInfoNedded: Bool = false) -> (Storefront.ProductQuery) -> Void {
        let imageCount = additionalInfoNedded ? kShopifyItemsMaxCount : 1
        let variantsCount = additionalInfoNedded ? kShopifyItemsMaxCount : 1
        
        return { (query: Storefront.ProductQuery) in
            query.id()
            query.title()
            query.description()
            query.descriptionHtml()
            query.vendor()
            query.productType()
            query.createdAt()
            query.updatedAt()
            query.tags()
            query.images(first: imageCount, self.imageConnectionQuery())
            query.variants(first: variantsCount, self.variantConnectionQuery())
            query.options(self.optionQuery())
        }
    }
    
    private func shortProductQuery() -> (Storefront.ProductQuery) -> Void {        
        return { (query: Storefront.ProductQuery) in
            query.id()
            query.images(first: 1, self.imageConnectionQuery())
        }
    }
    
    private func imageConnectionQuery() -> (Storefront.ImageConnectionQuery) -> Void {
        return { (query: Storefront.ImageConnectionQuery) in
            query.edges({ $0
                .node(self.imageQuery())
            })
        }
    }
    
    private func imageQuery() -> (Storefront.ImageQuery) -> Void {
        return { (query: Storefront.ImageQuery) in
            query.id()
            query.src()
            query.altText()
        }
    }
    
    private func variantConnectionQuery() -> (Storefront.ProductVariantConnectionQuery) -> Void {
        return { (query: Storefront.ProductVariantConnectionQuery) in
            query.edges({ $0
                .node(self.productVariantQuery())
            })
        }
    }
    
    private func productVariantQuery() -> (Storefront.ProductVariantQuery) -> Void {
        return { (query: Storefront.ProductVariantQuery) in
            query.id()
            query.title()
            query.price()
            query.availableForSale()
            query.image(self.imageQuery())
            query.selectedOptions(self.selectedOptionQuery())
        }
    }
    
    private func productVariantWithShortProductQuery() -> (Storefront.ProductVariantQuery) -> Void {
        return { (query: Storefront.ProductVariantQuery) in
            query.id()
            query.title()
            query.price()
            query.availableForSale()
            query.image(self.imageQuery())
            query.selectedOptions(self.selectedOptionQuery())
            query.product(self.shortProductQuery())
        }
    }
    
    private func collectionConnectionQuery(perPage: Int, after: Any?, sortBy: SortingValue?, reverse: Bool) -> (Storefront.CollectionConnectionQuery) -> Void {
        return { (query: Storefront.CollectionConnectionQuery) in
            query.edges({ $0
                .cursor()
                .node(self.collectionQuery(perPage: perPage, after: after, sortBy: sortBy, reverse: reverse))
            })
            
        }
    }
    
    private func collectionQuery(perPage: Int = 0, after: Any? = nil, sortBy: SortingValue?, reverse: Bool, productsNeeded: Bool = false) -> (Storefront.CollectionQuery) -> Void {
        let sortKey = productCollectionSortValue(for: sortBy)
        return { (query: Storefront.CollectionQuery) in
            query.id()
            query.title()
            query.description()
            query.updatedAt()
            query.image(self.imageQuery())
            if productsNeeded {
                query.products(first: Int32(perPage), after: after as? String, reverse: reverse, sortKey: sortKey, self.productConnectionQuery())
            }
            if perPage > 0 {
                query.descriptionHtml()
            }
        }
    }
    
    private func policyQuery() -> (Storefront.ShopPolicyQuery) -> Void {
        return { (query: Storefront.ShopPolicyQuery) in
            query.title()
            query.body()
            query.url()
        }
    }
    
    private func articleConnectionQuery() -> (Storefront.ArticleConnectionQuery) -> Void {
        return { (query: Storefront.ArticleConnectionQuery) in
            query.edges({ $0
                .node(self.articleQuery())
                .cursor()
            })
        }
    }
    
    private func articleQuery() -> (Storefront.ArticleQuery) -> Void {
        return { (query: Storefront.ArticleQuery) in
            query.id()
            query.title()
            query.content()
            query.image(self.imageQuery())
            query.author(self.authorQuery())
            query.tags()
            query.blog(self.blogQuery())
            query.publishedAt()
            query.url()
        }
    }
    
    private func authorQuery() -> (Storefront.ArticleAuthorQuery) -> Void {
        return { (query: Storefront.ArticleAuthorQuery) in
            query.firstName()
            query.lastName()
            query.name()
            query.email()
            query.bio()
        }
    }
    
    private func blogQuery() -> (Storefront.BlogQuery) -> Void {
        return { (query: Storefront.BlogQuery) in
            query.id()
            query.title()
        }
    }
    
    private func optionQuery() -> (Storefront.ProductOptionQuery) -> Void {
        return { (query: Storefront.ProductOptionQuery) in
            query.id()
            query.name()
            query.values()
        }
    }
    
    private func paymentSettingsQuery() -> (Storefront.PaymentSettingsQuery) -> Void {
        return { (query: Storefront.PaymentSettingsQuery) in
            query.currencyCode()
        }
    }
    
    private func selectedOptionQuery() -> (Storefront.SelectedOptionQuery) -> Void {
        return { (query: Storefront.SelectedOptionQuery) in
            query.name()
            query.value()
        }
    }
    
    private func customerQuery() -> (Storefront.CustomerQuery) -> Void {
        return { (query: Storefront.CustomerQuery) in
            query.email()
            query.firstName()
            query.lastName()
            query.phone()
            query.defaultAddress(self.mailingAddressQuery())
            query.addresses(first: kShopifyItemsMaxCount, self.mailingAddressConnectionQuery())
        }
    }
    
    private func userErrorQuery() -> (Storefront.UserErrorQuery) -> Void {
        return { (query: Storefront.UserErrorQuery) in
            query.message()
            query.field()
        }
    }
    
    private func accessTokenQuery() -> (Storefront.CustomerAccessTokenQuery) -> Void {
        return { (query) in
            query.accessToken()
            query.expiresAt()
        }
    }
    
    private func checkoutCreatePayloadQuery() -> (Storefront.CheckoutCreatePayloadQuery) -> Void {
        return { (query) in
            query.checkout(self.checkoutQuery())
            query.userErrors(self.userErrorQuery())
        }
    }
    
    private func checkoutQuery() -> (Storefront.CheckoutQuery) -> Void {
        return { (query) in
            query.id()
            query.webUrl()
            query.currencyCode()
            query.subtotalPrice()
            query.totalPrice()
            query.shippingAddress(self.mailingAddressQuery())
        }
    }
    
    private func mailingAddressConnectionQuery() -> (Storefront.MailingAddressConnectionQuery) -> Void {
        return { (query) in
            query.edges(self.mailingAddressEdgeQuery())
        }
    }
    
    private func mailingAddressEdgeQuery() -> (Storefront.MailingAddressEdgeQuery) -> Void {
        return { (query) in
            query.node(self.mailingAddressQuery())
        }
    }
    
    private func mailingAddressQuery() -> (Storefront.MailingAddressQuery) -> Void {
        return { (query) in
            query.id()
            query.country()
            query.firstName()
            query.lastName()
            query.address1()
            query.address2()
            query.city()
            query.province()
            query.zip()
            query.phone()
        }
    }
    
    private func customerDefaultAddressUpdatePayloadQuery() -> (Storefront.CustomerDefaultAddressUpdatePayloadQuery) -> Void {
        return { (query: Storefront.CustomerDefaultAddressUpdatePayloadQuery) in
            query.customer(self.customerQuery())
        }
    }
    
    private func customerAddressCreatePayloadQuery() -> (Storefront.CustomerAddressCreatePayloadQuery) -> Void {
        return { (query) in
            query.customerAddress(self.mailingAddressQuery())
            query.userErrors(self.userErrorQuery())
        }
    }
    
    private func customerAddressUpdatePayloadQuery() -> (Storefront.CustomerAddressUpdatePayloadQuery) -> Void {
        return { (query) in
            query.customerAddress(self.mailingAddressQuery())
            query.userErrors(self.userErrorQuery())
        }
    }
    
    private func customerAddressDeletePayloadQuery() -> (Storefront.CustomerAddressDeletePayloadQuery) -> Void {
        return { (query) in
            query.deletedCustomerAddressId()
            query.userErrors(self.userErrorQuery())
        }
    }
    
    private func lineItemConnectionQuery() -> (Storefront.OrderLineItemConnectionQuery) -> Void {
        return { (query: Storefront.OrderLineItemConnectionQuery) in
            query.edges({ $0
                .node { $0
                    .quantity()
                    .title()
                    .variant(self.productVariantWithShortProductQuery())
                }
            })
        }
    }
    
    // MARK: - session data
    private func saveSessionData(with token: Storefront.CustomerAccessToken, email: String) {
        let keyChain = KeychainSwift(keyPrefix: SessionData.keyPrefix)
        keyChain.set(token.accessToken, forKey: SessionData.accessToken)
        keyChain.set(email, forKey: SessionData.email)
        let expiryString = String(describing: token.expiresAt.timeIntervalSinceNow)
        keyChain.set(expiryString, forKey: SessionData.expiryDate)
    }
    
    private func sessionData() -> (token: String?, email: String?, expiryDate: Date?) {
        let keyChain = KeychainSwift(keyPrefix: SessionData.keyPrefix)
        let token = keyChain.get(SessionData.accessToken)
        let email = keyChain.get(SessionData.email)
        let expiryDateString = keyChain.get(SessionData.expiryDate) ?? ""
        let expiryDateTimeInterval = TimeInterval(expiryDateString) ?? TimeInterval()
        let expiryDate = Date(timeIntervalSinceNow: expiryDateTimeInterval)
        
        return (token, email, expiryDate)
    }
    
    private func removeSessionData() {
        let keyChain = KeychainSwift(keyPrefix: SessionData.keyPrefix)
        keyChain.clear()
    }
    
    func isLoggedIn() -> Bool {
        let keyChain = KeychainSwift(keyPrefix: SessionData.keyPrefix)
        if keyChain.get(SessionData.accessToken) != nil, let expiryDate = keyChain.get(SessionData.expiryDate), keyChain.get(SessionData.email) != nil {
            let date = Date(timeIntervalSinceNow: TimeInterval(expiryDate)!)
            return date > Date()
        }
        return false
    }
    
    // MARK: - check connection network
    private func run<T>(task: Task?, callback: RepoCallback<T>) {
        if ReachabilityNetwork.hasConnection() {
            task?.resume()
        } else {
            callback(nil, NetworkError())
        }
    }
    
    // MARK: - error handling
    private func process(error: Graph.QueryError?) -> RepoError? {
        if let error = error, case .invalidQuery(let reasons) = error {
            return CriticalError(with: error, message: reasons.first?.message)
        }
        
        if let error = error, case .http(let statusCode) = error {
            return process(statusCode: statusCode, error: error)
        }
        
        return RepoError(with: error)
    }
    
    private func process(error: Storefront.UserError?) -> RepoError? {
        return NonCriticalError(with: error)
    }
    
    private func process(statusCode: Int, error: Error) -> RepoError? {
        return CriticalError(with: error, statusCode: statusCode)
    }
}

internal extension Storefront.MailingAddressInput {
    func update(with address: Address) {
        address1 = Input<String>(orNull: address.address)
        address2 = Input<String>(orNull: address.secondAddress)
        city = Input<String>(orNull: address.city)
        country = Input<String>(orNull: address.country)
        firstName = Input<String>(orNull: address.firstName)
        lastName = Input<String>(orNull: address.lastName)
        zip = Input<String>(orNull: address.zip)
        if let phoneItem = address.phone {
            phone = Input<String>(orNull: phoneItem)
        }
    }
}
