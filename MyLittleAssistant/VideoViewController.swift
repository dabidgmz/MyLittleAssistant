import UIKit
import CocoaMQTT

class VideoViewController: UIViewController {
  /*  var mqtt: CocoaMQTT?

    override func viewDidLoad() {
        super.viewDidLoad()

        mqttSetting()
    }

    func mqttSetting() {
        let clientID: String = "motors/control"
        let mqttServer: String = "a169mg5ru5h2z1-ats.iot.us-east-2.amazonaws.com"
        let mqttPort: UInt16 = 8883
        let useSSL: Bool = true

        mqtt = CocoaMQTT(clientID: clientID, host: mqttServer, port: mqttPort)
        if mqtt == nil {
            print("Error al inicializar CocoaMQTT")
            return
        }

        mqtt!.username = nil
        mqtt!.password = nil
        mqtt!.keepAlive = 60
        mqtt!.delegate = self

        if useSSL {
            let caCertPath = Bundle.main.path(forResource: "AmazonRootCA1", ofType: "pem")
            let clientCertPath = Bundle.main.path(forResource: "cec69141d6f3a0869a78f2331a3b6acebf6bc9ddb27a738dc3945c2ea4a99618-certificate", ofType: "pem.crt")
            let clientKeyPath = Bundle.main.path(forResource: "cec69141d6f3a0869a78f2331a3b6acebf6bc9ddb27a738dc3945c2ea4a99618-private", ofType: "pem.key")

            let caCertData = try? Data(contentsOf: URL(fileURLWithPath: caCertPath!))
            let clientCertData = try? Data(contentsOf: URL(fileURLWithPath: clientCertPath!))
            let clientKeyData = try? Data(contentsOf: URL(fileURLWithPath: clientKeyPath!))

            if caCertData == nil || clientCertData == nil || clientKeyData == nil {
                print("Error al cargar los certificados.")
                return
            }

            mqtt!.enableSSL = true
            mqtt!.allowUntrustCACertificate = true
            let sslSettings: [String: NSObject] = [
                kCFStreamSSLPeerName as String: mqttServer as NSObject,
                kCFStreamSSLValidatesCertificateChain as String: kCFBooleanFalse,
                kCFStreamSSLIsServer as String: kCFBooleanFalse,
                kCFStreamSSLCertificates as String: [caCertData!, clientCertData!, clientKeyData!] as NSObject
            ]
            mqtt!.sslSettings = sslSettings
        }

        mqtt!.connect()
    }

    func publishMessage() {
        if mqtt == nil {
            print("No se puede publicar el mensaje porque mqtt es nil.")
            return
        }
        mqtt!.publish("topic", withString: "w", qos: .qos1, retained: false)
    }

    @IBAction func arriba(_ sender: Any) {
        publishMessage()
    }
}

extension VideoViewController: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Suscrito exitosamente a los siguientes temas: \(success.allKeys)")
        print("No se pudo suscribir a los siguientes temas: \(failed)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("Se desuscribió de los siguientes temas: \(topics)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            mqtt.subscribe("chat/room/animals/client/+", qos: .qos1)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        print("new state: \(state)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message: \(String(describing: message.string?.description)), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message: \(String(describing: message.string?.description)), id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("topic: \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Ping")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Pong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected")
        }
    }*/
}
