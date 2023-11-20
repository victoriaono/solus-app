//
//  CustomTimePicker.swift
//  solus
//
//  Created by Victoria Ono on 8/24/23.
//

import SwiftUI

struct CustomTimePicker: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var am: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            TimeView(text: "\(hour)", topButtonAction: getPrevHour, bottomButtonAction: getNextHour)
            
            TimeView(text: "\(minute)", topButtonAction: getPrevMinute, bottomButtonAction: getNextMinute)
            
            TimeView(text: am ? "am" : "pm", topButtonAction: toggleAM, bottomButtonAction: toggleAM)
        }
    }
    
    @ViewBuilder
    func TimeView(text: String, topButtonAction: @escaping () -> (), bottomButtonAction: @escaping () -> ()) -> some View {
        
        VStack(spacing: 5) {
            Button {
                topButtonAction()
            } label: {
                Image("Chevron-Left")
                    .rotationEffect(.degrees(90))
            }
            
            // for minute
            if text == "0" {
                Text("00")
                    .offset(y: 3)
                    .modifier(Default())
            } else {
                Text(text)
                    .offset(y: 3)
                    .modifier(Default())
            }
            
            Button {
                bottomButtonAction()
            } label: {
                Image("Chevron-Right")
                    .rotationEffect(.degrees(90))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
    
    func getPrevHour() {
        if hour == 1 {
            hour += 12
        }
        hour -= 1
    }
    
    func getNextHour() {
        if hour == 12 {
            hour -= 12
        }
        hour += 1
    }
    
    func getPrevMinute() {
        if minute == 0 {
            minute += 60
        }
        minute -= 15
    }
    
    func getNextMinute() {
        if minute == 45 {
            minute -= 60
        }
        minute += 15
    }
    
    func toggleAM() {
        am.toggle()
    }
    
}

struct CustomTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        @State var hour = 12
        @State var minute = 0
        @State var am = true
        
        CustomTimePicker(hour: $hour, minute: $minute, am: $am)
    }
}
