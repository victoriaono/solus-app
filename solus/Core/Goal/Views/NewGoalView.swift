//
//  NewGoalView.swift
//  solus
//
//  Created by Victoria Ono on 8/2/23.
//

import SwiftUI

struct NewGoalView: View {
    @State private var title = ""
    @State private var start = Date()
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    @State private var startDateChosen = false
    @State private var endDateChosen = false
    @State private var end = Date()
    @State private var why = ""
    @State private var frequency = -1
    @StateObject var viewModel: GoalViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var presentAlert = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: GoalViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    HStack(alignment: .lastTextBaseline) {
                        Text("Set a new goal.")
                        .modifier(Title())
                        
                        Spacer()
                        
                        Button {
                            viewModel.saveEntry(Goal(title: title, startDate: start, endDate: end, frequency: frequency, why: why))
                            dismiss()
                        } label: {
                            Text("done")
                                .modifier(Default())
                                .fontWeight(.bold)
                        }
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                    }
                    .padding(.horizontal, 5)
                            
                            
                    VStack(spacing: 5) {
                        InputView(text: $title, placeholder: "title", alignment: .leading)
                        
                        VStack(spacing: 0) {
                            HStack {
                                if startDateChosen {
                                    Text(start.toString(format: "EEEE, M/d/yyyy"))
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                } else {
                                    Text("start date")
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                        .foregroundStyle(Color.gray.opacity(0.6))
                                }
                                Spacer()
                                Image("Chevron-Right")
                                        .rotationEffect(.degrees(showStartDatePicker ? 90 : 0))
                                        .animation(.easeInOut, value: showStartDatePicker)
                                        .padding(.horizontal)
                            }
                            .modifier(Default())
                            .frame(maxWidth: .infinity, alignment: .leading)

                            if showStartDatePicker {
                                CustomDatePicker(currentDate: $start)
                            }
                        }.background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                            .onTapGesture {
                                if showStartDatePicker {
                                    startDateChosen = true
                                }
                                withAnimation {
                                    showStartDatePicker.toggle()
                                }
                            }
                        
                        VStack(spacing: 0) {
                            HStack {
                                if endDateChosen {
                                    Text(end.toString(format: "EEEE, M/d/yyyy"))
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                } else {
                                    Text("end date")
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                        .foregroundStyle(Color.gray.opacity(0.6))
                                }
                                Spacer()
                                Image("Chevron-Right")
                                        .rotationEffect(.degrees(showEndDatePicker ? 90 : 0))
                                        .animation(.easeInOut, value: showEndDatePicker)
                                        .padding(.horizontal)
                            }
                            .modifier(Default())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if showEndDatePicker {
                                CustomDatePicker(currentDate: $end)
                            }
                        }.background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                            .onTapGesture {
                                if showEndDatePicker {
                                    endDateChosen = true
                                }
                                withAnimation {
                                    showEndDatePicker.toggle()
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("frequency")
                            .modifier(Default())
                            .padding(.leading, 5)
                
                        HStack {
                            ButtonView(text: "once a day", num: 0, frequency: $frequency, mode: .edit)
                            
                            ButtonView(text: "once a week", num: 1, frequency: $frequency, mode: .edit)
                        }
                    }
                    .padding(.vertical, 15)
                    
                    Text("why do I want to achieve this goal?")
                        .modifier(Default())
                        .padding(.leading, 5)
                    LongInputView(text: $why)
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentAlert.toggle()
                        } label: {
                            Image("X")
                        }
                    }
                }
                if presentAlert {
                    AlertView(presentAlert: $presentAlert, alertType: .new, leftButtonAction: self.handleDismiss) {
                        withAnimation {
                            presentAlert.toggle()
                        }
                    }
                }
            }
        }
    }
    private func handleDismiss() {
        self.dismiss()
    }
}

extension NewGoalView: FormProtocol {
    var formIsValid: Bool {
        return title.count != 0
        && (frequency == 0 || frequency == 1)
        && start < end
    }
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(user: User.MOCK_USER)
    }
}
