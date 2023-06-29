//
//  DalidaView.swift
//  nFactorialAtHogwarts
//
//  Created by Акбала Тлеугалиева on 30.06.2023.
//

import SwiftUI

struct DalidaView: View {
    var body: some View {
        ZStack {
            Image("Hogwarts3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
//                .padding(.vertical)
        }
    }
}

struct DalidaView_Previews: PreviewProvider {
    static var previews: some View {
        DalidaView()
    }
}
