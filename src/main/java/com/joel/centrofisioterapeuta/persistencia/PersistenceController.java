package com.joel.centrofisioterapeuta.persistencia;

import com.joel.centrofisioterapeuta.logica.*;

import java.util.List;

public class PersistenceController {
    PacienteJpaController pacienteJpa = new PacienteJpaController();
    FisioterapeutaJpaController fisioterapeutaJpa = new FisioterapeutaJpaController();
    HorarioJpaController horarioJpa = new HorarioJpaController();
    RecepcionistaJpaController recepcionistaJpa = new RecepcionistaJpaController();
    ResponsableJpaController responsableJpa = new ResponsableJpaController();
    TurnoJpaController turnoJpa = new TurnoJpaController();
    UsuarioJpaController usuarioJpa = new UsuarioJpaController();


    public List<Paciente> listarPacientes() {
        return pacienteJpa.findPacienteEntities();
    }

    public List<Usuario> listarUsuarios() {
        return usuarioJpa.findUsuarioEntities();
    }

    public void crearUsuario(Usuario nuevoUsuario) {
        usuarioJpa.create(nuevoUsuario);
    }

    public Usuario consultarUsuario(int idUsuarioConsultar) {
        return usuarioJpa.findUsuario(idUsuarioConsultar);
    }

    public void eliminarUsuario(int usuarioAEliminar) {
        usuarioJpa.destroy(usuarioAEliminar);
    }

    public void editarUsuario(Usuario usuarioAEditar) {
        usuarioJpa.edit(usuarioAEditar);
    }

    public List<Recepcionista> listarRecepcionistas() {
        return recepcionistaJpa.findRecepcionistaEntities();
    }

    public Recepcionista consultarRecepcionista(int id) {
        return recepcionistaJpa.findRecepcionista(id);
    }

    public void crearRecepcionista(Recepcionista nuevoRecepcionista) {
        recepcionistaJpa.create(nuevoRecepcionista);
    }

    public void editarRecepcionista(Recepcionista recepcionista) {
        recepcionistaJpa.edit(recepcionista);
    }

    public void eliminarRecepcionista(int idRecepcionistaAEliminar) {
        recepcionistaJpa.destroy(idRecepcionistaAEliminar);
    }

    public void crearResponsable(Responsable responsable) {
        responsableJpa.create(responsable);
    }

    public void crearPaciente(Paciente nuevoPaciente) {
        pacienteJpa.create(nuevoPaciente);
    }

    public Paciente consultarPaciente(int idPacienteAEditar) {
        return pacienteJpa.findPaciente(idPacienteAEditar);
    }

    public Responsable consultarResponsable(int idResponsable) {
        return responsableJpa.findResponsable(idResponsable);
    }

    public void editarResponsable(Responsable responsable) {
        responsableJpa.edit(responsable);
    }

    public void eliminarResponsable(int idResponsable) {
        responsableJpa.destroy(idResponsable);
    }

    public void editarPaciente(Paciente paciente) {
        pacienteJpa.edit(paciente);
    }

    public void eliminarPaciente(int idPacienteAEliminar) {
        pacienteJpa.destroy(idPacienteAEliminar);
    }

    public Fisioterapeuta consultarFisioterapeuta(int idFisioterapeuta) {
        return fisioterapeutaJpa.findFisioterapeuta(idFisioterapeuta);
    }

    public List<Fisioterapeuta> listarFisioterapeutas() {
        return fisioterapeutaJpa.findFisioterapeutaEntities();
    }

    public void crearFisioterapeuta(Fisioterapeuta nuevoFisioterapeuta) {
        fisioterapeutaJpa.create(nuevoFisioterapeuta);
    }

    public void editarFisioterapeuta(Fisioterapeuta fisioterapeuta) {
        fisioterapeutaJpa.edit(fisioterapeuta);
    }

    public void eliminarFisioterapeuta(int idFisioterapeuta) {
        fisioterapeutaJpa.destroy(idFisioterapeuta);
    }

    public List<Horario> listarHorarios() {
        return horarioJpa.findHorarioEntities();
    }

    public void crearHorario(Horario nuevoHorario) {
        horarioJpa.create(nuevoHorario);
    }

    public Horario consultarHorario(int idHorario) {
        return horarioJpa.findHorario(idHorario);
    }

    public void editarHorario(Horario horario) {
        horarioJpa.edit(horario);
    }

    public void eliminarHorario(int idHorario) {
        horarioJpa.destroy(idHorario);
    }

    public void crearTurno(Turno nuevoTurno) {
        turnoJpa.create(nuevoTurno);
    }

    public List<Turno> listarTurnosPorFisioterapeuta(int idFisioterapeuta) {
        return turnoJpa.findTurnosByFisioterapeuta(idFisioterapeuta);
    }

    public List<Turno> listarTurnos() {
        return turnoJpa.findTurnoEntities();
    }

    public Turno consultarTurno(int idTurno) {
        return turnoJpa.findTurno(idTurno);
    }

    public void editarTurno(Turno turno) {
        turnoJpa.edit(turno);
    }

    public void eliminarTurno(int idTurno) {
        turnoJpa.destroy(idTurno);
    }

    public Fisioterapeuta consultarFisioterapeutaPorUsuario(int idUsuario) {
        return fisioterapeutaJpa.findFisioterapeutaByUsuario(idUsuario);
    }
}
