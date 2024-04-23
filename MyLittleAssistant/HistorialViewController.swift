//
//  HistorialViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 22/04/24.
//

import UIKit

class HistorialViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Btn_Lista: UIButton!
    @IBOutlet weak var lista_Sensores: UIPickerView!
    @IBOutlet weak var Tabla_Sensores: UITableView!
    struct SensorData {
        var datetime: String
        var tipo: String
        var unidad: String
        var valor: String
        func datetimeDate() -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: datetime)
        }
    }
    
    let userData = UserData.sharedData()
    var sensorDataArray = [SensorData]()
    let opciones = ["Velocidad","Peso", "Temperatura", "Inclinación", "GPS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOrdenamiento()
        lista_Sensores.dataSource = self
        lista_Sensores.delegate = self
        Tabla_Sensores.dataSource = self
        Tabla_Sensores.delegate = self
        //PesoGet()
    }
    
    func setOrdenamiento() {
        let optionClosure  = {(action :UIAction) in
            switch action.title {
            case "A-z":
                self.sensorDataArray.sort { $0.tipo < $1.tipo }
            case "Menor a mayor":
                self.sensorDataArray.sort { Double($0.valor) ?? 0 < Double($1.valor) ?? 0 }
            case "Mayor a menor":
                self.sensorDataArray.sort { Double($0.valor) ?? 0 > Double($1.valor) ?? 0 }
            case "Más reciente":
                self.sensorDataArray.sort {
                    $0.datetimeDate() ?? Date() > $1.datetimeDate() ?? Date()
                }
            case "Más antiguo":
                self.sensorDataArray.sort {
                    $0.datetimeDate() ?? Date() < $1.datetimeDate() ?? Date()
                }
            default:
                break
            }
            self.Tabla_Sensores.reloadData()
        }
        Btn_Lista.menu  = UIMenu (children: [
            UIAction(title: "A-z", state: .on, handler: optionClosure),
            UIAction(title: "Menor a mayor", state: .on, handler: optionClosure),
            UIAction(title: "Mayor a menor", handler: optionClosure),
            UIAction(title: "Más reciente", handler: optionClosure),
            UIAction(title: "Más antiguo", handler: optionClosure)
        ])
        Btn_Lista.showsMenuAsPrimaryAction = true
        Btn_Lista.changesSelectionAsPrimaryAction = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opciones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return opciones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = opciones[row]
        
        switch selectedOption {
        case "Peso":
            PesoGet()
        case "Velocidad":
            VelocidadGet()
            break
        case "Temperatura":
            // Llama a otro método para obtener datos de temperatura
            break
        case "Inclinación":
            // Llama a otro método para obtener datos de inclinación
            break
        case "GPS":
            // Llama a otro método para obtener datos de GPS
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = opciones[row]
        
        return label
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensorDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        if indexPath.row == 0 {
            let fechaLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 20))
            fechaLabel.text = "Fecha"
            fechaLabel.font = UIFont.boldSystemFont(ofSize: 12)
            fechaLabel.textAlignment = .center
            cell.addSubview(fechaLabel)
            
            let tipoLabel = UILabel(frame: CGRect(x: 120, y: 5, width: 100, height: 20))
            tipoLabel.text = "Tipo"
            tipoLabel.font = UIFont.boldSystemFont(ofSize: 12)
            tipoLabel.textAlignment = .center
            cell.addSubview(tipoLabel)
            
            let unidadLabel = UILabel(frame: CGRect(x: 230, y: 5, width: 100, height: 20))
            unidadLabel.text = "Unidad"
            unidadLabel.font = UIFont.boldSystemFont(ofSize: 12)
            unidadLabel.textAlignment = .center
            cell.addSubview(unidadLabel)
            
            let valorLabel = UILabel(frame: CGRect(x: 340, y: 5, width: 100, height: 20))
            valorLabel.text = "Valor"
            valorLabel.font = UIFont.boldSystemFont(ofSize: 12)
            valorLabel.textAlignment = .center
            cell.addSubview(valorLabel)
        }
        let sensorData = sensorDataArray[indexPath.row]
        
        let fechaDataLabel = UILabel(frame: CGRect(x: 10, y: 25, width: 100, height: 20))
        fechaDataLabel.text = sensorData.datetime
        fechaDataLabel.textAlignment = .center
        fechaDataLabel.font = UIFont.systemFont(ofSize: 10)
        cell.addSubview(fechaDataLabel)
        
        let tipoDataLabel = UILabel(frame: CGRect(x: 120, y: 25, width: 100, height: 20))
        tipoDataLabel.text = sensorData.tipo
        tipoDataLabel.textAlignment = .center
        cell.addSubview(tipoDataLabel)
        
        let unidadDataLabel = UILabel(frame: CGRect(x: 230, y: 25, width: 100, height: 20))
        unidadDataLabel.text = sensorData.unidad
        unidadDataLabel.textAlignment = .center
        cell.addSubview(unidadDataLabel)
        
        let valorDataLabel = UILabel(frame: CGRect(x: 340, y: 25, width: 100, height: 20))
        valorDataLabel.text = sensorData.valor
        valorDataLabel.textAlignment = .center
        cell.addSubview(valorDataLabel)
        
        return cell
    }
    
    func PesoGet() {
        self.sensorDataArray.removeAll()
        self.userData.load()
        let token = self.userData.jwt
        guard let deviceCode = Device.loadDeviceCode() else {
            print("Código de dispositivo no encontrado")
            return
        }
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
                    if let dataArray = json["data"] as? [[String: Any]], let firstData = dataArray.first,
                       let datetime = firstData["Datetime"] as? String,
                       let tipo = firstData["Tipo"] as? String,
                       let unidad = firstData["Unidad"] as? String,
                       let valor = firstData["Valor"] as? String {
                        let sensorData = SensorData(datetime: datetime, tipo: tipo, unidad: unidad, valor: valor)
                        DispatchQueue.main.async {
                            self.sensorDataArray.append(sensorData)
                            self.Tabla_Sensores.reloadData()
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
        self.sensorDataArray.removeAll()
        let valoresPredefinidos = [
            SensorData(datetime: "2024-04-22 12:00:00", tipo: "Velocidad", unidad: "km/h", valor: "55"),
            SensorData(datetime: "2024-02-22 12:05:00", tipo: "Velocidad", unidad: "km/h", valor: "60"),
            SensorData(datetime: "2024-01-22 12:10:00", tipo: "Velocidad", unidad: "km/h", valor: "50"),
            SensorData(datetime: "2024-03-22 12:15:00", tipo: "Velocidad", unidad: "km/h", valor: "45"),
            SensorData(datetime: "2024-05-22 12:20:00", tipo: "Velocidad", unidad: "km/h", valor: "70")
        ]
        DispatchQueue.main.async {
            self.sensorDataArray = valoresPredefinidos
            self.Tabla_Sensores.reloadData()
        }
    }
}
