//
//  MenuViewController.swift
//  MyLittleAssistant
//
//  Created by imac on 27/03/24.
//

import UIKit
import Charts

class MenuViewController: UIViewController, ChartViewDelegate {
    

  var lineChart = LineChartView()
  var barChart = BarChartView()
    var gaugeView = GaugeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        barChart.delegate = self
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
            // Configurar la gráfica de líneas
            lineChart.translatesAutoresizingMaskIntoConstraints = false
            if !view.subviews.contains(lineChart) {
                view.addSubview(lineChart)
            }
            
            NSLayoutConstraint.activate([
                lineChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2.0/3.0),
                lineChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0),
                lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                lineChart.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
            ])
            
            var entries = [ChartDataEntry]()
            for x in 0..<10 {
                entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
            }
            let temp = LineChartDataSet(entries: entries, label: "Temperatura")
            temp.colors = ChartColorTemplates.material()
            temp.valueColors = [UIColor.white]
            let data = LineChartData(dataSet: temp)
            lineChart.data = data
            lineChart.xAxis.labelTextColor = .white
            lineChart.leftAxis.labelTextColor = .white
            lineChart.leftAxis.labelTextColor = .white
            
            // Configurar la gráfica de barras
            barChart.translatesAutoresizingMaskIntoConstraints = false
            if !view.subviews.contains(barChart) {
                view.addSubview(barChart)
            }
            
            NSLayoutConstraint.activate([
                barChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2.0/3.0),
                barChart.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0),
                barChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                barChart.topAnchor.constraint(equalTo: lineChart.bottomAnchor, constant: 20) // Colocar la gráfica de barras debajo de la gráfica de líneas
            ])
            
            var barEntries = [BarChartDataEntry]()
            for x in 0..<10 {
                barEntries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
            }
            let barDataSet = BarChartDataSet(entries: barEntries, label: "Barras")
            barDataSet.colors = ChartColorTemplates.material()
            let barData = BarChartData(dataSet: barDataSet)
            barChart.data = barData
            barChart.xAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
        
            gaugeView = GaugeView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
               gaugeView.minValue = 0
               gaugeView.maxValue = 180
               gaugeView.currentValue = 90
               view.addSubview(gaugeView)
               gaugeView.center = view.center
    }

   

}
    

