//
//  MainView.swift
//  nFactorialAtHogwarts
//
//  Created by Акбала Тлеугалиева on 29.06.2023.

import SwiftUI

struct MainView: View {
    @State private var animatedText: String = ""
    private let fullText = "Привет, ученики Хогвартса! Я, Профессор Арман Дамблдор, рад приветствовать вас в этом удивительном месте волшебства. Выберите свой дом и направление: Mobile, Frontend, Backend или ML. Путешествие в мире волшебного программирования ждет вас! Исследуйте, творите и достигайте вершин!"
    @State private var showSchoolOptions: Bool = false
    var body: some View {
        ZStack {
            Image("Hogwarts2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .padding(.vertical, -150)
            
            ImageWithPerson(animatedText: animatedText, showSchoolOptions: showSchoolOptions)
                .onAppear {
                    startTyping()
                }
        }
    }

    private func startTyping() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < fullText.count {
                animatedText += String(fullText[fullText.index(fullText.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct ImageWithPerson: View {
    var animatedText: String
    @State var showSchoolOptions: Bool  // Updated to a variable
    @State private var scaleAmount: CGFloat = 0.2 // Initial scale factor

    var body: some View {
        ZStack {
            ZStack {
                Image("Paper")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 65)
                
                if showSchoolOptions {
                    SchoolOptionsView()
                } else {
                    Text(animatedText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 150)
                }
            }
            .padding(.horizontal, 100)
            .offset(x: 0, y: -36)

            Image("Arman")
                .resizable()
                .frame(width: 260, height: 320)
                .aspectRatio(contentMode: .fit)
                .offset(x: 100, y: 300)
                .onTapGesture {
                    self.showSchoolOptions = true
                    // when i tap the first time change the text to  SchoolOptionsView()
                }
        }
    }
}


struct SchoolOptionsView: View {
    @State private var selectedOption: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Выбери свою школу:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            RadioButtonView(title: "Frontend", isSelected: selectedOption == "a") {
                selectedOption = "a"
                // Action for option A
            }
            
            RadioButtonView(title: "Backend", isSelected: selectedOption == "b") {
                selectedOption = "b"
                // Action for option B
            }
            
            RadioButtonView(title: "Mobile", isSelected: selectedOption == "c") {
                selectedOption = "c"
                // Action for option C
            }
            
            RadioButtonView(title: "ML", isSelected: selectedOption == "d") {
                selectedOption = "d"
                // Action for option D
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 150)
    }
}

struct RadioButtonView: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
