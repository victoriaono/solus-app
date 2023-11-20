//
//  WeekView.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//  Source: https://github.com/philippkno/InfiniteWeekView/blob/main/InfiniteWeekView/InfiniteWeekView/Views/Week/WeekView.swift

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var weekStore: WeekStore
    
    var week: Week
    
    var body: some View {
        HStack {
            ForEach(0..<7) { i in
                VStack {
                    Text(week.dates[i].formatted(Date.FormatStyle().weekday(.narrow)))
                        .modifier(Default())
                        .frame(maxWidth: .infinity)

                    Text(week.dates[i].toString(format: "d"))
                        .frame(maxWidth: .infinity)
                        .modifier(Default())
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(week: .init(index: 1, dates:
                                        [
                                            Date().yesterday.yesterday.yesterday,
                                            Date().yesterday.yesterday,
                                            Date().yesterday,
                                            Date(),
                                            Date().tomorrow,
                                            Date().tomorrow.tomorrow,
                                            Date().tomorrow.tomorrow.tomorrow
                                        ],
                                     referenceDate: Date()))
                .environmentObject(WeekStore())
    }
}


