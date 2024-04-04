//
//  MenuViewController.swift
//  MyLittleAssistant
//
//  Created by imac on 27/03/24.
//

import UIKit
import Charts

class MenuViewController: UIViewController, ChartViewDelegate {
    

    @IBOutlet weak var flecha: UIImageView!
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
                lineChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                lineChart.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -(view.bounds.height * 0.07))
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
                barChart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                barChart.topAnchor.constraint(equalTo: lineChart.bottomAnchor, constant: 15)
            ])
            
            var barEntries = [BarChartDataEntry]()
            for x in 0..<10 {
                barEntries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
            }
            let barDataSet = BarChartDataSet(entries: barEntries, label: "Barras")
            barDataSet.colors = ChartColorTemplates.material()
            barDataSet.valueColors = [.white]

            let barData = BarChartData(dataSet: barDataSet)
            barChart.data = barData
            barChart.xAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
            
        
        
           
    }

   

}
    

