package com.example.reto_examen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.Data;

@Data
public class ProductoDTO {
    @NotBlank(message = "El nombre no puede estar vacío")
    private String nombre;

    @NotNull(message = "El precio no puede ser nulo")
    @PositiveOrZero(message = "El precio no puede ser negativo")
    private Double Precio;

    @PositiveOrZero(message = "El stock no puede ser negativo")
    private Integer stock;
    private String descripcion;
    private Boolean activo;
    /* no incluir campos automaticos como fechas */
}
