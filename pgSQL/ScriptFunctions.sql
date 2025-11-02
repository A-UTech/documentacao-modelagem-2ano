-- ==========================================================
-- FUNÇÕES DE TRIGGER PARA TABELAS DE LOG
-- ==========================================================

-- Função para ADMIN_LOG
CREATE OR REPLACE FUNCTION log_admin()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_admin_text text;
	v_id_admin int;
BEGIN
	v_id_admin_text := current_setting('log.admin_id', true);

	IF v_id_admin_text IS NULL OR v_id_admin_text = '' THEN
		RETURN NULL;
	END IF;

	v_id_admin := v_id_admin_text::int;

	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;

	INSERT INTO admin_log (tabela, id_afetado, operacao, id_admin, data_hora)
	VALUES (TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_admin, NOW());

	RETURN NULL;
END;
$$;

-- Função para GESTOR_LOG
CREATE OR REPLACE FUNCTION log_gestor()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_gestor_text text;
	v_id_gestor int;
BEGIN
	v_id_gestor_text := current_setting('log.gestor_id', true);

	IF v_id_gestor_text IS NULL OR v_id_gestor_text = '' THEN
		RETURN NULL;
	END IF;

	v_id_gestor := v_id_gestor_text::int;

	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;

	INSERT INTO gestor_log (tabela, id_afetado, operacao, id_gestor, data_hora)
	VALUES (TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_gestor, NOW());

	RETURN NULL;
END;
$$;

-- Função para EMPRESA_LOG
CREATE OR REPLACE FUNCTION log_empresa()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
	v_id_afetado int;
	v_id_empresa_text text;
	v_id_unidade_text text;
	v_id_empresa int;
	v_id_unidade int;
BEGIN
	v_id_empresa_text := current_setting('log.empresa_id', true);
	v_id_unidade_text := current_setting('log.unidade_id', true);

	IF v_id_empresa_text IS NOT NULL AND v_id_empresa_text <> '' THEN
		v_id_empresa := v_id_empresa_text::int;
	END IF;

	IF v_id_unidade_text IS NOT NULL AND v_id_unidade_text <> '' THEN
		v_id_unidade := v_id_unidade_text::int;
	END IF;

	IF v_id_empresa IS NULL OR v_id_unidade IS NULL THEN
		RETURN NULL;
	END IF;

	IF TG_OP = 'DELETE' THEN
		v_id_afetado := OLD.id;
	ELSE
		v_id_afetado := NEW.id;
	END IF;

	INSERT INTO empresa_log (tabela, id_afetado, operacao, id_empresa, id_unidade, data_hora)
	VALUES (TG_TABLE_NAME, v_id_afetado, TG_OP, v_id_empresa, v_id_unidade, NOW());

	RETURN NULL;
END;
$$;

-- ==========================================================
-- TRIGGERS
-- ==========================================================

-- ADMIN_LOG
CREATE OR REPLACE TRIGGER trg_log_admin
AFTER INSERT OR UPDATE OR DELETE ON admin
FOR EACH ROW EXECUTE FUNCTION log_admin();

CREATE OR REPLACE TRIGGER trg_log_admin_planos
AFTER INSERT OR UPDATE OR DELETE ON planos
FOR EACH ROW EXECUTE FUNCTION log_admin();

CREATE OR REPLACE TRIGGER trg_log_admin_condena
AFTER INSERT OR UPDATE OR DELETE ON condena
FOR EACH ROW EXECUTE FUNCTION log_admin();

-- GESTOR_LOG
CREATE OR REPLACE TRIGGER trg_log_gestor_lider
AFTER INSERT OR UPDATE OR DELETE ON lider
FOR EACH ROW EXECUTE FUNCTION log_gestor();

CREATE OR REPLACE TRIGGER trg_log_gestor
AFTER INSERT OR UPDATE OR DELETE ON gestor
FOR EACH ROW EXECUTE FUNCTION log_gestor();

CREATE OR REPLACE TRIGGER trg_log_gestor_condena
AFTER INSERT OR UPDATE OR DELETE ON condena_unidade
FOR EACH ROW EXECUTE FUNCTION log_gestor();

-- EMPRESA_LOG
CREATE OR REPLACE TRIGGER trg_log_empresa
AFTER INSERT OR UPDATE OR DELETE ON empresa
FOR EACH ROW EXECUTE FUNCTION log_empresa();

CREATE OR REPLACE TRIGGER trg_log_empresa_unidade
AFTER INSERT OR UPDATE OR DELETE ON unidade
FOR EACH ROW EXECUTE FUNCTION log_empresa();

CREATE OR REPLACE TRIGGER trg_log_empresa_turno
AFTER INSERT OR UPDATE OR DELETE ON turno
FOR EACH ROW EXECUTE FUNCTION log_empresa();

CREATE OR REPLACE TRIGGER trg_log_unidade_condena
AFTER INSERT OR UPDATE OR DELETE ON condena_unidade
FOR EACH ROW EXECUTE FUNCTION log_gestor();

