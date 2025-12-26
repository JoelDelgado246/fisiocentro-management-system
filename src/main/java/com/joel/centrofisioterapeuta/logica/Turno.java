package com.joel.centrofisioterapeuta.logica;

import com.joel.centrofisioterapeuta.enums.EstadoTurno;

import javax.persistence.*;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
public class Turno {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idTurno;

    private LocalDate fechaTurno;
    private LocalTime horaTurno;
    private String observacion;
    private EstadoTurno estado;

    @ManyToOne
    @JoinColumn(name = "id_fisioterapeuta")
    private Fisioterapeuta fisio;

    @ManyToOne
    @JoinColumn(name = "id_pacient")
    private Paciente pacient;

    public Paciente getPacient() {
        return pacient;
    }

    public void setPacient(Paciente pacient) {
        this.pacient = pacient;
    }

    public Fisioterapeuta getFisio() {
        return fisio;
    }

    public void setFisio(Fisioterapeuta fisio) {
        this.fisio = fisio;
    }

    public Turno() {
    }

    public Turno(int idTurno, LocalDate fechaTurno, LocalTime horaTurno, String observacion, EstadoTurno estado) {
        this.idTurno = idTurno;
        this.fechaTurno = fechaTurno;
        this.horaTurno = horaTurno;
        this.observacion = observacion;
        this.estado = estado;
    }

    public int getIdTurno() {
        return idTurno;
    }

    public void setIdTurno(int idTurno) {
        this.idTurno = idTurno;
    }

    public LocalDate getFechaTurno() {
        return fechaTurno;
    }

    public void setFechaTurno(LocalDate fechaTurno) {
        this.fechaTurno = fechaTurno;
    }

    public LocalTime getHoraTurno() {
        return horaTurno;
    }

    public void setHoraTurno(LocalTime horaTurno) {
        this.horaTurno = horaTurno;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public EstadoTurno getEstado() {
        return estado;
    }

    public void setEstado(EstadoTurno estado) {
        this.estado = estado;
    }
}
