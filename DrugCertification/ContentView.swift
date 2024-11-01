//
//  ContentView.swift
//  DrugCertification
//
//  Created by 植松優羽 on 2024/11/01.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String = "スキャン結果はここに表示されます"

    var body: some View {
        VStack {
            Text(scannedCode)
                .padding()
                .font(.headline)

            BarcodeScannerView { code in
                self.scannedCode = "コード内容: \(code)"
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView()
}
