//
//  GoalsViewModel.swift
//  solus
//
//  Created by Victoria Ono on 8/13/23.
//  Reference: https://github.com/andresr-dev/HabitTracking/blob/main/HabitTracking/Core/Home/ViewModel/ActivitiesModel.swift

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class GoalDataViewModel: ObservableObject {
    @Published var goal: Goal
    @Published var goals = [Goal]()
    private var collectionRef: CollectionReference
    let dict = Array(0..<7).reduce(into: [Int: Bool]()) { $0[$1] = false }

    private let user: User
    
    init(user: User, goal: Goal) {
        self.user = user
        self.goal = goal
        self.collectionRef = Firestore.firestore().collection("users").document(user.id).collection("goal")
    }
    
    func showCurrentWeekData(for week: [Date]) -> Array<(key: Int, value: Bool)> {
        // called from weekscrollerview when the shown week changes, publish that week's data
        
        // get this week's data
        let startOfWeek = week[0]
        let data = goal.habits.filter { $0.date.isInSameWeek(as: startOfWeek) }
        
        var habits = data.reduce(into: [Int: Bool]()) { newDict, source in
            let dayNum = Calendar.current.component(.weekday, from: source.date)
            // lol idk
            if dayNum == 1 {
                newDict[6] = source.habit
            } else {
                newDict[dayNum - 2] = source.habit
            }
        }
        habits.merge(dict) { (current, _) in current }
        
        let thisWeekData = habits.sorted(by: {$0.key < $1.key})
        return thisWeekData
        
    }
    
    @MainActor
    func updateData(tapped: Bool, date: Date) async {
        let data = goal.habits
        if let index = goal.habits.firstIndex(where: { $0.date.isInSameDay(as: date) }) {
            goal.habits[index].habit = tapped
            
            if let id = goal.id {
                do {
                    try await Firestore.firestore().collection("users").document(user.id).collection("goal").document(id).updateData([
                        "habits": FieldValue.arrayRemove([data[index].dictionary])
                    ])
                    try await Firestore.firestore().collection("users").document(user.id).collection("goal").document(id).updateData([
                        "habits": FieldValue.arrayUnion([goal.habits[index].dictionary])
                    ])
                } catch {
                    print("failed to replace existing data")
                }
            }
        } else {
            let newHabit = HabitData(date: date, habit: tapped)
            goal.habits.append(newHabit)
            if let id = goal.id {
                do {
                    try await Firestore.firestore().collection("users").document(user.id).collection("goal").document(id).updateData([
                        "habits": FieldValue.arrayUnion([newHabit.dictionary])
                    ])
                } catch {
                    print(String(describing: error))
                }
            }
        }
    }
    
    func fetchEntries() async throws {
        collectionRef.addSnapshotListener{ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("no ducments")
                return
            }
            
            self.goals = documents.compactMap { (queryDocumentSnapshot) -> Goal? in
                return try? queryDocumentSnapshot.data(as: Goal.self)
            }
        }
    }
    
}
