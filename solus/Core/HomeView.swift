//
//  HomeView.swift
//  solus
//
//  Created by Victoria Ono on 7/23/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    
    @FirestoreQuery(collectionPath: "ideas") var ideas: [Idea]
    @FirestoreQuery(collectionPath: "quotes") var quotes: [Idea]
    @FirestoreQuery(collectionPath: "users") var solodates: [SoloDate]
    private let calendar = Calendar.current
    let user: User
    
    var body: some View {
        NavigationStack(path: $router.homeNavigation) {
            VStack {
                ScrollView {
                    Spacer()
                        .frame(height: 40)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Good \(time).")
                                .modifier(Title())
                            Text("Today is \(Date.now.formatted(date: .complete, time: .omitted))")
                                .modifier(Default(fontSize: 12))
                                .fontWeight(.light)
                        }.padding()
                        Spacer()
                    }
                    
                    Text(quotes.first?.text ?? "")
                        .multilineTextAlignment(.center)
                        .modifier(Title(fontSize: 30))
                        .fontWeight(.light)
                        .padding(.vertical, 60)
                    
                    VStack(alignment: .center) {
                        Text("solo date ideas")
                            .modifier(Default(fontSize: 12))
                            .tracking(0.36)
                        ForEach(ideas) { idea in
                            Text(idea.text)
                                .font(.custom("Fraunces", size: 14))
                                .foregroundStyle(Color("slate"))
                        }
                        .padding(3)
                        Image("Heart")
                            .padding(.top, 35)
                    }
                    Spacer()
                        .frame(height: 40)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("upcoming solo dates")
                            .modifier(Default(fontSize: 12))
                            .tracking(0.36)
                        
                        ForEach(solodates) { solodate in
                            DateView(solodate)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .onFirstAppear {
                let random = Int.random(in: 0..<10)
                $ideas.predicates = [.where("index", isGreaterThan: random), .limit(to: 4)]
                $solodates.path = "users/\(user.id)/solodates"
                $solodates.predicates = [.where("date",
                                                isGreaterThanOrEqualTo: calendar.date(from: calendar.dateComponents([.day, .month, .year], from: Date()))!)]
            }
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case let .futureDate(user, solodate):
                    SoloDateView(user: user, solodate: solodate, mode: .edit)
                }
            }
        }
    }
    
    @ViewBuilder
    func DateView(_ solodate: SoloDate) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(solodate.date.toString(format: "EEEE, MMMM d, yyyy"))
            HStack {
                VStack(alignment: .leading) {
                    Text(solodate.title)
                    Text(solodate.time.display)
                }
                .offset(y: 4)
                Spacer()
                if solodate.date.isInSameDay(as: Date()) {
                    NavigationLink(value: HomeDestination.futureDate(user, solodate)) {
                        Text("log")
                            .foregroundColor(Color("whiteish"))
                            .offset(y: 4)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color("sage"), in: RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 70)
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color("slate"), lineWidth: 1))
        }
        .modifier(Default())
    }
}

extension HomeView {
    struct Idea: Identifiable, Codable {
        @DocumentID var id: String?
        let text: String
        let index: Int
    }
    
    var time: String {
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        
        if hourInt >= 0 && hourInt <= 3 {
            return "night"
        }
        else if hourInt <= 11 {
            return "morning"
        }
        else if hourInt <= 17 {
            return "afternoon"
        }
        else {
            return "evening"
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(user: User.MOCK_USER)
    }
}
