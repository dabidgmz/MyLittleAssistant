import UIKit
import MQTTClient

class VideoViewController: UIViewController, MQTTSessionManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*// Configurar el cliente MQTT
        let mqttClient = MQTTSessionManager()
        
        // Conectar al servidor MQTT
        let transport = MQTTCFSocketTransport()
        transport.host = "a169mg5ru5h2z1-ats.iot.us-east-2.amazonaws.com"
        transport.port = 8883
        
        mqttClient.delegate = self
        mqttClient.connect(toLast: false, using: transport, clean: true, will: nil, withConnectHandler: { error in
            if error == nil {
                print("Conectado correctamente al servidor MQTT")
                
                // Envío del mensaje "w"
                let message = "w"
                mqttClient.send(message.data(using: .utf8), topic: "motors/control", qos: .atLeastOnce, retain: false)
            } else {
                print("Error al conectar al servidor MQTT: \(error!.localizedDescription)")
            }
        })*/
    }
}

