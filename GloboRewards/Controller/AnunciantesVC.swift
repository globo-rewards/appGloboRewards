//
//  AnunciantesVC.swift
//  GloboRewards
//
//  Created by Carlos Doki on 20/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class AnunciantesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var anunciantesTbl: UITableView!
    @IBOutlet var playerView: UIView!
    @IBOutlet var processandoView: UIView!
    @IBOutlet var activeAIV: UIActivityIndicatorView!
    
    
    //    let anunciantes: [String] = ["bosch", "casasbahia", "chevrolet" , "fiat"]
    var anunciantes = [Anunciante]()
    let playerViewController = AVPlayerViewController()
    var videoPlayer: AVPlayer!
    var indexInt : Int!
    var parou = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processandoView.isHidden = false
        activeAIV.startAnimating()
        
        anunciantesTbl.delegate = self
        anunciantesTbl.dataSource = self
        
        // Do any additional setup after loading the view.
        let globocode = "linktest"
        let imageURL = URL(string: "https://globo-rewards-api.mybluemix.net/anuncio/\(globocode)")
        
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
                    let marca = anun["marca"] as? String
                    let categoria = anun["categoria"] as? String
                    let tipo = anun["tipo"] as? String
                    let link = anun["link"] as? String
                    let imagem = anun["imagem"] as? String
                    let idProgramaAnunciante = anun["idProgramaAnunciante"] as? String
                    let anunciante = Anunciante(_id: _id!, _rev: _rev!, marca: marca!, categoria: categoria!, tipo: tipo!, link: link!, imagem: imagem!, idProgramaAnunciante: idProgramaAnunciante!)
                    self.anunciantes.append(anunciante)
                }
                DispatchQueue.main.async { // Correct
                    self.anunciantesTbl.reloadData()
                    self.processandoView.isHidden = true
                    self.activeAIV.stopAnimating()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.anunciantesTbl.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if parou == true {
            let anunciante = anunciantes[indexInt]
            
            let alert = UIAlertController.init(title: "Verificação", message: "Qual video foi exibido?", preferredStyle: .alert)
            let BOSCH = UIAlertAction.init(title: "Globo", style: .default)
            let casasBahia = UIAlertAction.init(title: "Casas Bahia", style: .default)
            let okAction = UIAlertAction.init(title: "\(anunciante.marca)", style: .default) { _ in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AtividadeVC") as! AtividadeVC
                controller.idProgramaAnunciante = anunciante.idProgramaAnunciante
                controller.anunciante = anunciante.marca
                self.present(controller, animated: true, completion: nil)
                self.performSegue(withIdentifier: "tarefas", sender: anunciante)
            }
            alert.addAction(BOSCH)
            alert.addAction(casasBahia)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func voltarPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anunciantes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = anunciantes[indexPath.row] 
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? anuncionatesCellVC {
            //            let image = UIImage(named: "\(post)")
            DispatchQueue.global().async {
                let url = URL(fileURLWithPath: post.imagem)
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        cell.imagesIW.image = UIImage( data:data)
                    }
                }
            }
            //            cell.imagesIW.image = image
            return cell
        } else {
            return anuncionatesCellVC()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anunciante = anunciantes[indexPath.row]
        
        //       let videoURL = URL(string: anunciante.link)
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        indexInt = indexPath.row
        parou = true
        
    }
    
    
}

