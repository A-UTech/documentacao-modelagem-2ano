
-- Função para log de admin
CREATE OR REPLACE FUNCTION log_admin() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_admin int;
BEGIN
	v_id_admin := current_setting('log.admin_id', true)::int;
	-- Se não existir, não faz nada
	IF v_id_admin IS NULL THEN
		RETURN NULL;
	END IF;
	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;
	INSERT INTO admin_log (
		tabela, id_afetado, operacao, id_admin, data_hora
	) VALUES (
		TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_admin, NOW()
	);
	RETURN NULL;
END;
$$;

-- Função para log de supervisor
CREATE OR REPLACE FUNCTION log_supervisor() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_supervisor int;
BEGIN
	v_id_supervisor := current_setting('log.supervisor_id', true)::int;

	IF v_id_supervisor IS NULL THEN
		RETURN NULL;
	END IF;
	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;
	INSERT INTO supervisor_log (
		tabela, id_afetado, operacao, id_supervisor, data_hora
	) VALUES (
		TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_supervisor, NOW()
	);
	RETURN NULL;
END;
$$;

-- Trigger para admin
CREATE OR REPLACE TRIGGER trg_log_admin
AFTER INSERT OR UPDATE OR DELETE ON admin
FOR EACH ROW EXECUTE FUNCTION log_admin();

-- Trigger para supervisor
CREATE OR REPLACE TRIGGER trg_log_supervisor
AFTER INSERT OR UPDATE OR DELETE ON supervisor
FOR EACH ROW EXECUTE FUNCTION log_supervisor();

-- Procedure para inserir unidade e verificar empresa
CREATE OR REPLACE PROCEDURE inserir_unidade_por_nome(
    p_nome_unidade VARCHAR,
    p_endereco VARCHAR,
    p_nome_empresa VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_empresa INTEGER;
BEGIN
    -- Buscar o ID da empresa pelo nome, ignorando maiúsculas, espaços e acentos
    SELECT id INTO v_id_empresa
    FROM empresa
    WHERE 
        -- normaliza: remove espaços e converte para minúsculas
        LOWER(REGEXP_REPLACE(TRIM(nome), '[^a-zA-Z0-9]', '', 'g')) =
        LOWER(REGEXP_REPLACE(TRIM(p_nome_empresa), '[^a-zA-Z0-9]', '', 'g'))
    LIMIT 1;

    -- Se não encontrar
    IF v_id_empresa IS NULL THEN
        RAISE EXCEPTION 'Empresa "%" não encontrada', p_nome_empresa;
    END IF;

    -- Inserir a unidade
    INSERT INTO unidade (nome, endereco, id_empresa)
    VALUES (p_nome_unidade, p_endereco, v_id_empresa);
END;
$$;



-- Função para autenticação de gestor
CREATE OR REPLACE FUNCTION autenticar_gestor(
	p_email VARCHAR,
	p_senha VARCHAR
)
RETURNS TABLE (
	id INTEGER,
	nome VARCHAR,
	email VARCHAR,
	cpf VARCHAR,
	id_empresa INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
	RETURN QUERY
		SELECT id, nome, email, cpf, id_empresa
		FROM gestor
		WHERE email = p_email AND senha = p_senha;
END;
$$;