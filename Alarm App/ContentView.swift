//
//  ContentView.swift
//  Alarm App
//
//  Created by William Siong on 2023-10-15.
//

import SwiftUI

struct AlarmListView: View {
    @State private var alarms: [Alarm] = []
    @State private var isPresentingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarms) { alarm in
                    Text("\(alarm.time, formatter: Alarm.customFormatter)")
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Alarms")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    isPresentingAddView = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isPresentingAddView) {
                AlarmEditView(isPresented: $isPresentingAddView, alarms: $alarms)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}

struct Alarm: Identifiable {
    var id = UUID()
    var time: Date
    var days: [Bool] = [false, false, false, false, false, false, false]
    
    static var customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a z, EEEE"
        return formatter
    }()
    
    var daysDescription: String {
            let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            var selectedDays: [String] = []
            for (index, isSelected) in days.enumerated() where isSelected {
                selectedDays.append(daysOfWeek[index])
            }
            return selectedDays.isEmpty ? "No Days Selected" : selectedDays.joined(separator: ": ")
    }
}

struct AlarmEditView: View {
    @Binding var isPresented: Bool
    @Binding var alarms: [Alarm]
    
    @State private var time: Date = Date()
    @State private var days: [Bool] = [false, false, false, false, false, false, false]
    
    var body: some View {
        NavigationView {
            Form {
                // Time Picker
                DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                
                // Day Selector
                Section(header: Text("Days")) {
                    ForEach(0..<days.count, id: \.self) { index in
                        Toggle(getDayOfWeek(index), isOn: $days[index])
                    }
                }
            }
            .navigationTitle("Add Alarm")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    let alarm = Alarm(time: time, days: days)
                    alarms.append(alarm)
                    isPresented = false
                }
            )
        }
    }
    func getDayOfWeek(_ index: Int) -> String {
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",]
        return daysOfWeek[index]
    }
}

struct ContentView: View {
    var body: some View {
        AlarmListView()
    }
}

#Preview {
    ContentView()
}
