//
//  ContentView.swift
//  DrugCertification
//
//  Created by 植松優羽 on 2024/11/05.
//


import SwiftUI
import WebKit

struct ContentView: View {
    @State private var isAuthenticated = true // テスト用にtrue
    @State private var showDatePicker = false
    @State private var recordDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @State var isShowAlert = false
    @State private var patientName = ""
    @State private var patientID = ""
    @State private var medicineName = ""
    @State private var medicineID = ""
    @State private var setting = Setting.title
    @Binding var receivedData: String? // Webアプリから受け取ったデータ
    @State private var showWebView = false // WebViewの表示状態
    
    enum Setting {
        case title
        case drugAuth
        case patientAuth
        case scanned
        case finished
    }
    
    var body: some View {
        switch setting {
            
        case .title:
            VStack {
                Text("薬剤認証")
                    .font(.title)
                    .padding()
                
                Button("認証開始") {
                    // 認証が完了したら画面を切り替え
                    setting = .drugAuth
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
        case .drugAuth:
            VStack {
                HStack {
                    Button(action: {
                        setting = .title
                    }) {
                        Text("戻る")
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        setting = .patientAuth
                    }) {
                        Text("次へ")
                    }
                }
                .padding(.top)
                
                if showWebView {
                    WebView(urlString: "https://dh24-nurceapi.azurewebsites.net/")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    if let data = receivedData {
                        Text("受信したデータ: \(data)")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.black)
                    } else {
                        Text("データを受信していません")
                            .padding()
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                showWebView = true
            }
            .onReceive(NotificationCenter.default.publisher(for: .didReceiveWebData)) { notification in
                if let data = notification.object as? String {
                    receivedData = data
                    showWebView = false // WebViewを閉じる
                    
                    // 1秒後に次の処理を実行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        setting = .patientAuth
                    }
                }
            }
            
        case .patientAuth:
            VStack {
                HStack {
                    Button(action: {
                        setting = .drugAuth
                    }) {
                        Text("戻る")
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        setting = .scanned
                    }) {
                        Text("次へ")
                    }
                }
                .padding(.top)
                
                Text("ここで患者のコードを読み取る")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("本来は読み取った時点で次へ進む")
                    Image("keirou_couple2")
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                .padding()
            }
            .onAppear {
                patientName = "山田 太郎"
                patientID = "3849872"
            }
            
        case .scanned:
            VStack {
                HStack {
                    Button(action: {
                        setting = .patientAuth
                    }) {
                        Text("戻る")
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        isShowAlert = true
                    } label: {
                        Label("投与完了する", systemImage: "pencil.and.outline")
                    }
                    .alert("本当に完了しますか？", isPresented: $isShowAlert) {
                        Button("No") {}
                        Button("Yes") {
                            setting = .finished
                        }
                    } message: {
                        Text("本当に？？")
                    }
                }
                .padding(.top)
                
                Text("薬剤投与前最終確認")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("記録日:")
                            Text("\(formattedDate(recordDate))")
                                .onTapGesture {
                                    withAnimation {
                                        showDatePicker.toggle()
                                    }
                                }
                        }
                        
                        Text("患者名: \(patientName.isEmpty ? "未入力" : patientName)")
                        Text("患者ID: \(patientID.isEmpty ? "未入力" : patientID)")
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("薬品名: \(medicineName.isEmpty ? "未入力" : medicineName)")
                        Text("投与方法: 点滴")
                        Text("投与用量: 800ml")
                    }
                }
                .padding()
                
                if showDatePicker {
                    DatePicker("記録日", selection: $recordDate, in: Date() - 1...Date(), displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .frame(height: 150)
                        .padding()
                }
            }
            .onAppear {
                patientName = "山田 太郎"
                patientID = "3849872"
                medicineName = "お薬飲めたね"
                medicineID = "093"
            }
            
        case .finished:
            VStack {
                Text("投与を記録しました")
                    .padding()
                Button(action: {
                    setting = .title
                }) {
                    Text("最初から記録する")
                }
            }
        }
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy/MM/dd"
    return formatter.string(from: date)
}

struct ContentView_Previews: PreviewProvider {
    @State static var previewData: String? = "サンプルデータ"

    static var previews: some View {
        ContentView(receivedData: $previewData)
    }
}
