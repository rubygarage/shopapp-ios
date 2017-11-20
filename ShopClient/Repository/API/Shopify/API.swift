//
//  API.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/23/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import KeychainSwift

private let kShopifyStorefrontAccessToken = "b7ec986195fe87de18cb74a09b81ea1d"
private let kShopifyStorefrontURL = "fosox.myshopify.com"
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
            if let _ = response?.customerCreate?.customer {
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
                self?.getCustomer(with: token, email: email, callback: callback)
            } else if let error = error {
                callback(false, error)
            }
        }
    }
    
    // MARK: - checkout
    func getCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        let email = sessionData().email
        let query = checkoutQuery(email: email, cartProducts: cartProducts)
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
    
    // MARK: - private
    private func getToken(with email: String, password: String, callback: @escaping (_ token: Storefront.CustomerAccessToken?, _ error: RepoError?) -> ()) {
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
    
    private func getCustomer(with token: Storefront.CustomerAccessToken, email: String, callback: @escaping RepoCallback<Bool>) {
        let query = customerQuery(with: token.accessToken)
        let task = client?.queryGraphWith(query, completionHandler: { [weak self] (response, error) in
            if let _ = response?.customer {
                self?.saveSessionData(with: token, email: email)
                callback(true, nil)
            } else if let responseError = error {
                callback(false, RepoError(with: responseError))
            } else {
                callback(false, RepoError())
            }
        })
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
    
    private func articleRootQuery(id: String) -> (Storefront.QueryRootQuery) {
        let nodeId = GraphQL.ID(rawValue: id)
        return Storefront.buildQuery({ $0
            .node(id: nodeId, { $0
                .onArticle(subfields: self.articleQuery())
            })
        })
    }
    
    // MARK: - subqueries
    private func productConnectionQuery() -> ((Storefront.ProductConnectionQuery) -> ()) {
        return { (query: Storefront.ProductConnectionQuery) in
            query.edges({ $0
                .cursor()
                .node(self.productQuery())
            })
        }
    }
    
    private func productQuery(additionalInfoNedded: Bool = false) -> ((Storefront.ProductQuery) -> ()) {
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
    
    private func imageConnectionQuery() -> ((Storefront.ImageConnectionQuery) -> ()) {
        return { (query: Storefront.ImageConnectionQuery) in
            query.edges({ $0
                .node(self.imageQuery())
            })
        }
    }
    
    private func imageQuery() -> ((Storefront.ImageQuery) -> ()) {
        return { (query: Storefront.ImageQuery) in
            query.id()
            query.src()
            query.altText()
        }
    }
    
    private func variantConnectionQuery() -> ((Storefront.ProductVariantConnectionQuery) -> ()) {
        return { (query: Storefront.ProductVariantConnectionQuery) in
            query.edges({ $0
                .node(self.productVariantQuery())
            })
        }
    }
    
    private func productVariantQuery() -> ((Storefront.ProductVariantQuery) -> ()) {
        return { (query: Storefront.ProductVariantQuery) in
            query.id()
            query.title()
            query.price()
            query.availableForSale()
            query.image(self.imageQuery())
            query.selectedOptions(self.selectedOptionQuery())
        }
    }
    
    private func collectionConnectionQuery(perPage: Int, after: Any?, sortBy: SortingValue?, reverse: Bool) -> ((Storefront.CollectionConnectionQuery) -> ()) {
        return { (query: Storefront.CollectionConnectionQuery) in
            query.edges({ $0
                .cursor()
                .node(self.collectionQuery(perPage: perPage, after: after, sortBy: sortBy, reverse: reverse))
            })
            
        }
    }
    
    private func collectionQuery(perPage: Int = 0, after: Any? = nil, sortBy: SortingValue?, reverse: Bool, productsNeeded: Bool = false) -> ((Storefront.CollectionQuery) -> ()) {
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
    
    private func policyQuery() -> ((Storefront.ShopPolicyQuery) -> ()) {
        return { (query: Storefront.ShopPolicyQuery) in
            query.title()
            query.body()
            query.url()
        }
    }
    
    private func articleConnectionQuery() -> ((Storefront.ArticleConnectionQuery) -> ()) {
        return { (query: Storefront.ArticleConnectionQuery) in
            query.edges({ $0
                .node(self.articleQuery())
                .cursor()
            })
        }
    }
    
    private func articleQuery() -> ((Storefront.ArticleQuery) -> ()) {
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
    
    private func authorQuery() -> ((Storefront.ArticleAuthorQuery) -> ()) {
        return { (query: Storefront.ArticleAuthorQuery) in
            query.firstName()
            query.lastName()
            query.name()
            query.email()
            query.bio()
        }
    }
    
    private func blogQuery() -> ((Storefront.BlogQuery) -> ()) {
        return { (query: Storefront.BlogQuery) in
            query.id()
            query.title()
        }
    }
    
    private func optionQuery() -> ((Storefront.ProductOptionQuery) -> ()) {
        return { (query: Storefront.ProductOptionQuery) in
            query.id()
            query.name()
            query.values()
        }
    }
    
    private func paymentSettingsQuery() -> (Storefront.PaymentSettingsQuery) -> () {
        return { (query: Storefront.PaymentSettingsQuery) in
            query.currencyCode()
        }
    }
    
    private func selectedOptionQuery() -> (Storefront.SelectedOptionQuery) -> () {
        return { (query: Storefront.SelectedOptionQuery) in
            query.name()
            query.value()
        }
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
    
    private func customerQuery() -> (Storefront.CustomerQuery) -> ()  {
        return { (query: Storefront.CustomerQuery) in
            query.email()
            query.firstName()
            query.lastName()
            query.phone()
        }
    }
    
    private func userErrorQuery() -> (Storefront.UserErrorQuery) -> () {
        return { (query: Storefront.UserErrorQuery) in
            query.message()
            query.field()
        }
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
    
    private func accessTokenQuery() -> (Storefront.CustomerAccessTokenQuery) -> () {
        return { (query) in
            query.accessToken()
            query.expiresAt()
        }
    }
    
    private func customerQuery(with accessToken: String) -> Storefront.QueryRootQuery {
        return Storefront.buildQuery({ $0
            .customer(customerAccessToken: accessToken, self.customerQuery())
        })
    }
    
    private func checkoutQuery(email: String?, cartProducts: [CartProduct]) -> Storefront.MutationQuery {
        return Storefront.buildMutation({ $0
            .checkoutCreate(input: self.checkoutInput(email: email, cartProducts: cartProducts), self.checkoutCreatePayloadQuery())
        })
    }
    
    private func checkoutInput(email: String?, cartProducts: [CartProduct]) -> Storefront.CheckoutCreateInput {
        let checkout = Storefront.CheckoutCreateInput.create()
        checkout.email = Input<String>(orNull: email)
        checkout.lineItems = Input<[Storefront.CheckoutLineItemInput]>(orNull: checkoutLineItemInput(cartProducts: cartProducts))
        
        return checkout
    }
    
    private func checkoutLineItemInput(cartProducts: [CartProduct]) -> [Storefront.CheckoutLineItemInput] {
        var inputs = [Storefront.CheckoutLineItemInput]()
        for product in cartProducts {
            let productId = GraphQL.ID.init(rawValue: product.productVariant?.id ?? String())
            inputs.append(Storefront.CheckoutLineItemInput.create(quantity: Int32(product.quantity), variantId: productId))
        }
        return inputs
    }
    
    private func checkoutCreatePayloadQuery() -> (Storefront.CheckoutCreatePayloadQuery) -> () {
        return { (query) in
            query.checkout(self.checkoutQuery())
            query.userErrors(self.userErrorQuery())
        }
    }
    
    private func checkoutQuery() -> (Storefront.CheckoutQuery) -> () {
        return { (query) in
            query.id()
            query.webUrl()
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
        let expiryDateString = keyChain.get(SessionData.expiryDate) ?? String()
        let expiryDateTimeInterval = TimeInterval(expiryDateString)
        let expiryDate = Date(timeIntervalSinceNow: expiryDateTimeInterval!)
        
        return (token, email, expiryDate)
    }
    
    func isLoggedIn() -> Bool {
        let keyChain = KeychainSwift(keyPrefix: SessionData.keyPrefix)
        if let _ = keyChain.get(SessionData.accessToken), let expiryDate = keyChain.get(SessionData.expiryDate), let _ = keyChain.get(SessionData.email) {
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
