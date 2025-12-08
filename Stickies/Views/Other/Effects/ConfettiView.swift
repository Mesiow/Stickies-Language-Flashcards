//
//  ConfettiView.swift
//  Stickies
//
//  Created by Chris W on 12/7/25.
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let x: CGFloat = .random(in: -190...190)
    let delay: Double = .random(in: 0...2.0)
    let spin: Double = .random(in: -200...200)
    let color: Color = [
        .yellow, .green, .pink, .orange, .blue
    ].randomElement() ?? .yellow
}


struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            ForEach(confetti) { confetti in
                Rectangle()
                    .fill(confetti.color)
                    .frame(width: 6, height: 12)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .rotationEffect(.degrees(animate ? confetti.spin : 0))
                    .offset(x: confetti.x, y: animate ? 500: -300)
                    .opacity(animate ? 0.8 : 0)
                    .animation(
                        .easeOut(duration: 3.0).delay(confetti.delay),
                        value: animate
                    )
            }
        }
        .transition(.opacity)
        .ignoresSafeArea(.all)
        .allowsHitTesting(false)
        .onAppear {
            spawnConfetti()
        }
    }
    
    func spawnConfetti(){
        confetti = (0...90).map { _ in ConfettiPiece() }
        DispatchQueue.main.async {
            animate = true //make sure animation starts on next run loop
        }
        
        //Remove confetti after animation ends
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            confetti.removeAll()
        }
    }
}

func createConfetti() -> [ConfettiPiece] {
    let conf: [ConfettiPiece] = (0...25).map { _ in ConfettiPiece() }
    return conf
}

#Preview {
    ZStack {
        Color.black.opacity(0.2).ignoresSafeArea()
        ConfettiView()
    }
}