-- ==========================================================
-- PROCEDURES
-- ==========================================================

-- Inserir unidade por CNPJ (corrigida)
CREATE OR REPLACE PROCEDURE inserir_unidade_por_cnpj(
    p_nome_unidade VARCHAR,
    p_estado VARCHAR,
    p_cidade VARCHAR,
    p_cnpj VARCHAR,
	p_senha VARCHAR,
    p_id_plano INTEGER
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_empresa BIGINT;
BEGIN
    v_id_empresa := verificar_empresa_existente(p_cnpj);

    IF v_id_empresa IS NULL THEN
        RAISE EXCEPTION 'Empresa não encontrada ou não corresponde ao CNPJ informado.';
    END IF;

    INSERT INTO unidade (nome, estado, cidade, cnpj, id_plano, id_empresa, senha)
    VALUES (p_nome_unidade, p_estado, p_cidade, p_cnpj, p_id_plano, v_id_empresa, p_senha);
END;
$$;

-- Atualizar condenas por unidade
CREATE OR REPLACE PROCEDURE atualizar_condenas_unidade(
    p_id_unidade INTEGER,
    p_condenas INTEGER[]
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM condena_unidade
    WHERE id_unidade = p_id_unidade;

    INSERT INTO condena_unidade (id_condena, id_unidade)
    SELECT unnest(p_condenas), p_id_unidade;

    RAISE NOTICE 'Condenas atualizadas para a unidade %', p_id_unidade;
END;
$$;

-- Atualizar plano da unidade
CREATE OR REPLACE PROCEDURE atualizar_plano_unidade(
    p_id_unidade INTEGER,
    p_id_plano INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE unidade
    SET id_plano = p_id_plano
    WHERE id = p_id_unidade;

    RAISE NOTICE 'Plano atualizado para a unidade %', p_id_unidade;
END;
$$;

-- ==========================================================
-- FUNÇÕES
-- ==========================================================

-- Função: identificar tipo de usuário e setar contexto
CREATE OR REPLACE FUNCTION tipo_usuario(
    p_email_cnpj VARCHAR,
    p_senha VARCHAR
)
RETURNS TABLE (
    id BIGINT,
    tipo_usuario TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id BIGINT;
    v_id_empresa BIGINT;
BEGIN
    -- ADMIN
    SELECT a.id INTO v_id
    FROM admin a
    WHERE a.email = p_email_cnpj AND a.senha = p_senha
    LIMIT 1;

    IF FOUND THEN
        PERFORM set_config('log.admin_id', v_id::TEXT, false);
        RETURN QUERY SELECT v_id, 'admin';
        RETURN;
    END IF;

    -- GESTOR
    SELECT g.id INTO v_id
    FROM gestor g
    WHERE g.email = p_email_cnpj AND g.senha = p_senha
    LIMIT 1;

    IF FOUND THEN
        PERFORM set_config('log.gestor_id', v_id::TEXT, false);
        RETURN QUERY SELECT v_id, 'gestor';
        RETURN;
    END IF;

    -- LIDER
    SELECT l.id INTO v_id
    FROM lider l
    WHERE l.email = p_email_cnpj AND l.senha = p_senha
    LIMIT 1;

    IF FOUND THEN
        RETURN QUERY SELECT v_id, 'lider';
        RETURN;
    END IF;

    -- UNIDADE
     SELECT u.id, u.id_empresa
    INTO v_id, v_id_empresa
    FROM unidade u
    WHERE u.cnpj = p_email_cnpj AND u.senha = p_senha
    LIMIT 1;

    IF FOUND THEN
        -- seta o id da unidade e da empresa, mas retorna só a unidade
        PERFORM set_config('log.unidade_id', v_id::TEXT, false);
        PERFORM set_config('log.empresa_id', v_id_empresa::TEXT, false);
        RETURN QUERY SELECT v_id, 'unidade';
        RETURN;
    END IF;
END;
$$;

-- Função: verificar empresa existente via raiz do CNPJ
CREATE OR REPLACE FUNCTION verificar_empresa_existente(
    p_cnpj_unidade VARCHAR
)
RETURNS bigint AS $$
DECLARE
    v_id_empresa bigint;
    v_raiz_cnpj VARCHAR;
BEGIN
    v_raiz_cnpj := SUBSTRING(REGEXP_REPLACE(p_cnpj_unidade, '[^0-9]', '', 'g') FROM 1 FOR 8);

    SELECT u.id_empresa
    INTO v_id_empresa
    FROM unidade u
    WHERE SUBSTRING(REGEXP_REPLACE(u.cnpj, '[^0-9]', '', 'g') FROM 1 FOR 8) = v_raiz_cnpj
    LIMIT 1;

    RETURN v_id_empresa;
END;
$$ LANGUAGE plpgsql;

-- Função DAU (registrar login)
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
