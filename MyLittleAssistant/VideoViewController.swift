import UIKit

class VideoViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func Arriba(_ sender: Any) {
        sendPostRequest(to: "http://controller.mylittleasistant.online/api/mqtt/w")
    }
    
    @IBAction func izquierda(_ sender: Any) {
        sendPostRequest(to: "http://controller.mylittleasistant.online/api/mqtt/a")
    }
    
    @IBAction func derecha(_ sender: Any) {
        sendPostRequest(to: "http://controller.mylittleasistant.online/api/mqtt/d")
    }
    @IBAction func abajo(_ sender: Any) {
        sendPostRequest(to: "http://controller.mylittleasistant.online/api/mqtt/s")
    }
    
    
    func sendPostRequest(to url: String) {
        guard let url = URL(string: url) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Respuesta recibida:", responseString)
                    } else {
                        print("No se pudo convertir la respuesta a String")
                    }
                } else {
                    print("No se recibieron datos en la respuesta")
                }
                print("Solicitud exitosa. Status code: 200")
            } else {
                print("Error en la solicitud. Status code:", httpResponse.statusCode)
            }
        }
        task.resume()
    }

}
