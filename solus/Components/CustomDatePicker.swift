//
//  CustomDatePicker.swift
//  solus
//
//  Created by Victoria Ono on 8/23/23.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
//    @State var isSelected = false
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @StateObject var viewModel = MonthlyViewModel()
    
    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 20) {
                Text("\(viewModel.extractMonthYear())")
                    .modifier(Default())
                    .padding(.top, 10)
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.currentMonth -= 1
                    }
                } label: {
                    Image("Chevron-Left")
                }
                
                Button {
                    withAnimation {
                        viewModel.currentMonth += 1
                    }
                } label: {
                    Image("Chevron-Right")
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id:\.self) { day in
                    Text(day)
                        .modifier(Default())
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(viewModel.extractDates()) { value in
                    Button {
                        currentDate = value.date
                    } label: {
                        CardView(value: value)
                    }
                }
            }
        }
        .onChange(of: viewModel.currentMonth) { newValue in
            // update month
            currentDate = viewModel.getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack(spacing: 0) {
            if value.day != -1 {
                    Text("\(value.day)")
                        .modifier(Default())
                    
                if value.date.isInSameDay(as: currentDate) {
                    Circle()
                        .fill(Color("slate"))
                        .frame(width: 6, height: 6)
                }
            }
        }.frame(height: 30, alignment: .top)
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var date = Date()
        @State var selectedDate = DateValue(day: -1, date: Date())
        CustomDatePicker(currentDate: $date)
    }
}
