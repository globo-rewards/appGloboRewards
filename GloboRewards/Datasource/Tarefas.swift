//
//  Tarefas.swift
//  GloboRewards
//
//  Created by Carlos Doki on 21/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import Foundation

class Tarefas {
    private var __id : String!
    private var __rev : String!
    private var _idPrograma : String!
    private var _idAnunciante : String!
    private var _status : String!
    private var _idAtividade : String!
    private var _tipo: String!
    
    private var _postKey: String!
    
    var _id : String {
        return __id
    }
    
    var _rev : String {
        return __rev
    }
    
    var idPrograma : String{
        return _idPrograma
    }
    
    var idAnunciante : String {
        return _idAnunciante
    }
    
    var status : String {
        return _status
    }
    
    var idAtividade : String {
        return _idAtividade
    }
    
    var tipo : String {
        return _tipo
    }
    
    init(_id: String, _rev: String, idPrograma: String, idAnunciante: String, status: String, idAtividade: String, tipo: String) {
        self.__id = _id
        self.__rev = _rev
        self._idPrograma = idPrograma
        self._idAnunciante = idAnunciante
        self._status = status
        self._idAtividade = idAtividade
        self._tipo = tipo
    }
    
   
}
