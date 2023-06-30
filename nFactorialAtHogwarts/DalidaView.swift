import SwiftUI
import AVFoundation

struct DalidaView: View {
    @State private var isAnimating = false
    @State private var animatedText = ""
    @State private var animatedSecondText = ""
    @State private var showFirstSteps = false
    @State private var showAlibek = false
    let text = "Балапан, великая опасность надвигается на Хогвартс! Бекнар-де-Морт, злоумышленник, стремится захватить нашу школу. Но не всё потеряно! Ваш выбор определит исход событий и судьбу Хогвартса."
    let secondText = "Теперь вам нужно улучшаться каждый день и, несмотря на выходные и праздники always be coding.Теперь вступайте в свою группу и получите своё первое задание.Буду ждать вашего первого результата на этой неделе, балапашка."

    var body: some View {
        ZStack {
            Image("Hogwarts4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 950)

            Image("Paper")
                .resizable()
                .frame(width: 400, height: 350)
                .offset(y: -130)

            if animatedText == text && !showFirstSteps {
                Text(animatedSecondText)
                    .frame(width: 300, height: 480)
                    .font(.system(size: 18, weight: .semibold))
                    .offset(y: -150)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        startTypingSecondText()
                    }
                    .onChange(of: animatedSecondText) { newValue in
                        if newValue == secondText {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                showFirstSteps = true
                            }
                        }
                    }
            } else {
                if !showFirstSteps {
                    Text(animatedText)
                        .frame(width: 300, height: 480)
                        .font(.system(size: 18, weight: .semibold))
                        .offset(y: -150)
                        .multilineTextAlignment(.center)
                        .onAppear {
                            startTypingText()
                        }
                } else {
                    FirstView()
                        .offset(x: 50, y: -160)
                }
            }

            VStack {
                Spacer()
                ZStack {
                    Image("Dalida")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 550)
                        .offset(x: 100)
                    Text("Далида-гонагалл")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(x: 60, y: 150)
                }
            }
            VStack {
                Button(action: {
                    showAlibek = true
                }) {
                    Image(systemName: "chevron.right.2")
                        .foregroundColor(.black)
                }
                .padding(.trailing, 200)
                .padding(.bottom, 50)
            }
            .fullScreenCover(isPresented: $showAlibek) {
                AlibekView()
            }
        }
    }

    private func startTypingText() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < text.count {
                animatedText += String(text[text.index(text.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }

    private func startTypingSecondText() {
        var currentIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < secondText.count {
                animatedSecondText += String(secondText[secondText.index(secondText.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

struct DalidaView_Previews: PreviewProvider {
    static var previews: some View {
        DalidaView()
    }
}

struct FirstView: View {
    @State private var selectedOption: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Выбери свой первый шаг:")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            RadioButtonView(title: "Поиграть мафию с другими студентами", isSelected: selectedOption == "a") {
                selectedOption = "a"
                playSound(named: "tyshesumasoshel")
            }

            RadioButtonView(title: "Пойти поспать в общежитию", isSelected: selectedOption == "b") {
                selectedOption = "b"
                playSound(named: "sleep")
            }

            RadioButtonView(title: "Подойти к преподавателю", isSelected: selectedOption == "c") {
                selectedOption = "c"
            }

            RadioButtonView(title: "Покушать в тамак", isSelected: selectedOption == "d") {
                selectedOption = "d"
                playSound(named: "tamak")
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 150)
    }

    private func playSound(named name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("Sound file not found.")
            return
        }

        do {
            let url = URL(fileURLWithPath: path)
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
