package com.example.reto_examen.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.reto_examen.entity.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long> {
}
