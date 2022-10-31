//
//  JMChartView.swift
//  ReliabilityInASDU
//
//  Created by Vadim Kim on 29.10.2022.
//

import SwiftUI
import SwiftUICharts
import OrderedCollections

struct JMChartView: View {

    @Binding var isVisible: Bool
    @State var rawData: OrderedDictionary<Double, Double>? = nil

    var body: some View {
        VStack {
            ZStack {
                if let data = createData() {
                    LineChart(chartData: data)
//                        .pointMarkers(chartData: data)
                        .xAxisGrid(chartData: data)
                        .yAxisGrid(chartData: data)
                        .xAxisLabels(chartData: data)
                        .yAxisLabels(chartData: data,
                                     formatter: numberFormatter)
                        .legends(chartData: data)
                }
            }
            .padding(.all)

            Button("Cancel") {
                isVisible.toggle()
            }
            .padding(.all)
        }
        .frame(width: 900, height: 700)
    }
}

struct JMChartView_Previews: PreviewProvider {
    static var previews: some View {
        JMChartView(isVisible: .constant(true))
    }
}


extension JMChartView {

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }

    func createData() -> LineChartData {
        var dataPoints = [LineChartDataPoint]()

        guard let dataForChart = rawData
        else {
            return LineChartData(dataSets: LineDataSet(dataPoints: dataPoints))
        }

        for (key, value) in dataForChart {
            dataPoints.append(LineChartDataPoint(value: value,
                                                 xAxisLabel: String(key)))
            print(key, value)
        }

        let dataSet = LineDataSet(dataPoints: dataPoints,
                               legendTitle: "График надежности",
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colour: .red),
                                                lineType: .line))

        let chartStyle = LineChartStyle(baseline: .minimumWithMaximum(of: 0),
                                        topLine: .maximum(of: 1.1))

        let chartData = LineChartData(dataSets: dataSet,
                                      chartStyle: chartStyle)

        return chartData
    }
}
