CREATE DATABASE VOTACIONES;
GO

USE VOTACIONES
GO

CREATE TABLE Admini (
    nombreAdmin VARCHAR(100) PRIMARY KEY,
    contraseña VARCHAR(100) NOT NULL UNIQUE,
);
GO

CREATE TABLE Candidatos (
    CandidatoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    PartidoPolitico VARCHAR(100) NOT NULL,
    Plataforma TEXT NOT NULL
);
GO


CREATE TABLE Votantes (
    ID INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    Contraseña VARCHAR(100) NOT NULL UNIQUE,
    FechaNacimiento DATE NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT check_age CHECK (DATEDIFF(YEAR, FechaNacimiento, GETDATE()) >= 18)
);
GO


USE VOTACIONES;
GO

CREATE TABLE Votos (
    VotoID INT IDENTITY(1,1) PRIMARY KEY,
    VotanteID INT NOT NULL,
    CandidatoID INT NOT NULL,
    FechaVoto DATE NOT NULL,
    FOREIGN KEY (VotanteID) REFERENCES Votantes(ID),
    FOREIGN KEY (CandidatoID) REFERENCES Candidatos(CandidatoID)
);
GO

USE VOTACIONES;
GO

CREATE TABLE Resultados (
    ResultadoID INT IDENTITY(1,1) PRIMARY KEY,
    CandidatoID INT NOT NULL,
    VotosTotales INT NOT NULL,
    PorcentajeVotos DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (CandidatoID) REFERENCES Candidatos(CandidatoID)
);
GO


INSERT INTO Admini(nombreAdmin, contraseña)
VALUES
('Administrador', '123');

SELECT * FROM Admini; 

INSERT INTO Candidatos (Nombre, PartidoPolitico, Plataforma)
VALUES
('Juan Pérez', 'Partido A', 'Presidente'),
('María Gómez', 'Partido B', 'Vicepresidente'),
('Carlos Rodríguez', 'Partido C', 'Tesorero');

INSERT INTO Votantes (ID, Nombre, Contraseña, FechaNacimiento, Direccion, Correo)
VALUES
(123, 'Ana Martínez', 'a123', '1985-03-25', 'Calle 123, Ciudad', 'example@gmail.com'),
(234, 'Luis Fernández', 'l123', '1990-07-15', 'Avenida 456, Ciudad', 'example1@gmail.com'),
(345, 'Laura López', 'll123', '2000-11-30', 'Boulevard 789, Ciudad', 'example2@gmail.com');


SELECT * FROM Candidatos;
SELECT * FROM Votantes; 

INSERT INTO Votos (VotanteID, CandidatoID, FechaVoto)
VALUES
(123, 1, '2024-07-15'),
(234, 2, '2024-07-15'),
(345, 3, '2024-07-15');

SELECT 
    V.VotoID,
    V.FechaVoto,
    C.Nombre AS NombreCandidato,
    T.Nombre AS NombreVotante
FROM 
    Votos V
JOIN 
    Candidatos C ON V.CandidatoID = C.CandidatoID
JOIN 
    Votantes T ON V.VotanteID = T.ID;


INSERT INTO Resultados (CandidatoID, VotosTotales, PorcentajeVotos)
SELECT 
    CandidatoID,
    COUNT(*) AS VotosTotales,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Votos) AS DECIMAL(5, 2)) AS PorcentajeVotos
FROM 
    Votos
GROUP BY 
    CandidatoID;

SELECT 
    R.ResultadoID,
    C.Nombre AS NombreCandidato,
    R.VotosTotales,
    R.PorcentajeVotos
FROM 
    Resultados R
JOIN 
    Candidatos C ON R.CandidatoID = C.CandidatoID;
