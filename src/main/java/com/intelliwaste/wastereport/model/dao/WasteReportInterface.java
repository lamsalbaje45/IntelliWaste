package com.intelliwaste.wastereport.model.dao;

import com.intelliwaste.wastereport.model.WasteReport;
import com.intelliwaste.wastereport.model.dto.WasteReportDTO;

import java.util.ArrayList;

public interface WasteReportInterface {
    boolean insertReport(WasteReport report);
    ArrayList<WasteReportDTO> viewAllReports();
    ArrayList<WasteReportDTO> viewReportsByUser(int userId);
    ArrayList<WasteReportDTO> viewReportsByStatus(String status);
    WasteReportDTO viewReportById(int reportId);
    boolean updateStatus(int reportId, String status);
    boolean deleteReport(int reportId, int userId);
}
