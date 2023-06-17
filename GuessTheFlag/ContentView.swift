//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rishav Gupta on 27/05/23.
//

import SwiftUI

struct FlagImage: View {
    var text: String
    
    var body: some View {
        Image(text)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ProminentTitles: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitles())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var totalScore = 0
    
    @State private var questionCounter = 1
    @State private var roundCompleted = false
    
    @State private var rotateDegrees: CGFloat = 0
    @State private var didTap: Bool = false
    @State private var indexClicked = -1
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.5)
            ], center: .top, startRadius: 200, endRadius: 700)
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .prominentTitle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            
                            withAnimation {
                                rotateDegrees += 360
                                didTap = true
                                indexClicked = number
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    flagTapped(number)
                                }
                            }
                        } label: {
                            FlagImage(text: countries[number])
                        }
                        .rotation3DEffect(number == indexClicked ? .degrees(rotateDegrees) : .zero, axis: (x: 0, y: 1, z: 0))
                        
//                        .blur(radius: didTap && number != indexClicked ? 3 : 0)
                        .opacity(didTap && number != indexClicked ? 0.25 : 1)
                        .scaleEffect(didTap && number != indexClicked ? 0.8 : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(totalScore)")
        }
        .alert("Game Over", isPresented: $roundCompleted) {
            Button("Restart Game", action: restartGame)
        } message: {
            Text("Your final score is \(totalScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            totalScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        rotateDegrees = 0
        didTap = false
        indexClicked = -1
        questionCounter += 1
        if questionCounter > 8 {
            roundCompleted = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func restartGame() {
        rotateDegrees = 0
        didTap = false
        indexClicked = -1
        totalScore = 0
        questionCounter = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
