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
    let userData = UserData.sharedData()
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        barChart.delegate = self
        
        fetchDevices()
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

    func fetchDevices() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/devices")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "GET"
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Making request to URL:", url.absoluteString)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error en el request:", error)
                return
            }
            guard let data = data else {
                print("No se recibió data en la respuesta")
                return
            }
            print("Response received:", data)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Request successful. Status code: 200")
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            print("No se pudo convertir el JSON en un diccionario")
                            return
                        }
                        if let devicesData = json["data"] as? [[String: Any]] {
                            if !devicesData.isEmpty {
                                DispatchQueue.main.async {
                                   // self.performSegue(withIdentifier: "sgLinkDevice", sender: self)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                                }
                                print("No se encontraron dispositivos")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                            }
                            print("No se encontró el arreglo 'data' en el JSON")
                        }
                    } catch {
                        print("Error al convertir los datos JSON:", error)
                    }
                } else if httpResponse.statusCode == 404 {
                    print("No se encontraron dispositivos")
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "No se encontraron dispositivos.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    print("Error en el request. Status code:", httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }
   

}
    

