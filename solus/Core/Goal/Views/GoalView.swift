//
//  GoalView.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//

import SwiftUI

struct GoalView: View {
    
    @StateObject var viewModel: GoalViewModel
    @EnvironmentObject var router: Router
    private var mode: Mode = .edit
    @State private var why = ""
    @State private var frequency = -1
    @State var showStartDatePicker = false
    @State var showEndDatePicker = false
    @State var startDateChanged = false
    @State var endDateChanged = false
    @State var startDate = Date()
    @State var endDate = Date()
    @GestureState private var offSet = CGSize.zero
    @Environment(\.dismiss) private var dismiss
        
    init(user: User, goal: Goal, mode: Mode) {
        self._viewModel = StateObject(wrappedValue: GoalViewModel(user: user, entry: goal))
        self.mode = mode
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if mode == .view {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                            SettingsView(viewModel: viewModel, category: .Goal)
                        } label: {
                            Image("Settings-Active")
                                .padding()
                        }
                }
            } else {
                Spacer()
                    .frame(height: 40)
            }
            
            HStack(alignment: .top) {
                HeaderView(title: viewModel.entry.title)
                Spacer()
                
                if mode == .edit {
                    Button {
                        self.handleDoneTapped()
                    } label: {
                        Text("done")
                            .modifier(Default())
                            .fontWeight(.bold)
                            .padding(5)
                    }
                }
            }
            
            Spacer()
                .frame(height: 25)
            
            VStack(spacing: 5) {
                if mode == .view {
                    Text("start: \(viewModel.entry.startDate.formatted(date: .long, time: .omitted))")
                        .modifier(Default())
                        .padding(.top, 8.0)
                        .padding(.leading, 12.0)
                        .modifier(LongText())
                    
                    Text("end: \(viewModel.entry.endDate.formatted(date: .long, time: .omitted))")
                        .modifier(Default())
                        .padding(.top, 8.0)
                        .padding(.leading, 12.0)
                        .modifier(LongText())
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            if startDateChanged {
                                Text("start: \(startDate.formatted(date: .long, time: .omitted))")
                                    .padding(.leading, 10)
                                    .padding(.top, 8)
                            } else {
                                Text("start: \(viewModel.entry.startDate.formatted(date: .long, time: .omitted))")
                                    .padding(.leading, 10)
                                    .padding(.top, 8)
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
                            CustomDatePicker(currentDate: $startDate)
                        }
                    }
                    .background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 25))
                    .onTapGesture {
                        if showStartDatePicker {
                            startDateChanged = true
                        }
                        withAnimation {
                            showStartDatePicker.toggle()
                        }
                    }
                    
                    VStack(spacing: 0) {
                        HStack {
                            if endDateChanged {
                                Text("end: \(endDate.formatted(date: .long, time: .omitted))")
                                    .padding(.leading, 10)
                                    .padding(.top, 8)
                            } else {
                                Text("end: \(viewModel.entry.endDate.formatted(date: .long, time: .omitted))")
                                    .padding(.leading, 10)
                                    .padding(.top, 8)
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
                            CustomDatePicker(currentDate: $endDate)
                        }
                    }
                    .background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 25))
                    .onTapGesture {
                        if showEndDatePicker {
                            endDateChanged = true
                        }
                        withAnimation {
                            showEndDatePicker.toggle()
                        }
                    }
                }
            }
            .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("frequency")
                    .modifier(Default())
                    .padding(.leading, 5)
        
                HStack {
                    ButtonView(text: "once a day", num: 0, frequency: $frequency, mode: mode)
                    
                    ButtonView(text: "once a week", num: 1, frequency: $frequency, mode: mode)
                }
            }
            .padding(.bottom, 25)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("why do I want to achieve this goal?")
                    .modifier(Default())
                    .padding(.leading, 5)
                if mode == .edit {
                    LongInputView(text: $viewModel.entry.why)
                        .onChange(of: viewModel.entry.why) { newValue in
                            why = viewModel.entry.why
                        }
                } else {
                    Text(viewModel.entry.why)
                        .padding()
                        .modifier(Default())
                        .modifier(LongText())
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            self.frequency = viewModel.entry.frequency
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                self.dismiss()
            }
        }))
    }
    
    func handleDoneTapped() {
        var data = [String: Any]()
        
        if startDate != viewModel.entry.startDate {
            data["startDate"] = startDate
        }
        if endDate != viewModel.entry.endDate {
            data["endDate"] = endDate
        }
        if frequency != viewModel.entry.frequency {
            data["frequency"] = frequency
        }
        if why.count > 0 {
            data["why"] = why
        }
        self.viewModel.updateEntry(dict: data)
        router.profileNavigation.removeLast()
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(user: User.MOCK_USER, goal: Goal.MOCK_GOAL, mode: .edit)
    }
}
