USE emprestimos;

DROP TRIGGER IF EXISTS trig_operacao;

DELIMITER //
CREATE TRIGGER trig_operacao
BEFORE INSERT ON operacao
FOR EACH ROW
BEGIN
	UPDATE emprestimo 
		SET valor_atual = valor_atual + NEW.valor 
        WHERE id_emprestimo = NEW.id_emprestimo;
	UPDATE usuario
		SET saldo = saldo - NEW.valor
        WHERE id_usuario = (
			SELECT id_credor 
            FROM emprestimo 
            WHERE id_emprestimo = NEW.id_emprestimo);
	UPDATE usuario
		SET saldo = saldo + NEW.valor
        WHERE id_usuario = (
			SELECT id_devedor 
			FROM emprestimo 
            WHERE id_emprestimo = NEW.id_emprestimo);
END //

CREATE TRIGGER trig_emprestimo_insuficiente
BEFORE UPDATE ON emprestimo
FOR EACH ROW
BEGIN
    -- https://stackoverflow.com/questions/2115497/check-constraint-in-mysql-is-not-working
    IF NEW.valor_atual < 0.0 THEN
        SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Saldo insuficiente.';
    END IF;
END//

DELIMITER ;