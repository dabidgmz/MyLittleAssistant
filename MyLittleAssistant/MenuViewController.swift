//
//  MenuViewController.swift
//  MyLittleAssistant
//
//  Created by imac on 27/03/24.
//

import UIKit
import Charts
import UserNotifications
class MenuViewController: UIViewController, ChartViewDelegate ,UNUserNotificationCenterDelegate{
    

 
    @IBOutlet weak var flecha: UIImageView!
    
    
    @IBOutlet weak var pesolbl: UILabel!
    var lineChart = LineChartView()
    var barChart = BarChartView()
    var gaugeView = GaugeView()
    let userData = UserData.sharedData()
    var angle: CGFloat = 0.0
    var timer: Timer?
    var velocidadValores = [Double]()
    var temperaturaValores = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        barChart.delegate = self
        fetchDevices()
        PesoGet()
        VelocidadGet()
        TemperaturaGet()
        InclinacionGet()
        updateBarChartWithStoredValues()
        updateLineChartWithStoredValues()
        startPollingPeso()
        startPollingVelocidad()
        startPollingInclinacion()
        startPollingTemperatura()
    }
    override func viewDidLayoutSubviews()
    {
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
            temp.valueTextColor = .white
            
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
            let barDataSet = BarChartDataSet(entries: barEntries, label: "Velocidad")
            barDataSet.colors = ChartColorTemplates.material()
            barDataSet.valueColors = [.white]

            let barData = BarChartData(dataSet: barDataSet)
            barChart.data = barData
            barChart.xAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
            barChart.leftAxis.labelTextColor = .white
            temp.valueTextColor = .white
      
        //let angleInDegrees: CGFloat = 90
        //let angleInRadians = angleInDegrees * CGFloat.pi / 180
        //rotateArrow(angle: angleInRadians)

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permiso concedido para mostrar notificaciones")
            } else {
                print("Permiso denegado para mostrar notificaciones")
            }
        }
        
           
    }
    
    func startPollingPeso() {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                self?.PesoGet()
            }
            PesoGet()
    }
    func startPollingTemperatura() {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                self?.TemperaturaGet()
            }
            TemperaturaGet()
    }
    func startPollingVelocidad() {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                self?.VelocidadGet()
            }
            VelocidadGet()
    }
    
    func startPollingInclinacion() {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                self?.InclinacionGet()
            }
        InclinacionGet()
    }
    
    func rotateArrow(angle: CGFloat) {
            UIView.animate(withDuration: 0.3) {
                self.flecha.transform = CGAffineTransform(rotationAngle: angle)
            }
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
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
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
                                //
                            }
                        } else {
                            print("No se encontraron dispositivos")
                        }
                    } else {
                        print("No se encontró el arreglo 'data' en el JSON")
                    }
                } catch {
                    print("Error al convertir los datos JSON:", error)
                }
            } else if httpResponse.statusCode == 404 {
                print("No se encontraron dispositivos")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "No se encontraron dispositivos.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                print("Error en el request. Status code:", httpResponse.statusCode)
            }
        }
        task.resume()
    }


    func PesoGet() {
        self.userData.load()
        let token = self.userData.jwt
        guard let deviceCode = Device.loadDeviceCode() else {
            print("Código de dispositivo no encontrado")
            return
        }
        //print("Peso Código de dispositivo enviado en la solicitud:", deviceCode)
        let urlString = "http://backend.mylittleasistant.online:8000/api/peso/lastone/\(deviceCode)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    print("No se recibió data en la respuesta")
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("No se pudo convertir el JSON en un diccionario")
                        return
                    }
                    //print("JSON recibido:", json)
                    if let dataArray = json["data"] as? [[String: Any]], let firstData = dataArray.first, let peso = firstData["Valor"] as? String,
                        let pesoDouble = Double(peso){
                        DispatchQueue.main.async {
                            self.pesolbl.text = peso
                            if pesoDouble > 7 {
                                //self.pesoNotification()
                                //descomentar el metodo de notificaciones
                            }
                        }
                    } else {
                        print("No se encontró el valor de peso en la respuesta")
                    }
                } catch {
                    print("Error al convertir los datos en JSON:", error)
                }
            default:
                print("Error en la solicitud. Código de estado:", httpResponse.statusCode)
            }
        }
        task.resume()
    }


    
    func VelocidadGet() {
     self.userData.load()
     let token = self.userData.jwt
     guard let deviceCode = Device.loadDeviceCode() else {
         print("Código de dispositivo no encontrado")
         return
     }
     //print("Velocidad Código de dispositivo enviado en la solicitud:", deviceCode)
     let urlString = "http://backend.mylittleasistant.online:8000/api/vel/lastfive/\(deviceCode)"
     guard let url = URL(string: urlString) else {
         print("URL inválida")
         return
     }
     var request = URLRequest(url: url)
     request.httpMethod = "GET"
     request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let httpResponse = response as? HTTPURLResponse else {
             print("Respuesta inválida")
             return
         }
         if let error = error {
             print("Error en la solicitud:", error)
             return
         }
         switch httpResponse.statusCode {
         case 200:
             guard let data = data else {
                 print("No se recibió data en la respuesta")
                 return
             }
             do {
                 guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                     print("No se pudo convertir el JSON en un diccionario")
                     return
                 }
                 if let dataArray = json["data"] as? [[String: Any]] {
                     var nuevosValores = [Double]()
                     for dataEntry in dataArray {
                         if let valorString = dataEntry["Valor"] as? String, let valorDouble = Double(valorString) {
                             nuevosValores.append(valorDouble)
                         }
                     }
                     self.velocidadValores = nuevosValores
                     DispatchQueue.main.async {
                         self.updateBarChart(valores: nuevosValores)
                     }
                 } else {
                     print("No se encontró el arreglo 'data' en el JSON")
                 }
             } catch {
                 print("Error al convertir los datos en JSON:", error)
             }
         default:
             print("Error en la solicitud. Código de estado:", httpResponse.statusCode)
         }
     }
     task.resume()
    }


    func updateBarChartWithStoredValues() {
            updateBarChart(valores: velocidadValores)
    }
    
    func updateBarChart(valores: [Double]) {
        guard let barDataSet = barChart.data?.dataSets.first as? BarChartDataSet else {
            print("No se encontró el conjunto de datos de la gráfica de barras")
            return
        }
        var barEntries = [BarChartDataEntry]()
        for (index, valor) in valores.enumerated() {
            let barEntry = BarChartDataEntry(x: Double(index), y: valor)
            barEntries.append(barEntry)
        }
        
        barDataSet.replaceEntries(barEntries)
        barChart.data?.notifyDataChanged()
        barChart.notifyDataSetChanged()
    }
    
    
    func TemperaturaGet(){
        self.userData.load()
        let token = self.userData.jwt
        guard let deviceCode = Device.loadDeviceCode() else {
            print("Código de dispositivo no encontrado")
            return
        }
        //print("Temperatura Código de dispositivo enviado en la solicitud:", deviceCode)
        let urlString = "http://backend.mylittleasistant.online:8000/api/Temp/lastfive/\(deviceCode)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    print("No se recibió data en la respuesta")
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("No se pudo convertir el JSON en un diccionario")
                        return
                    }
                    //print("JSON recibido:", json)
                    if let dataArray = json["data"] as? [[String: Any]] {
                        var NUEVOSValores = [Double]()
                        for dataEntry in dataArray {
                            if let VALORString = dataEntry["Valor"] as? String, let VALORDouble = Double(VALORString) {
                                NUEVOSValores.append(VALORDouble)
                            }
                        }
                        self.temperaturaValores = NUEVOSValores
                        DispatchQueue.main.async {
                            //self.checkTemperature()
                            self.updateLineChartWithStoredValues()
                            //descomentar el metodo de notificaciones .checkTemperature()
                        }
                    } else {
                        print("No se encontró el arreglo 'data' en el JSON")
                    }
                } catch {
                    print("Error al convertir los datos en JSON:", error)
                }
            default:
                print("Error en la solicitud. Código de estado:", httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func updateLineChartWithStoredValues() {
        updateLineChart(valores: velocidadValores)
    }
    
    func updateLineChart(valores: [Double]) {
        guard let lineDataSet = lineChart.data?.dataSets.first as? LineChartDataSet else {
            print("No se encontró el conjunto de datos de la gráfica de líneas")
            return
        }
        
        var lineEntries = [ChartDataEntry]()
        for (index, valor) in valores.enumerated() {
            let lineEntry = ChartDataEntry(x: Double(index), y: valor)
            lineEntries.append(lineEntry)
        }
        
        lineDataSet.replaceEntries(lineEntries)
        lineChart.data?.notifyDataChanged()
        lineChart.notifyDataSetChanged()
    }
    
    
    func InclinacionGet() {
        self.userData.load()
        let token = self.userData.jwt
        guard let deviceCode = Device.loadDeviceCode() else {
            print("Código de dispositivo no encontrado")
            return
        }
        //print("Inclinacion Código de dispositivo enviado en la solicitud:", deviceCode)
        let urlString = "http://backend.mylittleasistant.online:8000/api/incli/lastone/\(deviceCode)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    print("No se recibió data en la respuesta")
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("No se pudo convertir el JSON en un diccionario")
                        return
                    }
                    //print("JSON recibido:", json)
                    if let dataArray = json["data"] as? [[String: Any]], let firstData = dataArray.first, let valorString = firstData["Valor"] as? String, let VALORDouble = Double(valorString) {
                        DispatchQueue.main.async {
                            //print("Valor :\(VALORDouble)")
                            let angleInDegrees: CGFloat = CGFloat(VALORDouble)
                            let angleInRadians = angleInDegrees * CGFloat.pi / 180
                            self.rotateArrow(angle: angleInRadians)
                            //self.checkInclination(angle: angleInDegrees)
                            //descomentar el metodo de notificaciones
                        }
                    } else {
                        print("No se encontró el arreglo 'data' en el JSON o no se pudo obtener el valor")
                    }
                } catch {
                    print("Error al convertir los datos en JSON:", error)
                }
            default:
                print("Error en la solicitud. Código de estado:", httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func pesoNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alerta de peso"
        content.body = "El peso del producto es mayor a 7 kilos."
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "PesoMayor7", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error al programar la notificación:", error)
            }
        }
    }
    
    func checkTemperature() {
        let maxTemperature: Double = 40
        guard let lastTemperature = temperaturaValores.last else {
            print("No se encontraron valores de temperatura")
            return
        }
        if lastTemperature > maxTemperature {
            let content = UNMutableNotificationContent()
            content.title = "Alerta de temperatura"
            content.body = "La temperatura del dispositivo es demasiado alta. Por favor, revisa los motores."
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "TemperaturaAlta", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error al programar la notificación de temperatura alta:", error)
                }
            }
        }
    }
    
    func checkInclination(angle: CGFloat) {
        let thresholdAngle: CGFloat = 90
        if angle < thresholdAngle {
            let content = UNMutableNotificationContent()
            content.title = "Alerta de inclinación"
            content.body = "El dispositivo parece haber sido volteado. Por favor, revisa su posición."
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "InclinacionBaja", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error al programar la notificación de inclinación baja:", error)
                }
            }
        }
    }
}
    

