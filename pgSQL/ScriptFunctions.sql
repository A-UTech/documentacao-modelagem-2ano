-- FUNÇÕES DE TRIGGER PARA TABELAS LOG
-- Função para 'ADMIN_LOG'
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

-- Função para 'GESTOR_LOG'
CREATE OR REPLACE FUNCTION log_gestor() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_gestor int;
BEGIN
	v_id_gestor := current_setting('log.gestor_id', true)::int;

	IF v_id_gestor IS NULL THEN
		RETURN NULL;
	END IF;
	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;
	INSERT INTO gestor_log (
		tabela, id_afetado, operacao, id_gestor, data_hora
	) VALUES (
		TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_gestor, NOW()
	);
	RETURN NULL;
END;
$$;

-- Função para 'EMPRESA_LOG'
CREATE OR REPLACE FUNCTION log_empresa() RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_empresa int;
	v_id_unidade int;
BEGIN
	v_id_empresa := current_setting('log.empresa_id', true)::int;
	v_id_unidade := current_setting('log.unidade_id')

	IF v_id_empresa IS NULL OR v_id_unidade IS NULL THEN
		RETURN NULL;
	END IF;
	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;
	INSERT INTO empresa_log(
		tabela, id_afetado, operacao, id_empresa, id_unidade, data_hora
	) VALUES (
		TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_empresa, v_id_unidade, NOW()
	);
	RETURN NULL;
END;
$$;

-- =====================================================
-- TRIGGERS PARA TABELAS DE LOG
-- Triggers para 'ADMIN_LOG'
-- tabela 'admin'
CREATE OR REPLACE TRIGGER trg_log_admin
AFTER INSERT OR UPDATE OR DELETE ON admin
FOR EACH ROW EXECUTE FUNCTION log_admin();

-- tabela 'planos'
CREATE OR REPLACE TRIGGER trg_log_admin_planos
AFTER INSERT OR UPDATE OR DELETE ON planos
FOR EACH ROW EXECUTE FUNCTION log_admin();

-- tabela 'condena'
CREATE OR REPLACE TRIGGER trg_log_admin_condena
AFTER INSERT OR UPDATE OR DELETE ON condena
FOR EACH ROW EXECUTE FUNCTION log_admin();
-- =====================================================

-- Triggers para 'GESTOR_LOG'
-- tabela 'lider'
CREATE OR REPLACE TRIGGER trg_log_gestor_lider
AFTER INSERT OR UPDATE OR DELETE ON lider
FOR EACH ROW EXECUTE FUNCTION log_gestor();

-- tabela 'gestor'
CREATE OR REPLACE TRIGGER trg_log_gestor
AFTER INSERT OR UPDATE OR DELETE ON gestor
FOR EACH ROW EXECUTE FUNCTION log_gestor();

-- tabela 'condena_gestor'
CREATE OR REPLACE TRIGGER trg_log_gestor_condena
AFTER INSERT OR UPDATE OR DELETE ON condena_gestor
FOR EACH ROW EXECUTE FUNCTION log_gestor();

-- =====================================================

-- Triggers para 'EMPRESA_LOG'
-- tabela 'empresa'
CREATE OR REPLACE TRIGGER trg_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON empresa
FOR EACH ROW EXECUTE FUNCTION log_empresa();

-- tabela 'unidade'
CREATE OR REPLACE TRIGGER trg_log_empresa_unidade
AFTER INSERT OR UPDATE OR DELETE ON unidade
FOR EACH ROW EXECUTE FUNCTION log_empresa();

-- PROCEDURES ==========================================

-- Procedure 1 (inserir unidade e verificar empresa)
CREATE OR REPLACE PROCEDURE inserir_unidade_por_nome(
    p_nome_unidade VARCHAR,
    p_estado VARCHAR,
	p_cidade VARCHAR,
	p_cnpj VARCHAR,
	p_id_plano INTEGER,
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
        -- remove espaços e converte para minúsculas
        LOWER(REGEXP_REPLACE(TRIM(nome), '[^a-zA-Z0-9]', '', 'g')) =
        LOWER(REGEXP_REPLACE(TRIM(p_nome_empresa), '[^a-zA-Z0-9]', '', 'g'))
    LIMIT 1;

    -- Se não encontrar
    IF v_id_empresa IS NULL THEN
        RAISE EXCEPTION 'Empresa "%" não encontrada', p_nome_empresa;
    END IF;

    -- Inserir a unidade
    INSERT INTO unidade (nome, estado, cidade, cnpj, id_plano, id_empresa)
    VALUES (p_nome_unidade, p_estado, p_cidade, p_cnpj, p_id_plano, v_id_empresa);
END;
$$;

-- FUNCTIONS ===========================================
-- Function 1 (Verificar se o usuário é gestor ou lider)
CREATE OR REPLACE FUNCTION autenticar_usuario( 
    p_email VARCHAR,
    p_senha VARCHAR
)
RETURNS TABLE (
    id INTEGER,
    nome VARCHAR,
    email VARCHAR,
    cpf VARCHAR,
    id_empresa INTEGER,
    tipo_usuario VARCHAR
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Tenta autenticar como gestor
    RETURN QUERY
    SELECT id, nome, email, cpf, id_empresa, 'gestor' AS tipo_usuario
    FROM gestor
    WHERE email = p_email AND senha = p_senha;

    -- Se não encontrar gestor, tenta líder
    RETURN QUERY
    SELECT id, nome, email, cpf, id_empresa, 'lider' AS tipo_usuario
    FROM lider
    WHERE email = p_email AND senha = p_senha;
END;
$$;