# 👥 EZ Employee Tracking

A web-based **Employee Management and Tracking System** built with Ruby on Rails. The application helps organizations manage employees, departments, teams, projects, tasks, attendance, work logs, events, and performance reports from a centralized platform.

---

## ✨ Features

### 👤 Employee Management

* Employee registration and authentication
* Employee profile management
* Employee directory
* Employee search
* Role and permission management
* Unique employee identification

### 🏢 Department & Team Management

* Create and manage departments
* Organize employees into teams
* View team members
* Assign projects to departments and teams

### 📁 Project Management

* Create and manage projects
* Associate projects with teams and employees
* Track project-related tasks
* View projects assigned to individual employees

### ✅ Task Management

* Create and assign tasks
* Track task status
* Update task progress
* Log time spent on tasks
* View employee-specific tasks

### 🕒 Attendance Tracking

* Record employee attendance
* View individual attendance history
* Generate employee attendance reports
* Export attendance reports

### 📅 Events

* Create and manage organizational events
* View upcoming events

### 💬 Messaging

* Internal messaging functionality
* Communication between users within the system

### 📊 Reports

The application includes reporting functionality for:

* Employee performance and velocity
* Team tasks
* Employee attendance
* Task reports
* PDF and CSV report exports

---

## 🛠️ Tech Stack

### Backend

* **Ruby**
* **Ruby on Rails 4.2**
* **MySQL**

### Authentication & Authorization

* **Devise**
* **CanCanCan**

### Frontend

* **HTML**
* **CSS / Sass**
* **JavaScript**
* **jQuery**
* **CoffeeScript**
* **Bootstrap**

### Other Tools & Libraries

* **RSpec** — Testing
* **Capybara** — Feature testing
* **Faye** — Real-time messaging support
* **Paperclip** — File attachments
* **Wicked PDF** — PDF generation
* **wkhtmltopdf** — PDF rendering
* **WillPaginate** — Pagination

These dependencies are defined in the project's Gemfile.

---

## 🏗️ Application Structure

```text
ez_employee_tracking/
│
├── app/
│   ├── controllers/       # Application controllers
│   ├── models/            # ActiveRecord models
│   ├── views/             # Application views
│   ├── assets/            # Stylesheets and JavaScript
│   └── helpers/           # View helpers
│
├── config/
│   ├── routes.rb          # Application routes
│   └── database.yml       # Database configuration
│
├── db/
│   └── migrations/        # Database migrations
│
├── lib/                   # Custom libraries and tasks
├── public/                # Public assets
├── spec/                  # RSpec tests
├── test/                  # Rails tests
│
├── Gemfile
├── Rakefile
├── config.ru
└── README.md
```

The project follows the standard Rails MVC architecture. The repository includes application, database, test, and reporting components.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Ruby
* Bundler
* MySQL
* Node.js (recommended for asset dependencies)

Because this project uses **Ruby on Rails 4.2**, you may need a Ruby version compatible with the dependencies in the included `Gemfile.lock`.

---

### 1. Clone the Repository

```bash
git clone https://github.com/zainsaleem4338/ez_employee_tracking.git
```

### 2. Navigate to the Project

```bash
cd ez_employee_tracking
```

### 3. Install Dependencies

```bash
bundle install
```

### 4. Configure the Database

Update the database configuration in:

```text
config/database.yml
```

Configure your MySQL credentials and database settings.

### 5. Create the Database

```bash
bundle exec rake db:create
```

### 6. Run Database Migrations

```bash
bundle exec rake db:migrate
```

If seed data is available, run:

```bash
bundle exec rake db:seed
```

### 7. Start the Application

```bash
bundle exec rails server
```

The application should then be available at:

```text
http://localhost:3000
```

---

## 🧭 Core Workflow

The application supports the following general workflow:

```text
Admin / Manager
       │
       ▼
Manage Employees
       │
       ▼
Create Departments & Teams
       │
       ▼
Create Projects
       │
       ▼
Assign Tasks
       │
       ▼
Employees Update Tasks & Log Time
       │
       ├──► Attendance Tracking
       │
       ├──► Events & Messages
       │
       ▼
Generate Performance & Attendance Reports
```

---

## 🔐 Authentication

Employee authentication is handled using **Devise**.

The application routes employee authentication through Devise and provides employee-related resources and functionality.

---

## 📊 Reporting

The reporting system includes functionality for:

* Employee velocity reports
* Attendance reports
* Team task reports
* Task reports
* PDF exports
* CSV exports

The application's routes define dedicated report endpoints and export functionality.

---

## 🧪 Testing

The project includes testing dependencies such as:

* RSpec
* Capybara
* Database Cleaner
* Factory Girl
* Faker
* SimpleCov

Run the test suite with:

```bash
bundle exec rspec
```

Testing and development dependencies are defined in the Gemfile.

---

## 📁 Main Modules

| Module      | Functionality                               |
| ----------- | ------------------------------------------- |
| Employees   | Employee management and profiles            |
| Attendance  | Track and review employee attendance        |
| Departments | Organize employees and teams                |
| Teams       | Group employees into teams                  |
| Projects    | Create and manage projects                  |
| Tasks       | Assign, track, and update tasks             |
| Time Logs   | Track time spent on tasks                   |
| Events      | Manage organizational events                |
| Messages    | Internal communication                      |
| Reports     | Generate attendance and performance reports |
| Settings    | Application configuration                   |

---

## 🔮 Future Improvements

Potential enhancements for the project include:

* [ ] Upgrade to a modern version of Ruby on Rails
* [ ] Add a REST API
* [ ] Add role-based dashboards
* [ ] Improve the mobile experience
* [ ] Add real-time notifications
* [ ] Add employee leave management
* [ ] Add dashboard analytics and charts
* [ ] Add automated email notifications
* [ ] Containerize the application with Docker
* [ ] Add CI/CD pipelines
* [ ] Improve test coverage

---

## 🤝 Contributing

Contributions and improvements are welcome.

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/your-feature
```

3. Commit your changes

```bash
git commit -m "Add your feature"
```

4. Push the branch

```bash
git push origin feature/your-feature
```

5. Open a Pull Request

---

## 👨‍💻 Author

**Zain Saleem**

GitHub: [@zainsaleem4338](https://github.com/zainsaleem4338)

---

## 📄 License

This project is available for educational, portfolio, and development purposes.

---

<p align="center">
  Built with ❤️ using Ruby on Rails
</p>
