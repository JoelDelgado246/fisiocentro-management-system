package com.joel.centrofisioterapeuta.enums;

public enum EstadoTurno {
    PENDIENTE,      // Turno creado, esperando confirmación
    CONFIRMADO,     // Turno confirmado por el paciente o recepcionista
    COMPLETADO,     // Turno realizado exitosamente
    CANCELADO       // Turno cancelado
}