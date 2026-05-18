package com.intelliwaste.assignment.model.dao;

import com.intelliwaste.assignment.model.Assignment;
import com.intelliwaste.assignment.model.dto.AssignmentDTO;

import java.util.ArrayList;

public interface AssignmentInterface {
    boolean assignReport(Assignment assignment);
    ArrayList<AssignmentDTO> viewAssignmentsByWorker(int workerId);
    ArrayList<AssignmentDTO> viewAllAssignments();
    boolean updateAssignmentStatus(int assignmentId, String status, String workerNotes);
}
