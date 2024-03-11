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
    @Published var quote: StockQuote?
    @Published var stockQuoteState: DataState = .idle
    @Published var errorMessage: String?
    @Published var companyOverview: CompanyOverview?
    @Published var dcfValue: Double?
    @Published var triggerUpdate: Bool = false
    @Published var sharePrice: Double?


    var dcfModel = DCFModel()
    private var cancellables = Set<AnyCancellable>()
    private let api: API
    
    init(api: API = API.shared) {
        self.api = api
    }
    
    enum DataState {
        case idle, loading, loaded, error(String)
    }

    // Fetch stock quote
    func fetchStockQuote(forSymbol symbol: String) {
        print("Fetching stock quote for symbol: \(symbol)")
        stockQuoteState = .loading
        api.fetchStockQuote(forSymbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch quote: \(error.localizedDescription)"
                    self?.stockQuoteState = .error(error.localizedDescription)
                    print("Error fetching stock quote: \(error.localizedDescription)")
                }
                self?.stockQuoteState = .loaded
            }, receiveValue: { [weak self] quote in
                self?.quote = quote
                print("Stock quote fetched successfully.")
            })
            .store(in: &cancellables)
    }

    // Fetch company overview data
    func fetchCompanyOverview(forSymbol symbol: String) {
        print("Fetching company overview for symbol: \(symbol)")
        api.fetchCompanyOverview(forSymbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch company overview: \(error.localizedDescription)"
                    print("Error fetching company overview: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] overview in
                self?.companyOverview = overview
                print("Company overview fetched successfully.")
            })
            .store(in: &cancellables)
    }
    
    // Load the fetched DCF Value and update share price 
    func loadDCFValue(forSymbol symbol: String) {
        print("loadDCFValue func triggered for symbol: \(symbol)")
        stockQuoteState = .loading
        
        // Chain publishers for fetching Cash Flow, Income Statement, and Balance Sheet data
        let cashFlowPublisher = api.fetchCashFlowData(forSymbol: symbol).print("CashFlow")
        let incomeStatementPublisher = api.fetchIncomeStatement(forSymbol: symbol).print("IncomeStatement")
        let balanceSheetPublisher = api.fetchBalanceSheet(forSymbol: symbol).print("BalanceSheet")

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

                // Assuming 'annualReports.first' and calculation for freeCashFlow
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
    
    func updateSharePrice() {
        // Set DCF Value
        guard let dcfValue = dcfValue,
              // Parse sharesOutstanding and convert to Double
              let sharesOutstandingStr = companyOverview?.sharesOutstanding,
              let sharesOutstanding = Double(sharesOutstandingStr),
              sharesOutstanding > 0 else {
            print("Error: DCF value not calculated or invalid shares outstanding.")
            return
        }
        
        let dcfSharePrice = dcfValue / sharesOutstanding
        print("Corrected DCF Share Price: \(dcfSharePrice)")
        self.sharePrice = dcfSharePrice
    }
}
