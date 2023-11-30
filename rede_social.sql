CREATE DATABASE redesocial;

USE redesocial;

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE postagens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    texto VARCHAR(280) NOT NULL,
    data_post DATE,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE comentarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    texto VARCHAR(280) NOT NULL,
    data_comentario DATE,
    postagem_id INT,
	usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (postagem_id) REFERENCES postagens(id)
);

CREATE TABLE amizades (
    data_amizade DATE,
    usuario1_id INT,
    usuario2_id INT,
    FOREIGN KEY (usuario1_id) REFERENCES usuarios(id),
    FOREIGN KEY (usuario2_id) REFERENCES usuarios(id)
);

INSERT INTO usuarios (nome) VALUES
('João'),
('Maria'),
('José');

INSERT INTO postagens (texto, data_post, usuario_id) VALUES
('Olá, pessoal!', CURRENT_TIMESTAMP, 1), 
('Bom dia, mundo!',  CURRENT_TIMESTAMP, 2), 
('Bom dia, mundo!',  CURRENT_TIMESTAMP, 3); 

SELECT postagens.*
FROM postagens
INNER JOIN usuarios ON postagens.usuario_id = usuarios.id
WHERE usuarios.nome = 'João';

INSERT INTO comentarios (texto, data_comentario, usuario_id, postagem_id) VALUES
('Olá, pessoal!', CURRENT_TIMESTAMP, 2, 3), 
('Bom dia, mundo!',  CURRENT_TIMESTAMP, 3, 1), 
('Bom dia, mundo!',  CURRENT_TIMESTAMP, 1, 2); 

SELECT comentarios.*
FROM comentarios
INNER JOIN postagens ON comentarios.postagem_id = postagens.id
WHERE comentarios.texto = 'Bom dia, mundo!' AND postagens.id = 1;

SELECT usuarios.nome, COUNT(postagens.id) AS total_postagens, COUNT(comentarios.id) AS total_comentarios
FROM usuarios
LEFT JOIN postagens ON usuarios.id = postagens.usuario_id
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.id;

INSERT INTO amizades (usuario1_id, usuario2_id, data_amizade) VALUES
(1, 2, CURRENT_TIMESTAMP), 
(1, 3, CURRENT_TIMESTAMP);

SELECT usuarios.nome AS usuario1, U2.nome AS usuario2, amizades.data_amizade
FROM amizades
INNER JOIN usuarios ON amizades.usuario1_id = usuarios.id
INNER JOIN usuarios U2 ON amizades.usuario2_id = U2.id
WHERE amizades.data_amizade >= DATE_SUB(NOW(), INTERVAL 30 DAY);

SELECT usuarios.nome AS nome_usuario, postagens.texto AS postagem, amizades.data_amizade, amigos.nome AS nome_amigo
FROM usuarios
LEFT JOIN postagens ON usuarios.id = postagens.usuario_id
LEFT JOIN amizades ON usuarios.id = amizades.usuario1_id OR usuarios.id = amizades.usuario2_id
LEFT JOIN usuarios AS amigos ON (amizades.usuario1_id = amigos.id OR amizades.usuario2_id = amigos.id) AND amigos.id != usuarios.id
WHERE usuarios.nome = 'Maria';



