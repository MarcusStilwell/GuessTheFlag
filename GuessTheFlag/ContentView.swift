//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Marcus Stilwell on 6/29/21.
//

import SwiftUI

struct flagAttributes: ViewModifier{
    var imgTemp: Image
    func body(content: Content) -> some View{
        imgTemp
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: Color.black, radius: 2)
    }
}

extension View {
    func flagStyle(with imgTemp: Image) -> some View{
        self.modifier(flagAttributes(imgTemp: imgTemp))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 15){
                VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .flagStyle(with: Image(self.countries[number]))
                    }
                    Spacer()
                }
                Text("Current score is \(currentScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }

        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(currentScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong, that is the flag of \(self.countries[number])"
            currentScore = currentScore-1
        }

        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
