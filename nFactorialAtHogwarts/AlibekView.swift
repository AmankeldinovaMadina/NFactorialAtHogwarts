import SwiftUI

struct AlibekView: View {
    @State private var isAnimating = false
    @State private var animatedText = ""
    @State private var animatedSecondText = ""
    @State private var showSecondSteps = false
    @State private var showAboka = false 
    let Alibektext = "Простите за поздную встречу с тобой. Я вчера до 4 утра практиковал заклинания чтобы распределяющая шляпа пела песню Кайратус Нуртасуса. Давайте сейчас быстро поговорим про ваши дальнейшие задачи."
    
    let AlibekSecondText = "Вам сейчас нужно получить самую могущественную палочку у Хафизиуса Блэка."
    
    
    
    var body: some View {
        ZStack{
            Image("Hogwarts5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 950)
            
            Image("Paper")
                .resizable()
                .frame(width: 450, height: 500)
                .offset(y: -130)
            
            if animatedText == Alibektext && !showSecondSteps {
                Text(animatedSecondText)
                    .frame(width: 300, height: 480)
                    .font(.system(size: 18, weight: .semibold))
                    .offset(y: -150)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        startTypingSecondText()
                    }
                    .onChange(of: animatedSecondText) { newValue in
                        if newValue == AlibekSecondText {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                                showSecondSteps = true
                            }
                        }
                    }
            } else if showSecondSteps {
                SecondChoice()
                    .offset(x: 0, y: -170)
            } else {
                Text(animatedText)
                    .frame(width: 300, height: 480)
                    .font(.system(size: 18, weight: .semibold))
                    .offset(y: -150)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        startTypingText()
                    }
            }
            
            VStack {
                Spacer()
                ZStack{
                    Image("Alibek")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 550)
                        .offset(x: -70, y:50)
                    Text("Алибекус Люпин")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(y:120)
                }
            }
           
            
            VStack{
                Button(action: {
                    showAboka = true
                }) {
                    Image(systemName: "chevron.right.2")
                        .foregroundColor(.black)
                }
                .padding(.leading, 250)
            }
            .fullScreenCover(isPresented: $showAboka) {
                AbokaView()
            }
        }
    }
    
    private func startTypingText() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < Alibektext.count {
                animatedText += String(Alibektext[Alibektext.index(Alibektext.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func startTypingSecondText() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < AlibekSecondText.count {
                animatedSecondText += String(AlibekSecondText[AlibekSecondText.index(AlibekSecondText.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct AlibekView_Previews: PreviewProvider {
    static var previews: some View {
        AlibekView()
    }
}

struct SecondChoice: View {
    @State private var selectedOption: String = ""
    @State private var showTextAboutAboka = false
    
    let textAboutAboka = "Тебе поможет Абокос Хагрид найти его"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Выбери что ты сделаешь:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            RadioButtonView(title: "Пойду искать его в горах", isSelected: selectedOption == "a") {
                selectedOption = "a"
                showTextAboutAboka = false
            }
            
            RadioButtonView(title: "Я его боюсь и не хочу к нему подходить", isSelected: selectedOption == "b") {
                selectedOption = "b"
                showTextAboutAboka = false
            }
            
            RadioButtonView(title: "Спросить как найти Хафизиуса Блэка", isSelected: selectedOption == "c") {
                selectedOption = "c"
                showTextAboutAboka = true
            }
            
            RadioButtonView(title: "Я устал, пожалуюсь", isSelected: selectedOption == "d") {
                selectedOption = "d"
                showTextAboutAboka = false
            }
            
            if showTextAboutAboka {
                Text(textAboutAboka)
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 150)
    }
}

