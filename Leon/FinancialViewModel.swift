//
//  FinancialViewModel.swift
//  Leon
//
//  Created by Kevin Downey on 1/19/24.
//

import FirebaseAuth
import Foundation
import Combine

class FinancialViewModel: ObservableObject {
    @Published var symbol: String = "" // Holds the symbol input by the user
    @Published var dcfSharePrice: Double? // Holds the calculated DCF share price
    @Published var quote: StockQuote? = nil
    @Published var stockQuoteState: DataState = .idle
    @Published var errorMessage: String? = nil
    @Published var companyOverview: CompanyOverview? = nil
    @Published var dcfValue: Double? = nil
    @Published var triggerUpdate: Bool = false
    @Published var sharePrice: Double? = nil
    @Published var newsFeed: [NewsArticle] = []
    @Published var trendingStocks: [Stock] = []
    @Published var topGainers: [Stock] = []
    @Published var topLosers: [Stock] = []
    @Published var readyToShowFinancialDetails = false

    
    var dcfModel = DCFModel()
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    enum DataState {
        case idle, loading, loaded, error(String)
    }
    
    // Fetch financial data
    
    func fetchFinancialData(forSymbol symbol: String) {
        guard !symbol.isEmpty else {
            print("Error: Symbol is empty")
            return
        }
        let quotePublisher = apiService.fetchStockQuote(forSymbol: symbol)
            .map { $0.globalQuote }
            .mapError { $0 as Error }
        
        let overviewPublisher = apiService.fetchCompanyOverview(forSymbol: symbol)
            .mapError { $0 as Error }
        
        // Chain API calls
        Publishers.Zip(quotePublisher, overviewPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("Fetched financial data successfully.")
                }
            }, receiveValue: { [weak self] (quote, overview) in
                self?.quote = quote
                self?.companyOverview = overview
                self?.readyToShowFinancialDetails = true
            })
            .store(in: &cancellables)
    }
    private func handleError(_ error: Error) {
        self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        // Consider additional steps like retrying or providing user feedback
    }
    
    
    func fetchStockQuote(forSymbol symbol: String) -> AnyPublisher<StockQuote, Error> {
        apiService.fetchStockQuote(forSymbol: symbol)
            .map { $0.globalQuote }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchCompanyOverview(forSymbol symbol: String) -> AnyPublisher<CompanyOverview, Error> {
        apiService.fetchCompanyOverview(forSymbol: symbol)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    
    // Load the fetched DCF Value and update share price
    func loadDCFValue() {
        guard !self.symbol.isEmpty else {
            print("Error: Symbol is empty")
            return
        }
            stockQuoteState = .loading
            
            // Chain publishers for fetching Cash Flow, Income Statement, and Balance Sheet data
            let cashFlowPublisher = apiService.fetchCashFlowData(forSymbol: symbol).print("CashFlow")
            let incomeStatementPublisher = apiService.fetchIncomeStatement(forSymbol: symbol).print("IncomeStatement")
            let balanceSheetPublisher = apiService.fetchBalanceSheet(forSymbol: symbol).print("BalanceSheet")
            
            Publishers.Zip3(cashFlowPublisher, incomeStatementPublisher, balanceSheetPublisher)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = "Failed to fetch financial data: \(error.localizedDescription)"
                        self?.stockQuoteState = .error(error.localizedDescription)
                        print("Error fetching financial data: \(error.localizedDescription)")
                    } else {
                        self?.stockQuoteState = .loaded
                        print("Financial data fetched successfully.")
                    }
                }, receiveValue: { [weak self] cashFlowData, incomeStatementData, balanceSheetData in
                    guard let self = self else { return }
                    print("Processing fetched financial data for DCF calculation...")
                    
                    guard let cashFlowReport = cashFlowData.annualReports.first,
                          let latestIncomeReport = incomeStatementData.annualReports.first,
                          let latestBalanceSheet = balanceSheetData.annualReports.first,
                          let operatingCashFlow = Double(cashFlowReport.operatingCashflow),
                          let capitalExpenditures = Double(cashFlowReport.capitalExpenditures) else {
                        print("Error: Latest financial reports not found or data missing.")
                        return
                    }
                    
                    let freeCashFlow = operatingCashFlow - capitalExpenditures
                    
                    guard let netIncome = Double(latestIncomeReport.netIncome),
                          let longTermDebt = Double(latestBalanceSheet.longTermDebt),
                          let cashAndEquivalents = Double(latestBalanceSheet.cashAndCashEquivalentsAtCarryingValue) else {
                        print("Error converting financial data to Double.")
                        return
                    }
                    
                    // Perform DCF calculation using your dcfModel's method, ensure it accepts the correct parameters
                    let calculatedDCFValue = self.dcfModel.calculateDCF(
                        freeCashFlow: freeCashFlow,
                        netIncome: netIncome,
                        longTermDebt: longTermDebt,
                        cashAndEquivalents: cashAndEquivalents
                    )
                    
                    print("Calculated DCF Value: \(calculatedDCFValue)")
                    self.dcfValue = calculatedDCFValue
                    
                    // After successfully calculating the DCF value, call updateSharePrice to calculate and update the share price
                    self.updateSharePrice()
                })
                .store(in: &cancellables)
        }
        
    // Update DCF share price with calculated value
    func updateSharePrice() {
        guard let dcfValue = dcfValue,
              let sharesOutstandingStr = companyOverview?.sharesOutstanding,
              let sharesOutstanding = Double(sharesOutstandingStr),
              sharesOutstanding > 0 else {
            print("Error: DCF value not calculated or invalid shares outstanding.")
            return
        }
        
        let calculatedDcfSharePrice = dcfValue / sharesOutstanding
        print("Updated DCF Share Price: \(calculatedDcfSharePrice)")
        // Update the @Published property that your UI observes
        self.dcfSharePrice = calculatedDcfSharePrice
    }
        
    // Fetch news feed
    
    func loadNewsFeed(forSymbol symbol: String) {
        apiService.fetchNewsFeed(forSymbol: symbol)
            .sink(receiveCompletion: { completion in
                print(completion) // Debug completion
            }, receiveValue: { [weak self] newsFeed in
                self?.newsFeed = newsFeed.feed
                print("News feed updated with \(newsFeed.feed.count) articles.")
            })
            .store(in: &cancellables)
    }
    
    func loadTrendingStocks() {
        apiService.fetchTrendingStocks()
            .sink(receiveCompletion: { completion in
                // Handle completion
            }, receiveValue: { [weak self] response in
                // Limiting to 5 items for each category
                self?.topGainers = Array(response.topGainers.prefix(2))
                self?.topLosers = Array(response.topLosers.prefix(2))
            })
            .store(in: &cancellables)
    }
}


