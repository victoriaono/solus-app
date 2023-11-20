//
//  GoalItemView.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//

import SwiftUI

struct GoalItemView: View {
    @EnvironmentObject var weekStore: WeekStore
    @StateObject var viewModel: GoalDataViewModel
    private var title: String
    @State private var circles: Array<(key: Int, value: Bool)> = Array(0..<7).reduce(into: [Int: Bool]()) { $0[$1] = false }.sorted(by: {$0.key < $1.key})
    
    init(user: User, goal: Goal) {
        self._viewModel = StateObject(wrappedValue: GoalDataViewModel(user: user, goal: goal))
        self.title = goal.title
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("whiteish"))
                .frame(height: 100)
            HStack {
                Spacer()
                ForEach(0..<7, id:\.self) { num in
                        Button {
                            circles[num].value = !circles[num].value
                            let newHabit = circles[num].value
                            let date = weekStore.weeks[1].dates[num]
                            Task {
                                await viewModel.updateData(tapped: newHabit, date: date)
                            }
                        } label: {
                            Circle()
                                .strokeBorder(Color("slate"))
                                .background(circles[num].value ? Circle().foregroundColor(Color("slate")) : Circle().foregroundColor(Color.clear))
                                .frame(width: 16, height: 16)
                                .padding(.horizontal, 4)
                        }
                }
                .offset(x: -18, y: -20)
            }
            .onChange(of: weekStore.weeks[1].dates[0]) { newWeek in
                circles = viewModel.showCurrentWeekData(for: weekStore.weeks[1].dates)
            }
            
            Text(title)
                .modifier(Default(fontSize: 14))
                .offset(x: 20, y: 20)
        }
        .onAppear {
            circles = viewModel.showCurrentWeekData(for: weekStore.weeks[1].dates)
        }
    }
}

struct GoalItemView_Previews: PreviewProvider {
    static var previews: some View {
        GoalItemView(user: User.MOCK_USER, goal: Goal.MOCK_GOAL)
            .environmentObject(WeekStore())
    }
}
