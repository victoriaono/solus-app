//
//  WeekScrollerView.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//  Source: https://github.com/philippkno/InfiniteWeekView/blob/main/InfiniteWeekView/InfiniteWeekView/Views/Week/WeeksTabView.swift

import SwiftUI

struct Week {
    var index: Int
    var dates: [Date]
    var referenceDate: Date
}

struct WeekScrollerView<Content: View>: View {
    @EnvironmentObject var weekStore: WeekStore
    @State private var activeTab: Int = 1
    @State private var direction: TimeDirection = .unknown
    
    let content: (_ week: Week) -> Content

    init(@ViewBuilder content: @escaping (_ week: Week) -> Content) {
        self.content = content
    }

    var body: some View {
        HStack {
            Button {
                weekStore.update(to: .past)
            } label: {
                Image("Chevron-Left")
            }
            TabView(selection: $activeTab) {
                content(weekStore.weeks[0])
                    .frame(maxWidth: .infinity)
                    .tag(0)

                content(weekStore.weeks[1])
                    .frame(maxWidth: .infinity)
                    .tag(1)
                    .onDisappear() {
                        guard direction != .unknown else { return }
                        weekStore.update(to: direction)
                        direction = .unknown
                        activeTab = 1
                    }

                content(weekStore.weeks[2])
                    .frame(maxWidth: .infinity)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: activeTab) { value in
                if value == 0 {
                    direction = .past
                } else if value == 2 {
                    direction = .future
                }
            }
            Button {
                weekStore.update(to: .future)
            } label: {
                Image("Chevron-Right")
            }
        }
    }
}

struct WeekScrollerView_Previews: PreviewProvider {
    static var previews: some View {
        WeekScrollerView(content: { week in WeekView(week: week) })
            .environmentObject(WeekStore())
    }
}
