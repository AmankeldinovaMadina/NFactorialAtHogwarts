import SwiftUI

struct MainView: View {
    @State private var animatedText: String = ""
    @State private var showDalida = false 
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
            VStack{
                Button(action: {
                    showDalida = true 
                }) {
                    Image(systemName: "chevron.right.2")
                        .foregroundColor(.black)
                }
                .padding(.top, 350)
                .padding(.leading, 300)
            }
            .fullScreenCover(isPresented: $showDalida) {
                DalidaView()
            }
        }
    }

    public func startTyping() {
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
    @State var showSchoolOptions: Bool
    @State private var scaleAmount: CGFloat = 0.2
    @State private var tapCount: Int = 0
   
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
            Text("Арман Дамблдор")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.white)
                .offset(x:60, y:350)
                .onTapGesture {
                    tapCount += 1
                    if tapCount >= 2 {
                        self.showSchoolOptions = true
                    }
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
              
            }
            
            RadioButtonView(title: "Backend", isSelected: selectedOption == "b") {
                selectedOption = "b"
              
            }
            
            RadioButtonView(title: "Mobile", isSelected: selectedOption == "c") {
                selectedOption = "c"
             
            }
            
            RadioButtonView(title: "ML", isSelected: selectedOption == "d") {
                selectedOption = "d"
            
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
