package com.example.reto_examen.service;

import java.util.List;
import java.util.Optional;

import com.example.reto_examen.dto.ProductoDTO;
import com.example.reto_examen.entity.Producto;

public interface ProductoService {
    List<Producto> listarProductos();

    Producto guardarProducto(ProductoDTO productoDTO);

    Optional<Producto> obtenerPorId(Long id);

    Producto actualizarProducto(Long id, Producto producto);

    boolean eliminarProducto(Long id);
}
