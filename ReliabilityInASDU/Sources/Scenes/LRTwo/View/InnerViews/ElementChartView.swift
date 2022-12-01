//
//  ElementChartView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.10.2022.
//

import SwiftUI
import SwiftUICharts
import OrderedCollections

struct ElementChartView: View {

    @Binding var isVisible: Bool
    @State var rawData: OrderedDictionary<String, String>? = nil

    var body: some View {
        VStack {
            ZStack {
                if let data = createData() {
                    LineChart(chartData: data)
                        .pointMarkers(chartData: data)
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data,
                                     formatter: numberFormatter)
                        .legends(chartData: data)
                }
            }
            .padding(.all)
        }
        .frame(width: 800, height: 500)
    }
}

extension ElementChartView {

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter
    }

    func createData() -> LineChartData {
        var dataPoints = [LineChartDataPoint]()

        guard let dataForChart = rawData
        else {
            return LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        }

        for (key, value) in dataForChart {
            dataPoints.append(LineChartDataPoint(value: Double(value) ?? 0,
                                                 xAxisLabel: String(key)))
        }

        let dataSet = LineDataSet(dataPoints: dataPoints,
                               legendTitle: "График надежности",
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colour: .red),
                                                lineType: .line))

        var chartStyle = LineChartStyle()
        chartStyle.topLine = .maximum(of: 1)

        if let minimumChartValue = dataForChart.values.last {
            chartStyle.baseline = .minimumWithMaximum(of: (Double(minimumChartValue) ?? 0.7) - 0.1)
        }

        let chartData = LineChartData(dataSets: dataSet,
                                      chartStyle: chartStyle)

        return chartData
    }
}
