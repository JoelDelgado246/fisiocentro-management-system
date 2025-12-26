package com.joel.centrofisioterapeuta.logica;

import javax.persistence.*;
import java.util.Collection;
import java.util.Date;

@Entity
public class Fisioterapeuta extends Persona{

    private String especialidad;
    @OneToMany(mappedBy = "fisio")
    private Collection<Turno> listaDeTurnos;
    @OneToOne
    private  Usuario usuario;
    @ManyToOne
    @JoinColumn(name = "id_horario")
    private Horario horario;

    public Horario getHorario() {
        return horario;
    }

    public void setHorario(Horario horario) {
        this.horario = horario;
    }

    public Fisioterapeuta() {
    }

    public Fisioterapeuta(int id, String nombre, String apellido, String cedula, String correo, String telefono, String dirección, Date fechaNacimiento, String especialidad, Collection<Turno> listaDeTurnos, Usuario usuario, Horario horario) {
        super(id, nombre, apellido, cedula, correo, telefono, dirección, fechaNacimiento);
        this.especialidad = especialidad;
        this.listaDeTurnos = listaDeTurnos;
        this.usuario = usuario;
        this.horario = horario;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public Collection<Turno> getListaDeTurnos() {
        return listaDeTurnos;
    }

    public void setListaDeTurnos(Collection<Turno> listaDeTurnos) {
        this.listaDeTurnos = listaDeTurnos;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
