//
//  ContentView.swift
//  DrugCertification
//
//  Created by 植松優羽 on 2024/11/05.
//


import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isAuthenticated = true//falseだけどテスト用にtrue
    @State private var isRecording = false
    @State private var showDatePicker = false
    @State private var recordDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @State private var patientName = ""
    @State private var patientID = ""

    var body: some View {
        if !isAuthenticated {
            // 認証画面
            VStack {
                Text("薬剤認証")
                    .font(.title)
                    .padding()
                
                Button("認証") {
                    // 認証が完了したら画面を切り替え
                    isAuthenticated = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        } else {
            VStack {
                HStack {
                    // 録音ボタン
                    Button(action: {
                        //ボタンを押した時の処理
                    }) {
                        HStack {
                            Text("左のボタンだよー")
                        }
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    // カレンダーボタン
                    Button(action: {
                        withAnimation {
                            showDatePicker.toggle()
                        }
                    }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .padding(.trailing)
                    }
                }
                .padding(.top)
                
                Text("薬剤情報記録")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                // 記録日、患者名、患者IDの表示
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
                
                if showDatePicker {
                    DatePicker("記録日", selection: $recordDate, in: Date() - 1...Date(), displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                        .frame(height: 150)
                        .padding()
                }
                
                Form {
                    Section(header: Text("バイタルデータ")) {
                        TextField("血圧", text: .constant(""))
                        TextField("体温", text: .constant(""))
                        TextField("脈拍", text: .constant(""))
                    }
                    
                    Section(header: Text("看護記録 (SOAP)")) {
                        TextField("S: 主観的データ", text: .constant(""))
                        TextField("O: 客観的データ", text: .constant(""))
                        TextField("A: アセスメント", text: .constant(""))
                        TextField("P: 計画", text: .constant(""))
                    }
                }
            }
            .onAppear {
                patientName = "山田 太郎"
                patientID = "3849872"
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
