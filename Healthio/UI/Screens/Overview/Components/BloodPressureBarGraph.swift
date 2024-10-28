//
//  BloodPressureBarGraph.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import SwiftUI
import Charts

struct BloodPressureBarGraph: View {
    
    @Environment(\.di) private var di
    
    @State private var lineWidth = 2.0
    @State private var interpolationMethod: InterpolationMethod = .cardinal
    @State private var showSymbols = true
    @State private var showLollipop = true
    @State private var lollipopColor: Color = .red

    let data: [BloodPressure]
    
    @Binding var selectedElement: BloodPressure?

    var body: some View {
        chart
    }
  
    private func CompareSelectedMarkerToChartMarker<T: Equatable>(selectedMarker: T, chartMarker: T) -> Bool {
        return selectedMarker == chartMarker
    }

    private func getBaselineMarker (marker: BloodPressure) -> some ChartContent {
        return LineMark(
            x: .value(LocalizedStringKey("blood_pressure_date"), marker.timestamp, unit: .hour),
            y: .value(LocalizedStringKey("blood_pressure_pulse"), marker.pulse)
        )
        .lineStyle(StrokeStyle(lineWidth: lineWidth))
        .foregroundStyle(.blue)
        .interpolationMethod(interpolationMethod)
        .symbolSize(showSymbols ? 60 : 0)
    }
  
    private var chart: some View {
        Chart(data, id: \.timestamp) { chartMarker in
            let baselineMarker = getBaselineMarker(marker: chartMarker)
            baselineMarker.symbol(Circle().strokeBorder(lineWidth: lineWidth))
            
            BarMark(
                x: .value(LocalizedStringKey("blood_pressure_date"), chartMarker.timestamp, unit: .hour),
                yStart: .value(LocalizedStringKey("blood_pressure_diastolic"), chartMarker.diastolic),
                yEnd: .value(LocalizedStringKey("blood_pressure_systolic"), chartMarker.systolic),
                width: .fixed( 10)
            )
            .clipShape(Capsule())
            .foregroundStyle(
                di.services.bloodPressureService.bloodPressureCategory(
                    systolic: chartMarker.systolic,
                    diastolic: chartMarker.diastolic
                ).color.gradient
            )
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.id == element?.id {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                    )
            }
        }
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElement {
                        let dateInterval = Calendar.current.dateInterval(of: .minute, for: selectedElement.timestamp)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0

                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        
                        Rectangle()
                            .fill(lollipopColor)
                            .frame(width: 2, height: lineHeight)
                            .position(x: lineX, y: lineHeight / 2)

                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .chartYAxis(content: {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) {
                let value = $0.as(Int.self)
                
                AxisTick()
                AxisGridLine()
                AxisValueLabel {
                    Text("\(value ?? 0)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 4)
                }
            }
        })
        .chartYScale(domain: getMinMax().0...getMinMax().1)
		.frame(height: 300)
    }
    
    func getMinMax() -> (min: Int, max: Int) {
        guard !data.isEmpty else { return (0, 200) }

        var minValue = data[0].systolic
        var maxValue = data[0].systolic

        for pressure in data {

            minValue = min(minValue, pressure.systolic)
            maxValue = max(maxValue, pressure.systolic)

            minValue = min(minValue, pressure.diastolic)
            maxValue = max(maxValue, pressure.diastolic)

            minValue = min(minValue, pressure.pulse)
            maxValue = max(maxValue, pressure.pulse)
        }

        return (min: max(0, minValue - 20), max: maxValue + 20)
    }
    
    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> BloodPressure? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in data.indices {
                let nthSalesDataDistance = data[salesDataIndex].timestamp.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index {
                return data[index]
            }
        }
        return nil
    }
}

// MARK: - Preview

struct BloodPressureBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BloodPressureBarGraph(
            data: BloodPressure.mockStefan,
            selectedElement: .constant(nil)
        )
    }
}
