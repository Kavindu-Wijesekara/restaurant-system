<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="com.google.gson.JsonSerializer" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reservation Insights - ABC Restaurant</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-styles.css">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      background-color: #121212;
      color: #e0e0e0;
    }
    .navbar {
      background-color: #1a1a1a !important;
    }
    .navbar-brand, .nav-link {
      color: #ffc107 !important;
    }
    .nav-link:hover {
      color: #ffca2c !important;
    }
    .container {
      background-color: #1a1a1a;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
    }
    h1 {
      color: #ffc107;
    }
    .btn-primary {
      background-color: #ffc107;
      border-color: #ffc107;
      color: #121212;
    }
    .btn-primary:hover {
      background-color: #ffca2c;
      border-color: #ffca2c;
      color: #121212;
    }
    .table {
      color: #e0e0e0;
      border-color: #333;
    }
    .table thead th {
      background-color: #ffc107;
      color: #121212;
      border-color: #333;
    }
    .table tbody tr td {
      color: #e0e0e0 !important;
    }
    .table-striped tbody tr:nth-of-type(odd) {
      background-color: rgba(255, 255, 255, 0.05);
    }
    .btn-danger {
      background-color: #dc3545;
      border-color: #dc3545;
    }
    .btn-danger:hover {
      background-color: #bb2d3b;
      border-color: #bb2d3b;
    }
    .filter-controls { margin-bottom: 20px; }
    .filter-controls label { margin-right: 10px; color: #ffc107; }
    .filter-controls select {
      background-color: #2a2a2a;
      color: #e0e0e0;
      border: 1px solid #333;
    }
    .dataTables_wrapper .dataTables_length,
    .dataTables_wrapper .dataTables_filter,
    .dataTables_wrapper .dataTables_info,
    .dataTables_wrapper .dataTables_processing,
    .dataTables_wrapper .dataTables_paginate {
      color: #e0e0e0;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button {
      color: #ffc107 !important;
    }
    .dataTables_wrapper .dataTables_paginate .paginate_button.current,
    .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
      color: #121212 !important;
      background: #ffc107;
      border-color: #ffc107;
    }
    .dt-buttons .btn {
      background-color: #2a2a2a;
      border-color: #333;
      color: #ffc107;
    }
    .dt-buttons .btn:hover {
      background-color: #3a3a3a;
      color: #ffca2c;
    }
    .chart-container {
      background-color: #2a2a2a;
      border-radius: 10px;
      padding: 15px;
      margin-bottom: 20px;
    }
    .chart-title {
      color: #ffc107;
      text-align: center;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">ABC Restaurant</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/admin">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/auth?action-type=logout">Logout</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
<div class="container mt-5">
  <h1 class="mb-4">Reservation Insights</h1>
  <div class="table-responsive">
    <div class="filter-controls">
      <label for="branch-filter">Branch:</label>
      <select id="branch-filter" class="form-select form-select-sm d-inline-block w-auto">
        <option value="">All</option>
      </select>
      <label for="status-filter">Status:</label>
      <select id="status-filter" class="form-select form-select-sm d-inline-block w-auto">
        <option value="">All</option>
        <option value="Pending">Pending</option>
        <option value="Confirmed">Confirmed</option>
        <option value="Cancelled">Cancelled</option>
      </select>
    </div>
    <table id="reservationReportTable" class="table table-striped table-dark">
      <thead>
      <tr>
        <th>Reservation ID</th>
        <th>Customer Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Date</th>
        <th>Time</th>
        <th>People</th>
        <th>Type</th>
        <th>Status</th>
        <th>Branch</th>
      </tr>
      </thead>
      <tbody>
      <!-- Data will be populated by JavaScript -->
      </tbody>
    </table>
  </div>
  <div class="row">
    <div class="col-md-6 mb-4">
      <div class="chart-container">
        <h3 class="chart-title">Reservations by Branch</h3>
        <canvas id="branchChart"></canvas>
      </div>
    </div>
    <div class="col-md-6 mb-4">
      <div class="chart-container">
        <h3 class="chart-title">Reservation Status</h3>
        <canvas id="statusChart"></canvas>
      </div>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-12">
      <div class="chart-container">
        <h3 class="chart-title">Reservations Timeline</h3>
        <canvas id="timelineChart"></canvas>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.print.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>

  <%
        // Create custom Gson instance with LocalDate and LocalTime adapters
        JsonSerializer<LocalDate> localDateSerializer = (src, typeOfSrc, context) ->
            src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE));

        JsonSerializer<LocalTime> localTimeSerializer = (src, typeOfSrc, context) ->
            src == null ? null : context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_TIME));

        Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, localDateSerializer)
            .registerTypeAdapter(LocalTime.class, localTimeSerializer)
            .create();
    %>
  const reservations = <%= gson.toJson(request.getAttribute("reservations")) %>;

  $(document).ready(function() {
    // Populate branch filter
    const branches = [...new Set(reservations.map(item => item.branch_name))];
    branches.forEach(branch => {
      const option = document.createElement('option');
      option.value = branch;
      option.text = branch;
      document.getElementById('branch-filter').appendChild(option);
    });

    // Initialize DataTable
    const table = $('#reservationReportTable').DataTable({
      data: reservations,
      columns: [
        { data: 'reservation_id' },
        { data: 'customer_name' },
        { data: 'customer_email' },
        { data: 'customer_phone' },
        { data: 'reservation_date' },
        { data: 'reservation_time' },
        { data: 'number_of_people' },
        { data: 'reservation_type' },
        { data: 'status' },
        { data: 'branch_name' }
      ],
      order: [[4, 'desc'], [5, 'desc']], // Sort by date and time descending
      pageLength: 10,
      responsive: true,
      dom: 'Bfrtip',
      buttons: [
        'copy', 'csv', 'excel', 'pdf', 'print'
      ]
    });

    // Custom filtering function
    $.fn.dataTable.ext.search.push(
            function( settings, data, dataIndex ) {
              const branch = $('#branch-filter').val();
              const status = $('#status-filter').val();
              const rowBranch = data[9]; // Branch is the 10th column (index 9)
              const rowStatus = data[8]; // Status is the 9th column (index 8)

              if ((branch === "" || branch === rowBranch) &&
                      (status === "" || status === rowStatus)) {
                return true;
              }
              return false;
            }
    );

    // Event listener for filter changes
    $('#branch-filter, #status-filter').change(function() {
      table.draw();
    });

    function createBranchChart() {
      const branchCounts = reservations.reduce((acc, res) => {
        acc[res.branch_name] = (acc[res.branch_name] || 0) + 1;
        return acc;
      }, {});

      new Chart(document.getElementById('branchChart'), {
        type: 'pie',
        data: {
          labels: Object.keys(branchCounts),
          datasets: [{
            data: Object.values(branchCounts),
            backgroundColor: ['#ffc107', '#17a2b8', '#28a745', '#dc3545']
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top',
              labels: {
                color: '#e0e0e0'
              }
            }
          }
        }
      });
    }

    function createStatusChart() {
      const statusCounts = reservations.reduce((acc, res) => {
        acc[res.status] = (acc[res.status] || 0) + 1;
        return acc;
      }, {});

      new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
          labels: Object.keys(statusCounts),
          datasets: [{
            data: Object.values(statusCounts),
            backgroundColor: ['#dc3545', '#ffc107', '#28a745']
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top',
              labels: {
                color: '#e0e0e0'
              }
            }
          }
        }
      });
    }

    function createTimelineChart() {
      const dateCount = reservations.reduce((acc, res) => {
        acc[res.reservation_date] = (acc[res.reservation_date] || 0) + 1;
        return acc;
      }, {});

      const sortedDates = Object.keys(dateCount).sort();

      new Chart(document.getElementById('timelineChart'), {
        type: 'line',
        data: {
          labels: sortedDates,
          datasets: [{
            label: 'Number of Reservations',
            data: sortedDates.map(date => dateCount[date]),
            borderColor: '#ffc107',
            tension: 0.1
          }]
        },
        options: {
          responsive: true,
          scales: {
            x: {
              title: {
                display: true,
                text: 'Date',
                color: '#e0e0e0'
              },
              ticks: {
                color: '#e0e0e0'
              }
            },
            y: {
              title: {
                display: true,
                text: 'Number of Reservations',
                color: '#e0e0e0'
              },
              ticks: {
                color: '#e0e0e0'
              }
            }
          },
          plugins: {
            legend: {
              labels: {
                color: '#e0e0e0'
              }
            }
          }
        }
      });
    }

    // Create charts
    createBranchChart();
    createStatusChart();
    createTimelineChart();
  });
</script>
</body>
</html>
