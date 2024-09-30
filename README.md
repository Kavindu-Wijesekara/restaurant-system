# ABC Restaurant System

## Introduction
ABC Restaurant System is a comprehensive web application designed to manage restaurant operations efficiently. It provides features for managing reservations, displaying menus, handling orders, and more. The system is built using Java and Bootstrap, ensuring a robust backend and a responsive, user-friendly frontend.

## Features
- **Reservation Management**: Easily add, view, and manage reservations.
- **Menu Display**: Showcase your restaurant's menu with detailed descriptions and prices.
- **Order Handling**: Seamlessly handle customer orders and provide order confirmations.
- **User Authentication**: Secure user registration and login functionality.
- **Responsive Design**: Optimized for both desktop and mobile devices.

## Tech Stack
- **Backend**: Java Servlets
- **Frontend**: JSP, HTML, CSS, JavaScript, jQuery, Bootstrap
- **Build Tool**: Maven
- **Server**: Tomcat 9.0.93
- **Database**: MySQL

## Prerequisites
- JDK 17
- Maven
- Tomcat 9.0.93
- MySQL (or your preferred database)

## How to Clone the Project
1. Open your terminal.
2. Clone the repository:
    ```sh
    git clone https://github.com/Kavindu-Wijesekara/restaurant-system.git
    ```
3. Navigate to the project directory:
    ```sh
    cd abc-restaurant-system
    ```

## Database Setup
1. Create a database in MySQL:
    ```sql
    CREATE DATABASE abc_restaurant;
    ```
2. Import the database schema:
    ```sh
    mysql -u root -p abc_restaurant < table-schema.sql
    ```
3. Update the database connection properties in `src/main/resources/database.properties`:
    ```properties
    db.url=jdbc:mysql://localhost:3306/abc_restaurant
    db.username=root
    db.password=yourpassword
    ```

## How to Build the Project
1. Navigate to the project directory if not already there:
    ```sh
    cd abc-restaurant-system
    ```
2. Build the project using Maven:
    ```sh
    mvn clean install
    ```

## How to Run the Project
1. Open the project with your preferred IDE (e.g., IntelliJ IDEA, Eclipse).
2. Configure Tomcat server:
    - Add a new Tomcat 9.0.93 server configuration.
    - Set the deployment artifact to `abc-restaurant-system:war`.

## How to Access the Application
- Open your web browser and navigate to:
    ```
    http://localhost:8080/abc-restaurant-system
    ```

## Additional Notes
- Ensure that your database server is running and accessible.
- If you encounter any issues, check the logs for more details.

## License
This project is licensed under the MIT License.