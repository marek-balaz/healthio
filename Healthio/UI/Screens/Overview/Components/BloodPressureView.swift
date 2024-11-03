//
//  BloodPressureView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct BloodPressureView: View {
    
    @Environment(\.di) private var di
    
    @State private var cancelBag = CancelBag()
    
    @State private var apiError: (Error?, Bool) = (nil, false)
    
    // Impl

    let profile: UserProfile
    
    @State var data: [BloodPressure] = []
    
    @State var selected: BloodPressure?
    
    var body: some View {
        content
            .onAppear {
                loadRecords()
            }
    }
    
}

// MARK: - UI

extension BloodPressureView {
    
    var content: some View {
        VStack(alignment: .leading) {
            
            header
            
            Divider()
                .padding(.bottom, 4)
            
            current
            
            BloodPressureBarGraph(
                data: data,
                selectedElement: $selected
            )

        }
    }
    
    var header: some View {
        HStack {
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(Color.red)
                .padding(8)
                .background {
                    Circle()
                        .fill(Color.red.opacity(0.5))
                }
            
            Text(LocalizedStringKey("blood_pressure_title"))
                .font(.system(size: 20, weight: .bold))
        }
    }
    
    var current: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let selected {
                chartValue(
                    systolic: selected.systolic,
                    diastolic: selected.diastolic,
                    pulse: selected.pulse,
                    timestamp: selected.timestamp
                )
            } else if
                let systolic = data.last?.systolic,
                let diastolic = data.last?.diastolic,
                let pulse = data.last?.pulse
            {
                chartValue(
                    systolic: systolic,
                    diastolic: diastolic,
                    pulse: pulse,
                    timestamp: nil
                )
            }
        }
    }
    
    @ViewBuilder
    func chartValue(
        systolic: Int,
        diastolic: Int,
        pulse: Int,
        timestamp: Date?
    ) -> some View {
        if let timestamp {
            Text(timestamp.formatted(.dateTime))
                .font(.system(size: 16, weight: .regular))
        } else {
            Text(LocalizedStringKey("graph_latest"))
                .font(.system(size: 16, weight: .regular))
        }
        
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text("\(systolic)/\(diastolic)")
                .font(.system(size: 24, weight: .bold))
            
            Text("mmHg")
                .font(.system(size: 12, weight: .regular))
                .padding(.trailing, 4)
            
            Text("\(pulse)")
                .font(.system(size: 24, weight: .bold))
            
            Text(LocalizedStringKey("BPM"))
                .font(.system(size: 12, weight: .regular))
        }
        
        Text(di.services.bloodPressureService.bloodPressureCategory(systolic: systolic, diastolic: diastolic).description)
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(di.services.bloodPressureService.bloodPressureCategory(systolic: systolic, diastolic: diastolic).color)
    }
    
}

// MARK: - API

extension BloodPressureView {

    func loadRecords() {
        di.services.bloodPressureService.fetch(interval: .days365, for: profile.id)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    apiError = (error, true)
                }
            } receiveValue: { records in
                self.data = records
            }
            .store(in: cancelBag)
    }
    
}
