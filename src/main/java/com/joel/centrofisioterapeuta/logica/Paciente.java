package com.joel.centrofisioterapeuta.logica;

import javax.persistence.Entity;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import java.util.Collection;
import java.util.Date;

@Entity
public class Paciente extends Persona{

    //private int idPaciente;
    private boolean poseeSeguro;
    private String tipoTratamiento;
    private String motivoConsulta;
    @OneToOne
    private Responsable responsable;
    @OneToMany (mappedBy = "pacient")
    private Collection<Turno> listaDeTurnos;

    public Paciente() {
    }

    public Paciente(int id, String nombre, String apellido, String cedula, String correo, String telefono, String dirección, Date fechaNacimiento, boolean poseeSeguro, String tipoTratamiento, String motivoConsulta, Responsable responsable, Collection<Turno> listaDeTurnos) {
        super(id, nombre, apellido, cedula, correo, telefono, dirección, fechaNacimiento);
        this.poseeSeguro = poseeSeguro;
        this.tipoTratamiento = tipoTratamiento;
        this.motivoConsulta = motivoConsulta;
        this.responsable = responsable;
        this.listaDeTurnos = listaDeTurnos;
    }


    public void setPoseeSeguro(boolean poseeSeguro) {
        this.poseeSeguro = poseeSeguro;
    }

    public void setTipoTratamiento(String tipoTratamiento) {
        this.tipoTratamiento = tipoTratamiento;
    }

    public void setMotivoConsulta(String motivoConsulta) {
        this.motivoConsulta = motivoConsulta;
    }

    public void setResponsable(Responsable responsable) {
        this.responsable = responsable;
    }

    public void setListaDeTurnos(Collection<Turno> listaDeTurnos) {
        this.listaDeTurnos = listaDeTurnos;
    }


    public boolean isPoseeSeguro() {
        return poseeSeguro;
    }

    public String getTipoTratamiento() {
        return tipoTratamiento;
    }

    public String getMotivoConsulta() {
        return motivoConsulta;
    }

    public Responsable getResponsable() {
        return responsable;
    }

    public Collection<Turno> getListaDeTurnos() {
        return listaDeTurnos;
    }
}
