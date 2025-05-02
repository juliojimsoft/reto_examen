package com.example.reto_examen.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.reto_examen.dto.ProductoDTO;
import com.example.reto_examen.entity.Producto;
import com.example.reto_examen.repository.ProductoRepository;
import com.example.reto_examen.service.ProductoService;

import jakarta.transaction.Transactional;

@Service
public class ProductoServiceImpl implements ProductoService {

    @Autowired
    private ProductoRepository productoRepo;

    public ProductoServiceImpl(ProductoRepository productoRepo) {
        this.productoRepo = productoRepo;
    }

    @Override
    public List<Producto> listarProductos() {
        return productoRepo.findAll();
    }

    @Override
    @Transactional
    public Producto actualizarProducto(Long id, Producto producto) {
        // buscar producto
        Producto productoExistente = productoRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado con Id: " + id));

        productoExistente.setNombre(producto.getNombre());
        productoExistente.setPrecio(producto.getPrecio());
        productoExistente.setStock(producto.getStock());
        productoExistente.setActivo(producto.getActivo());

        return productoExistente;
    }

    @Override
    public Producto guardarProducto(ProductoDTO productoDTO) {
        Producto producto = new Producto();
        producto.setNombre(productoDTO.getNombre());
        producto.setPrecio(productoDTO.getPrecio());
        producto.setStock(productoDTO.getStock());
        producto.setDescripcion(productoDTO.getDescripcion());
        return productoRepo.save(producto);
    }

    @Override
    public Optional<Producto> obtenerPorId(Long id) {
        return productoRepo.findById(id);
    }

    @Override
    public boolean eliminarProducto(Long id) {
        if (productoRepo.existsById(id)) {
            productoRepo.deleteById(id);
            return true;
        }
        return false;
    }
}
