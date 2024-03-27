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
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        let h =  view.frame.width * 1.0/3.0
        lineChart.frame = CGRect(x: 0, y:(view.frame.height - h)/2.0,width: view.frame.width * 2.0/3.0,height: h)
        
       
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10{
            entries.append(ChartDataEntry(x: Double(x),y: Double(x))
            )
        }
        let set = LineChartDataSet(entries:entries)
        set.colors = ChartColorTemplates.material()
            let data = LineChartData(dataSet: set)
        lineChart.data = data
    }

   

}
