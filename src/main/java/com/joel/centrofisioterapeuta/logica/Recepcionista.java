package com.joel.centrofisioterapeuta.logica;

import javax.persistence.Entity;
import javax.persistence.OneToOne;

import java.util.Date;

@Entity
public class Recepcionista extends Persona{

    //private int idRecepcionista;
    private String seccionAsignada;
    @OneToOne
    private Usuario usuario;

    public Recepcionista() {
    }

    public Recepcionista(int id, String nombre, String apellido, String cedula, String correo, String telefono, String dirección, Date fechaNacimiento, String seccionAsignada) {
        super(id, nombre, apellido, cedula, correo, telefono, dirección, fechaNacimiento);
        this.seccionAsignada = seccionAsignada;
    }

    public String getSeccionAsignada() {
        return seccionAsignada;
    }

    public void setSeccionAsignada(String secciónAsignada) {
        this.seccionAsignada = secciónAsignada;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
