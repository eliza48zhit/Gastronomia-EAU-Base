// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Gastronomia_EAU
 * @dev Registro de tecnicas de homogeneizacion y gestion de calor residual.
 * Optimizacion: Errores personalizados para ahorro de gas y validacion de rangos.
 * Serie: Sabores de Asia (#6)
 */
contract Gastronomia_EAU {

    // Custom Errors para optimizacion de gas
    error RangoExcedido(string parametro, uint256 valor);
    error YaVotado(address voter);
    error IDInvalido(uint256 id);
    error NombreRequerido();

    struct Plato {
        string nombre;
        string ingredientes;
        string preparacion;
        uint256 nivelHomogeneizacion; 
        uint256 tiempoCoccionLenta;   
        bool usaBezarMix;             
        uint256 likes;
        uint256 dislikes;
    }

    mapping(uint256 => Plato) public registroCulinario;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    
    uint256 public totalRegistros;
    address public owner;

    constructor() {
        owner = msg.sender;
        // Inauguramos con el Al Harees
        registrarPlato(
            "Al Harees", 
            "Trigo entero, carne, ghee.",
            "Fusion mecanica total de fibras y grano.",
            98, 6, false
        );
    }

    function registrarPlato(
        string memory _nombre, 
        string memory _ingredientes,
        string memory _preparacion,
        uint256 _homogeneizacion, 
        uint256 _tiempo,
        bool _bezar
    ) public {
        if (bytes(_nombre).length == 0) revert NombreRequerido();
        if (_homogeneizacion > 100) revert RangoExcedido("Homogeneizacion", _homogeneizacion);
        if (_tiempo > 48) revert RangoExcedido("Tiempo", _tiempo);

        totalRegistros++;
        registroCulinario[totalRegistros] = Plato({
            nombre: _nombre,
            ingredientes: _ingredientes,
            preparacion: _preparacion,
            nivelHomogeneizacion: _homogeneizacion,
            tiempoCoccionLenta: _tiempo,
            usaBezarMix: _bezar,
            likes: 0,
            dislikes: 0
        });
    }

    function darLike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].likes++;
        hasVoted[_id][msg.sender] = true;
    }

    function darDislike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].dislikes++;
        hasVoted[_id][msg.sender] = true;
    }
}
