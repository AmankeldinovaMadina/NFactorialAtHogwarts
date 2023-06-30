//
//  ContentView.swift
//  nFactorialAtHogwarts
//
//  Created by Акбала Тлеугалиева on 30.06.2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var showContextView = false
    @State private var navigateToMainView = false
    var body: some View {
        ZStack {
            Image("Hogwarts")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            if showContextView {
                ImageWithText()
                    .transition(.scale)
                    .padding(.bottom, 80)
                VStack {
                    Spacer()
                    Button(action: {
                        navigateToMainView = true 
                    }) {
                        Text("Начать")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
                .fullScreenCover(isPresented: $navigateToMainView) {
                    MainView()
                }
            }
            
        }
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showContextView = true
            }
        }
        .onAppear {
            BackgroundMusicPlayer.shared.playBackgroundMusic()
        }
        .onDisappear {
            BackgroundMusicPlayer.shared.stopBackgroundMusic()
        }
    }
}

struct ImageWithText: View {
    @State private var scaleAmount: CGFloat = 0.2 
    var body: some View {
        ZStack {
            Image("Paper")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 65)
            
            Text("Вы играете роль студента в Хогвартсе, и ваша задача - раскрыть и предотвратить план Бекнар-де-Морта по захвату школы. Вам предстоит пройти через различные уровни,чтобы раскрыть темные замыслы и спасти Хогвартс от неминуемой гибели.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 150)
        }
        .scaleEffect(scaleAmount)
        .animation(.easeInOut(duration: 1.0))
        .onAppear {
            withAnimation {
                scaleAmount = 1.0
            }
        }
    }
}



class BackgroundMusicPlayer {
    static let shared = BackgroundMusicPlayer()
    private var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        guard let musicURL = Bundle.main.url(forResource: "HedwigsTheme", withExtension: "mp3") else {
            fatalError("Background music file not found")
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Failed to play background music:", error.localizedDescription)
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
