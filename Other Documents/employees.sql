-- Create the table
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(50)
);

-- Insert data into the table
INSERT INTO employees (id, name, role) VALUES
(1, 'Juan dela Cruz', 'Software Engineer'),
(2, 'Pedro Santiago', 'System Administrator'),
(3, 'Nica Flores', 'DevOps Engineer'),
(4, 'Carlito Bravo', 'Security Analyst'),
(5, 'Rufino Malakas', 'Cloud Architect');