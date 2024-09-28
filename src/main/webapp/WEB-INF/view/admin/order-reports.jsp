<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Insights - ABC Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-styles.css">
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
    <h1 class="mb-4">Order Insights</h1>
    <div class="table-responsive">
        <div class="filter-controls">
            <label for="branch-filter">Branch:</label>
            <select id="branch-filter" class="form-select form-select-sm d-inline-block w-auto">
                <option value="">All</option>
            </select>
            <label for="payment-filter">Payment Status:</label>
            <select id="payment-filter" class="form-select form-select-sm d-inline-block w-auto">
                <option value="">All</option>
                <option value="Paid">Paid</option>
                <option value="Unpaid">Unpaid</option>
            </select>
        </div>
        <table id="adminReportTable" class="table table-striped table-dark">
            <thead>
            <tr>
                <th>Full Name</th>
                <th>Email</th>
                <th>Order Date</th>
                <th>Total Amount</th>
                <th>Status</th>
                <th>Delivery Method</th>
                <th>Branch</th>
                <th>Payment Status</th>
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
                <h3 class="chart-title">Orders by Branch</h3>
                <canvas id="branchChart"></canvas>
            </div>
        </div>
        <div class="col-md-6 mb-4">
            <div class="chart-container">
                <h3 class="chart-title">Order Status</h3>
                <canvas id="statusChart"></canvas>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="chart-container">
                <h3 class="chart-title">Orders Timeline</h3>
                <canvas id="timelineChart"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="chart-container">
                <h3 class="chart-title">Revenue Timeline</h3>
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    const orders = <%= new Gson().toJson(request.getAttribute("orders")) %>;

    $(document).ready(function() {
        // Populate branch filter
        const branches = [...new Set(orders.map(item => item.branch_name))];
        branches.forEach(branch => {
  const option = document.createElement('option');
  option.value = branch;
  option.text = branch;
  document.getElementById('branch-filter').appendChild(option);
});

        // Initialize DataTable
        const table = $('#adminReportTable').DataTable({
            data: orders,
            columns: [
                { data: 'full_name' },
                { data: 'email' },
                { data: 'orderDate' },
                { data: 'totalAmount', render: function(data) { return '$' + data.toFixed(2); } },
                { data: 'status' },
                { data: 'deliveryMethod' },
                { data: 'branch_name' },
                { data: 'paymentStatus' }
            ],
            order: [[2, 'desc']], // Sort by order date descending
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
                const paymentStatus = $('#payment-filter').val();
                const rowBranch = data[6]; // Branch is the 7th column (index 6)
                const rowPaymentStatus = data[7]; // Payment Status is the 8th column (index 7)

                if ((branch === "" || branch === rowBranch) &&
                    (paymentStatus === "" || paymentStatus === rowPaymentStatus)) {
                    return true;
                }
                return false;
            }
        );

        // Event listener for filter changes
        $('#branch-filter, #payment-filter').change(function() {
            table.draw();
        });

        function createBranchChart() {
            const branchCounts = orders.reduce((acc, order) => {
                acc[order.branch_name] = (acc[order.branch_name] || 0) + 1;
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
            const statusCounts = orders.reduce((acc, order) => {
                acc[order.status] = (acc[order.status] || 0) + 1;
                return acc;
            }, {});

            new Chart(document.getElementById('statusChart'), {
                type: 'doughnut',
                data: {
                    labels: Object.keys(statusCounts),
                    datasets: [{
                        data: Object.values(statusCounts),
                        backgroundColor: ['#28a745', '#ffc107', '#dc3545']
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
            const dateCount = orders.reduce((acc, order) => {
                const date = order.orderDate.split(',')[0]; // Extract date part
                acc[date] = (acc[date] || 0) + 1;
                return acc;
            }, {});

            const sortedDates = Object.keys(dateCount).sort();

            new Chart(document.getElementById('timelineChart'), {
                type: 'line',
                data: {
                    labels: sortedDates,
                    datasets: [{
                        label: 'Number of Orders',
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
                                text: 'Number of Orders',
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

        function createRevenueChart() {
            const dateRevenue = orders.reduce((acc, order) => {
                const date = order.orderDate.split(',')[0]; // Extract date part
                acc[date] = (acc[date] || 0) + order.totalAmount;
                return acc;
            }, {});

            const sortedDates = Object.keys(dateRevenue).sort();

            new Chart(document.getElementById('revenueChart'), {
                type: 'bar',
                data: {
                    labels: sortedDates,
                    datasets: [{
                        label: 'Total Revenue',
                        data: sortedDates.map(date => dateRevenue[date]),
                        backgroundColor: '#28a745'
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
                                text: 'Total Revenue ($)',
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
        createRevenueChart();
    });
</script>
</body>
</html>
