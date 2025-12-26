package com.joel.centrofisioterapeuta.logica;

import javax.persistence.Entity;

import java.util.Date;

@Entity
public class Responsable extends Persona{

    //private int idResponsable;
    private String relacionPaciente;

    public Responsable() {
    }

    public Responsable(int id, String nombre, String apellido, String cedula, String correo, String telefono, String dirección, Date fechaNacimiento, String relacionPaciente) {
        super(id, nombre, apellido, cedula, correo, telefono, dirección, fechaNacimiento);
        this.relacionPaciente = relacionPaciente;
    }

    public String getRelacionPaciente() {
        return relacionPaciente;
    }

    public void setRelacionPaciente(String relacionPaciente) {
        this.relacionPaciente = relacionPaciente;
    }
}
