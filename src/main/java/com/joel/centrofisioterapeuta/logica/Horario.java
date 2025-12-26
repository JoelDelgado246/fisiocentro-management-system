package com.joel.centrofisioterapeuta.logica;

import com.joel.centrofisioterapeuta.enums.DiaDeSemana;

import javax.persistence.*;
import java.time.LocalTime;
import java.util.Collection;

@Entity
public class Horario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idHorario;
    @Enumerated(EnumType.STRING)
    private DiaDeSemana diaDeSemana;
    private LocalTime horaInicio;
    private LocalTime horaFin;
    @OneToMany(mappedBy = "horario")
    private Collection<Fisioterapeuta> fisioterapeutaAsociado;

    public Horario(int idHorario, DiaDeSemana diaDeSemana, LocalTime horaInicio, LocalTime horaFin, Collection<Fisioterapeuta> fisioterapeutaAsociado) {
        this.idHorario = idHorario;
        this.diaDeSemana = diaDeSemana;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.fisioterapeutaAsociado = fisioterapeutaAsociado;
    }

    public Horario() {

    }

    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public DiaDeSemana getDiaDeSemana() {
        return diaDeSemana;
    }

    public void setDiaDeSemana(DiaDeSemana diaDeSemana) {
        this.diaDeSemana = diaDeSemana;
    }

    public LocalTime getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(LocalTime horaInicio) {
        this.horaInicio = horaInicio;
    }

    public LocalTime getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(LocalTime horaFin) {
        this.horaFin = horaFin;
    }

    public Collection<Fisioterapeuta> getFisioterapeutaAsociado() {
        return fisioterapeutaAsociado;
    }

    public void setFisioterapeutaAsociado(Collection<Fisioterapeuta> fisioterapeutaAsociado) {
        this.fisioterapeutaAsociado = fisioterapeutaAsociado;
    }
}
