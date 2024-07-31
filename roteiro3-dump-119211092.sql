--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT fu_lotacao;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT fk_nome_medicamento;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT fk_endereco;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT fk_cpf_funcionario;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT fk_cliente_venda;
ALTER TABLE ONLY public.cliente_endereco DROP CONSTRAINT fk_cliente;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT unique_nome;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT unique_cpf;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT unico_lotacao;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT unico_gerente;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT sede_unica;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_lotacao_key;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_id_farmacia_gerente_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE ONLY public.cliente_endereco DROP CONSTRAINT cliente_endereco_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT bairro_unico;
DROP TABLE public.vendas;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionarios;
DROP TABLE public.farmacia;
DROP TABLE public.entregas;
DROP TABLE public.clientes;
DROP TABLE public.cliente_endereco;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cliente_endereco; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.cliente_endereco (
    id_endereco integer NOT NULL,
    cpf_cliente character varying(11) NOT NULL,
    tipo_endereco character varying(1),
    endereco text,
    CONSTRAINT check_tipo_endereco CHECK (((tipo_endereco)::text = ANY ((ARRAY['T'::character varying, 'T'::character varying, 'O'::character varying])::text[])))
);


ALTER TABLE public.cliente_endereco OWNER TO cristianads;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.clientes (
    cpf_cliente character varying(11) NOT NULL,
    data_nascimento date,
    CONSTRAINT check_idade CHECK ((age((CURRENT_DATE)::timestamp with time zone, (data_nascimento)::timestamp with time zone) >= '18 years'::interval))
);


ALTER TABLE public.clientes OWNER TO cristianads;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.entregas (
    id_entrega integer NOT NULL,
    id_endereco integer NOT NULL,
    data_entrega date NOT NULL,
    status character varying(1) NOT NULL,
    CONSTRAINT check_status CHECK (((status)::text = ANY (ARRAY[('E'::character varying)::text, ('C'::character varying)::text, ('A'::character varying)::text])))
);


ALTER TABLE public.entregas OWNER TO cristianads;

--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.farmacia (
    id_farmacia integer NOT NULL,
    bairro text,
    cidade text,
    estado public.estado_nordeste,
    tipo character varying(1),
    gerente character varying(11),
    is_sede boolean,
    gerente_tipo character(1),
    CONSTRAINT check_gerente_tipo_valido CHECK ((gerente_tipo = ANY (ARRAY['A'::bpchar, 'F'::bpchar]))),
    CONSTRAINT check_tipo CHECK (((tipo)::text = ANY ((ARRAY['F'::character varying, 'S'::character varying])::text[])))
);


ALTER TABLE public.farmacia OWNER TO cristianads;

--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.funcionarios (
    cpf_funcionario character varying(11) NOT NULL,
    cargo character varying(1) NOT NULL,
    lotacao integer,
    CONSTRAINT check_cargo CHECK (((cargo)::text = ANY ((ARRAY['F'::character varying, 'V'::character varying, 'E'::character varying, 'C'::character varying, 'A'::character varying])::text[])))
);


ALTER TABLE public.funcionarios OWNER TO cristianads;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.medicamentos (
    nome character varying(20) NOT NULL,
    necessita_receita boolean NOT NULL,
    preco numeric(10,2) NOT NULL
);


ALTER TABLE public.medicamentos OWNER TO cristianads;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: cristianads
--

CREATE TABLE public.vendas (
    id_venda integer NOT NULL,
    cpf_cliente character varying(11),
    nome_cliente character varying(100),
    data_venda date NOT NULL,
    valor numeric(10,2) NOT NULL,
    cpf_funcionario character varying(11) NOT NULL,
    nome_medicamento character varying(20) NOT NULL,
    tipo_funcionario character varying(1),
    CONSTRAINT check_cliente CHECK ((((cpf_cliente IS NOT NULL) AND (nome_cliente IS NULL)) OR ((cpf_cliente IS NULL) AND (nome_cliente IS NOT NULL)))),
    CONSTRAINT check_tipo_funcionario CHECK (((tipo_funcionario)::text = 'V'::text))
);


ALTER TABLE public.vendas OWNER TO cristianads;

--
-- Data for Name: cliente_endereco; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: cristianads
--



--
-- Name: farmacia bairro_unico; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT bairro_unico UNIQUE (bairro);


--
-- Name: cliente_endereco cliente_endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.cliente_endereco
    ADD CONSTRAINT cliente_endereco_pkey PRIMARY KEY (id_endereco);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf_cliente);


--
-- Name: entregas entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id_entrega);


--
-- Name: farmacia farmacia_id_farmacia_gerente_key; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_id_farmacia_gerente_key UNIQUE (id_farmacia, gerente);


--
-- Name: farmacia farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id_farmacia);


--
-- Name: funcionarios funcionarios_lotacao_key; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_lotacao_key UNIQUE (lotacao);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf_funcionario);


--
-- Name: medicamentos medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (nome);


--
-- Name: farmacia sede_unica; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT sede_unica EXCLUDE USING gist (is_sede WITH =) WHERE (is_sede);


--
-- Name: farmacia unico_gerente; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT unico_gerente UNIQUE (gerente);


--
-- Name: funcionarios unico_lotacao; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT unico_lotacao UNIQUE (lotacao);


--
-- Name: clientes unique_cpf; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT unique_cpf UNIQUE (cpf_cliente);


--
-- Name: medicamentos unique_nome; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT unique_nome UNIQUE (nome);


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id_venda);


--
-- Name: cliente_endereco fk_cliente; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.cliente_endereco
    ADD CONSTRAINT fk_cliente FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf_cliente);


--
-- Name: vendas fk_cliente_venda; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_cliente_venda FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf_cliente);


--
-- Name: vendas fk_cpf_funcionario; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_cpf_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES public.funcionarios(cpf_funcionario);


--
-- Name: entregas fk_endereco; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT fk_endereco FOREIGN KEY (id_endereco) REFERENCES public.cliente_endereco(id_endereco);


--
-- Name: vendas fk_nome_medicamento; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_nome_medicamento FOREIGN KEY (nome_medicamento) REFERENCES public.medicamentos(nome) ON DELETE RESTRICT;


--
-- Name: funcionarios fu_lotacao; Type: FK CONSTRAINT; Schema: public; Owner: cristianads
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT fu_lotacao FOREIGN KEY (lotacao) REFERENCES public.farmacia(id_farmacia);


--
-- PostgreSQL database dump complete
--

