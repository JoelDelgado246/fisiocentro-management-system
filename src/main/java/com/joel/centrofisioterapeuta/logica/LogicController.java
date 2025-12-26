package com.joel.centrofisioterapeuta.logica;

import com.joel.centrofisioterapeuta.persistencia.PersistenceController;

import java.util.List;

public class LogicController {

    PersistenceController persistController = new PersistenceController();


    public List<Paciente> traerPacientesLogico() {
        return persistController.listarPacientes();
    }

    public List<Usuario> traerUsuariosLogico() {
        return persistController.listarUsuarios();
    }

    public void crearUsuarioLogico(Usuario nuevoUsuario) {
        persistController.crearUsuario(nuevoUsuario);
    }

    public Usuario traerUsuarioLogico(int idUsuarioConsultar) {
        return persistController.consultarUsuario(idUsuarioConsultar);
    }

    public void eliminarUsuarioLogico(int usuarioAEliminar) {
        persistController.eliminarUsuario(usuarioAEliminar);
    }

    public void editarUsuarioLogico(Usuario usuarioAEditar) {
        persistController.editarUsuario(usuarioAEditar);
    }

    public List<Recepcionista> traerRecepcionistasLogico() {
        return persistController.listarRecepcionistas();
    }

    public Recepcionista traerRecepcionistaLogico(int id) {
        return persistController.consultarRecepcionista(id);
    }

    public void crearRecepcionistaLogico(Recepcionista nuevoRecepcionista) {
        persistController.crearRecepcionista(nuevoRecepcionista);
    }

    public void editarRecepcionistaLogico(Recepcionista recepcionista) {
        persistController.editarRecepcionista(recepcionista);
    }

    public void eliminarRecepcionistaLogico(int idRecepcionistaAEliminar) {
        persistController.eliminarRecepcionista(idRecepcionistaAEliminar);
    }

    public void crearResponsableLogico(Responsable responsable) {
        persistController.crearResponsable(responsable);
    }

    public void crearPacienteLogico(Paciente nuevoPaciente) {
        persistController.crearPaciente(nuevoPaciente);
    }

    public Paciente traerPacienteLogico(int idPacienteAEditar) {
        return persistController.consultarPaciente(idPacienteAEditar);
    }

    public Responsable traerResponsableLogico(int idResponsable) {
        return persistController.consultarResponsable(idResponsable);
    }

    public void editarResponsableLogico(Responsable responsable) {
        persistController.editarResponsable(responsable);
    }

    public void eliminarResponsableLogico(int idResponsable) {
        persistController.eliminarResponsable(idResponsable);
    }

    public void editarPacienteLogico(Paciente paciente) {
        persistController.editarPaciente(paciente);
    }

    public void eliminarPacienteLogico(int idPacienteAEliminar) {
        persistController.eliminarPaciente(idPacienteAEliminar);
    }

    public Fisioterapeuta traerFisioterapeutaLogico(int idFisioterapeuta) {
        return persistController.consultarFisioterapeuta(idFisioterapeuta);
    }

    public List<Fisioterapeuta> traerFisioterapeutasLogico() {
        return persistController.listarFisioterapeutas();
    }

    public void crearFisioterapeutaLogico(Fisioterapeuta nuevoFisioterapeuta) {
        persistController.crearFisioterapeuta(nuevoFisioterapeuta);
    }

    public void editarFisioterapeutaLogico(Fisioterapeuta fisioterapeuta) {
        persistController.editarFisioterapeuta(fisioterapeuta);
    }

    public void eliminarFisioterapeutaLogico(int idFisioterapeuta) {
        persistController.eliminarFisioterapeuta(idFisioterapeuta);
    }

    public List<Horario> traerHorariosLogico() {
        return persistController.listarHorarios();
    }

    public void crearHorarioLogico(Horario nuevoHorario) {
        persistController.crearHorario(nuevoHorario);
    }

    public Horario traerHorarioLogico(int idHorario) {
        return persistController.consultarHorario(idHorario);
    }

    public void editarHorarioLogico(Horario horario) {
        persistController.editarHorario(horario);
    }

    public void eliminarHorarioLogico(int idHorario) {
        persistController.eliminarHorario(idHorario);
    }

    public void crearTurnoLogico(Turno nuevoTurno) {
        persistController.crearTurno(nuevoTurno);
    }

    public List<Turno> traerTurnosPorFisioterapeutaLogico(int idFisioterapeuta) {
        return persistController.listarTurnosPorFisioterapeuta(idFisioterapeuta);
    }

    public List<Turno> traerTurnosLogico() {
        return persistController.listarTurnos();
    }

    public Turno traerTurnoLogico(int idTurno) {
        return persistController.consultarTurno(idTurno);
    }

    public void editarTurnoLogico(Turno turno) {
        persistController.editarTurno(turno);
    }

    public void eliminarTurnoLogico(int idTurno) {
        persistController.eliminarTurno(idTurno);
    }

    public Fisioterapeuta traerFisioterapeutaPorUsuarioLogico(int idUsuario) {
        return persistController.consultarFisioterapeutaPorUsuario(idUsuario);
    }
}
