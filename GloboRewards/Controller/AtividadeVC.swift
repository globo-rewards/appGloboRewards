//
//  AtividadeVC.swift
//  GloboRewards
//
//  Created by Carlos Doki on 20/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class AtividadeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet var tituloLbl: UILabel!
    @IBOutlet var tarefasTbl: UITableView!
    @IBOutlet var acumuloView: UIView!
    @IBOutlet var acumuloLbl: UILabel!
    @IBOutlet var anuncianteLbl: UILabel!
    
    var tarefas = [Tarefas]()
    
    var idProgramaAnunciante: String!
    var estalecas: String!
    var anunciante : String!
    var link : String!
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startMonitoringSignificantLocationChanges()
        
        tituloLbl.text = anunciante
        acumuloView.isHidden = true
        tarefasTbl.delegate = self
        tarefasTbl.dataSource = self
        
        let imageURL = URL(string: "https://globo-rewards-api.mybluemix.net/atividade/\(idProgramaAnunciante!)")
        
        var request = URLRequest(url: imageURL!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                for anun in jsonArray {
                    let _id = anun["_id"] as? String
                    let _rev = anun["_rev"] as? String
                 
                let idAnunciante = anun["idAnunciante"] as? String
                let idAtividade = anun["idAtividade"] as? String
                let idPrograma = anun["idPrograma"] as? String
                let tipo = anun["tipo"] as? String
                let status = anun["status"] as? String
                    let tarefa = Tarefas(_id: _id!, _rev: _rev!, idPrograma: idPrograma!, idAnunciante: idAnunciante!, status: status!, idAtividade: idAtividade!, tipo: tipo!)
                self.tarefas.append(tarefa)
                }
                DispatchQueue.main.async { // Correct
                    self.tarefasTbl.reloadData()
                }
               
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }

    override func viewWillAppear(_ animated: Bool) {
        tarefasTbl.reloadData()
    }
    
    @IBAction func voltarPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarefas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = tarefas[indexPath.row]
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TarefasCellVC {
                    let imageURL = URL(string: "https://globo-rewards-api.mybluemix.net/atividade/id/\(post.idAtividade)")
                    var tipoAtividade : String!
                    
                    
                    var request = URLRequest(url: imageURL!)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
                        guard let dataResponse = data,
                            error == nil else {
                                print(error?.localizedDescription ?? "Response Error")
                                return }
                        do{
                            //here dataResponse received from a network request
                            let jsonResponse = try JSONSerialization.jsonObject(with:
                                dataResponse, options: [])
                            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                return
                            }
                            print(jsonArray)

                            tipoAtividade = jsonArray[0]["tipoAtividade"] as? String
                            self.estalecas = jsonArray[0]["estalecas"] as? String
                        } catch let parsingError {
                            print("Error", parsingError)
                        }
                        DispatchQueue.main.async { // Correct
                            cell.tarefaLbl.text = "\(tipoAtividade!)"
                        }
                    }
                    task.resume()
                   
                    return cell
                } else {
                    return TarefasCellVC()
                }
    }
    
    @IBAction func okPressed(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! ViewController
        controller.saldonovo = controller.saldonovo + Int(estalecas!)!
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = tarefas[indexPath.row]
        anuncianteLbl.text = "do  anunciante \(anunciante!)"
        acumuloLbl.text = "E$ \(estalecas!)"
        acumuloView.isHidden = false
        
        let imageURL = URL(string: "https://globo-rewards-api.mybluemix.net/match")
        var request = URLRequest(url: imageURL!)
        let session = URLSession.shared
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let json = [
            "idTelespectador": "756bfa7969828a83afa71abb50a48727",
            "idProgramaAnunciante": "\(self.idProgramaAnunciante!)",
            "data_hora": formatter.string(from: Date()),
            "localizacao": "lat: \((self.locationManger.location?.coordinate.latitude)!), lng: \((self.locationManger.location?.coordinate.longitude)!)",
            "idAtividade": "\(post.idAtividade)",
            "tipo": "MATCH"
        ]
        print(json)
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        request.httpBody = jsonData
        //                let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async { // Correct
                print("Match")
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
}
extension AtividadeVC: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("Finished downloading to \(location).")
    }
}
