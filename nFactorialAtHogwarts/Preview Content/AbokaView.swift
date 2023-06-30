//
//  AbokaView.swift
//  nFactorialAtHogwarts
//
//  Created by Madina Amankeldinova on 30.06.2023.
//

import SwiftUI

struct AbokaView: View {
    @State private var showAbokaNotFound = false
    
    var body: some View {
        VStack {
            if showAbokaNotFound {
                AbokaNotFound()
            } else {
                LoadingView()
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                            showAbokaNotFound = true
                        }
                    }
            }
        }
    }
}

struct AbokaView_Previews: PreviewProvider {
    static var previews: some View {
        AbokaView()
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear {
                    isAnimating = true
                }
            
            Text("Loading...")
                .font(.caption)
                .padding(.top, 8)
        }
    }
}

struct AbokaNotFound: View {
    var body: some View {
        VStack {
            Image("Aboka")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
            
            Text("Упс, мы не смогли его найти. Но он оставил вам записку с местонахождением Хафизиус Блэк.")
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .font(.system(size: 22, weight: .semibold))
                .padding(.horizontal)
            
            Button(action: {
                // Action to perform when the button is tapped
            }) {
                ZStack {
                    Capsule()
                        .frame(height: 54)
                        .foregroundColor(.green)
                    Text("Начать поиски")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                }
                .padding(.top, 50)
                .padding(.horizontal)
            }
        }
    }
}
