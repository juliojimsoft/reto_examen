package com.example.reto_examen.controller;

import java.util.List;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.reto_examen.dto.ProductoDTO;
import com.example.reto_examen.entity.Producto;
import com.example.reto_examen.service.ProductoService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping("/api/productos")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping
    public List<Producto> listarProductos() {
        return productoService.listarProductos();
    }

    @PostMapping
    public ResponseEntity<Producto> crear(@RequestBody ProductoDTO productoDTO) {
        Producto nuevProducto = productoService.guardarProducto(productoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(nuevProducto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Producto> actualizarProducto(@PathVariable Long id, @RequestBody Producto Producto) {
        //proceso request
        Producto productoActualizado = productoService.actualizarProducto(id, Producto);
        return ResponseEntity.ok(productoActualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarProducto(@PathVariable Long id){
        boolean eliminado = productoService.eliminarProducto(id);;
        if (eliminado) {
            return ResponseEntity.noContent().build();
        }else{
            return ResponseEntity.notFound().build();
        }


    }
}
