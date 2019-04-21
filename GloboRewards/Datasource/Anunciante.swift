//
//  Anunciante.swift
//  GloboRewards
//
//  Created by Carlos Doki on 21/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import Foundation

class Anunciante {

    private var __id : String!
    private var __rev : String!
    private var _marca : String!
    private var _categoria : String!
    private var _tipo : String!
    private var _link : String!
    private var _imagem : String!
    private var _idProgramaAnunciante: String!
    
    private var _postKey: String!
    
    var _id : String {
        return __id
    }
    
    var _rev : String {
        return __rev
    }
    
    var marca : String {
        return _marca
    }

    var categoria : String {
        return _categoria
    }
    
    var tipo : String {
        return _tipo
    }
    
    var link : String {
        return _link
    }
   
    var imagem : String {
        return _imagem
    }
    
    var idProgramaAnunciante : String {
        return _idProgramaAnunciante
    }

    init(_id: String, _rev: String, marca: String, categoria: String, tipo: String, link: String, imagem: String, idProgramaAnunciante: String) {
        self.__id = _id
        self.__rev = _rev
        self._marca = marca
        self._categoria = categoria
        self._tipo = tipo
        self._link = link
        self._imagem = imagem
        self._idProgramaAnunciante = idProgramaAnunciante
    }
}
