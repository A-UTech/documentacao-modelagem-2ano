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
SET log.empresa_id = '1';
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
    -- Verifica se a empresa existe
    v_id_empresa := verificar_empresa_existente(p_nome_empresa, p_cnpj);

    IF v_id_empresa IS NULL THEN
        RAISE EXCEPTION 'Empresa "%" não encontrada ou não corresponde ao CNPJ informado.', p_nome_empresa;
    END IF;

    -- Insere a unidade
    INSERT INTO unidade (nome, estado, cidade, cnpj, id_plano, id_empresa)
    VALUES (p_nome_unidade, p_estado, p_cidade, p_cnpj, p_id_plano, v_id_empresa);
END;
$$;


-- Procedure 2 (atualizar escolhas de condena por unidade)
CREATE OR REPLACE PROCEDURE atualizar_condenas_unidade(
    p_id_unidade INTEGER,
    p_condenas INTEGER[]
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM condena_unidade
    WHERE id_unidade = p_id_unidade;

    INSERT INTO condena_unidade (id_condena, id_unidade)
    SELECT unnest(p_condenas), p_id_unidade;

    RAISE NOTICE 'Condenas atualizadas para a unidade %', p_id_unidade;
END;
$$;

-- Procedure 3 (atualizar plano de uma unidade)
CREATE OR REPLACE PROCEDURE atualizar_plano_unidade(
    p_id_unidade INTEGER,
    p_id_plano INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE unidade
    SET id_plano = p_id_plano
    WHERE id = p_id_unidade;

    RAISE NOTICE 'Plano atualizado para a unidade %', p_id_unidade;
END;
$$;

-- FUNCTIONS ===========================================
-- Function 1 (Verificar se o usuário é gestor ou lider)
CREATE OR REPLACE FUNCTION tipo_usuario(
    p_email_cnpj VARCHAR,
    p_senha VARCHAR
)
RETURNS TABLE (
    id INTEGER,
    tipo_usuario TEXT
) AS $$
BEGIN
    -- Verifica se é gestor
    RETURN QUERY
    SELECT g.id, 'gestor' AS tipo_usuario
    FROM gestor g
    WHERE g.email = p_email_cnpj
      AND g.senha = p_senha
    LIMIT 1;

    -- Se não retornou nada, tenta líder
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT l.id, 'lider' AS tipo_usuario
        FROM lider l
        WHERE l.email = p_email_cnpj
          AND l.senha = p_senha
        LIMIT 1;
    END IF;

    -- Se ainda não retornou, tenta unidade
    IF NOT FOUND THEN
        RETURN QUERY
        SELECT u.id, 'unidade' AS tipo_usuario
        FROM unidade u
        WHERE u.cnpj = p_email_cnpj
          AND u.senha = p_senha
        LIMIT 1;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Function 2 (verificar se a empresa existe)
CREATE OR REPLACE FUNCTION verificar_empresa_existente(
    p_nome_empresa VARCHAR,
    p_cnpj_unidade VARCHAR
)
RETURNS INTEGER AS $$
DECLARE
    v_id_empresa INTEGER;
    v_raiz_cnpj VARCHAR;
BEGIN
    v_raiz_cnpj := SUBSTRING(REGEXP_REPLACE(p_cnpj_unidade, '[^0-9]', '', 'g') FROM 1 FOR 8);

    SELECT e.id
    INTO v_id_empresa
    FROM empresa e
    WHERE 
        LOWER(REGEXP_REPLACE(unaccent(TRIM(e.nome)), '[^a-z0-9]', '', 'g')) =
        LOWER(REGEXP_REPLACE(unaccent(TRIM(p_nome_empresa)), '[^a-z0-9]', '', 'g'))
        OR SUBSTRING(REGEXP_REPLACE(e.cnpj, '[^0-9]', '', 'g') FROM 1 FOR 8) = v_raiz_cnpj
    LIMIT 1;

    RETURN v_id_empresa;
END;
$$ LANGUAGE plpgsql;


-- DAU (Daily Active Users)
CREATE OR REPLACE PROCEDURE registrar_login_dau(
    p_email_cnpj VARCHAR,
    p_senha VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
    v_usuario RECORD;
BEGIN
    SELECT * INTO v_usuario
    FROM tipo_usuario(p_email_cnpj, p_senha)
    LIMIT 1;

    IF FOUND THEN
        INSERT INTO daily_active_users (id_usuario, tipo_usuario, hora_entrada)
        VALUES (v_usuario.id, v_usuario.tipo_usuario, CURRENT_TIMESTAMP);
    ELSE
        RAISE NOTICE 'Usuário não encontrado ou credenciais inválidas.';
    END IF;
END;
$$;
