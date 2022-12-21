//
//  TransactionView.swift
//  metamask-ios-sdk_Example
//

import SwiftUI
import Combine
import metamask_ios_sdk

struct TransactionView: View {
    @ObservedObject var ethereum: Ethereum = Ethereum.shared
    
    @State private var amount = "0x0"
    @State var result: String = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var to = "0xd0059fB234f15dFA9371a7B45c09d451a2dd2B5a"
    
    var body: some View {
        Form {
            Section {
                Text("From")
                    .font(.callout)
                TextEditor(text: $ethereum.selectedAddress)
                    .modifier(TextCaption())
                    .frame(minHeight: 32)
                    .modifier(TextCurvature())
            }
            
            Section {
                Text("To")
                    .font(.callout)
                TextEditor(text: $to)
                    .modifier(TextCaption())
                    .frame(minHeight: 32)
                    .modifier(TextCurvature())
                
            }
            
            Section {
                Text("Amount")
                    .font(.callout)
                TextEditor(text: $amount)
                    .modifier(TextCaption())
                    .frame(minHeight: 32)
                    .modifier(TextCurvature())
            }
            
            Section {
                Text("Result")
                    .font(.callout)
                TextEditor(text: $result)
                    .modifier(TextCaption())
                    .frame(minHeight: 40)
                    .modifier(TextCurvature())
            }
            
            Section {
                Button {
                    sendTransaction()
                } label: {
                    Text("Send Transaction")
                        .frame(maxWidth: .infinity, maxHeight: 32)
                }
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Authorization Error"),
                        message: Text(errorMessage)
                    )
                }
                .font(.title3)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.blue.grayscale(0.5))
                .modifier(ButtonCurvature())
            }
        }
        .background(Color.blue.grayscale(0.5))
    }
    
    func sendTransaction() {
        let transaction = Transaction(
            to: to,
            from: ethereum.selectedAddress,
            value: "0x0")
        
        let transactionRequest = EthereumRequest(
            method: .sendTransaction,
            params: [transaction])
        
        ethereum.request(transactionRequest)?.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                errorMessage = error.localizedDescription
                showError = true
                print("Transaction error: \(errorMessage)")
            default: break
            }
        }, receiveValue: { value in
            self.result = value
        }).store(in: &cancellables)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
