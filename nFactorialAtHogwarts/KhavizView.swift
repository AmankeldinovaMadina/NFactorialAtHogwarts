import SwiftUI

struct KhavizView: View {
    @State private var showGameFlappy = false
    let KhavizText = "Вы блестяще преодолели все испытания, и теперь вы готовы получить эту волшебную палочку и вступить в схватку с легендарным Бекнаром Де Мортом."
    
    var body: some View {
        ZStack {
            Image("hogwarts6")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 950)
            
            Image("Paper")
                .resizable()
                .frame(width: 450, height: 500)
                .offset(y: -130)
            
            Text(KhavizText)
                .frame(width: 300, height: 480)
                .font(.system(size: 18, weight: .semibold))
                .offset(y: -150)
                .multilineTextAlignment(.center)
            
            VStack {
                Spacer()
                ZStack {
                    Image("Khaviz")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 550)
                        .offset(x: -70, y: 50)
                    Text("Хавизиус Блэк")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        .offset(y: 120)
                }
            }
            
            VStack {
                Button(action: {
                    showGameFlappy = true
                }) {
                    ZStack{
                        Capsule()
                            .frame(width: 150, height: 54)
                            .foregroundColor(.black)
                        Text("начать бой")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    } .padding(.trailing, 50)
                }
                .padding(.leading, 250)
            }
            .fullScreenCover(isPresented: $showGameFlappy) {
                GameVieww()
            }
        }
    }
}

struct KhavizView_Previews: PreviewProvider {
    static var previews: some View {
        KhavizView()
    }
}
