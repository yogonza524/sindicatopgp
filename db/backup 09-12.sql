--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5beta1
-- Dumped by pg_dump version 9.5beta1

-- Started on 2015-12-09 01:26:52

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 198 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2338 (class 0 OID 0)
-- Dependencies: 198
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 200 (class 3079 OID 33132)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2339 (class 0 OID 0)
-- Dependencies: 200
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 199 (class 3079 OID 41504)
-- Name: pldbgapi; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;


--
-- TOC entry 2340 (class 0 OID 0)
-- Dependencies: 199
-- Name: EXTENSION pldbgapi; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';


SET search_path = public, pg_catalog;

--
-- TOC entry 675 (class 1247 OID 33221)
-- Name: registro_usuario; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE registro_usuario AS (
	id character varying(32),
	username character varying(32),
	password character varying(40),
	fecha_creacion timestamp with time zone,
	fecha_ultima_modificacion timestamp with time zone,
	activo boolean,
	id_rol character varying(32),
	email character varying(75)
);


ALTER TYPE registro_usuario OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 41502)
-- Name: add_admin(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_admin(username character varying, pass character varying, email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	result boolean;
BEGIN
	INSERT INTO usuario(username,password,email,id_rol) VALUES(username,pass,email,'63dddf6eff57bfc926b838f5af0e3c4d') RETURNING (id IS NOT NULL) INTO result;
	RETURN result;
END;	
$$;


ALTER FUNCTION public.add_admin(username character varying, pass character varying, email character varying) OWNER TO postgres;

--
-- TOC entry 2341 (class 0 OID 0)
-- Dependencies: 258
-- Name: FUNCTION add_admin(username character varying, pass character varying, email character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_admin(username character varying, pass character varying, email character varying) IS 'Agrega un usuario con el Rol de Administrador a la Base de datos';


--
-- TOC entry 300 (class 1255 OID 41495)
-- Name: add_user(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_user(username character varying, pass character varying, email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	result boolean;
BEGIN
	INSERT INTO usuario(username,password,email) VALUES(username,pass,email) RETURNING (id IS NOT NULL) INTO result;
	RETURN result;
END;	
$$;


ALTER FUNCTION public.add_user(username character varying, pass character varying, email character varying) OWNER TO postgres;

--
-- TOC entry 2342 (class 0 OID 0)
-- Dependencies: 300
-- Name: FUNCTION add_user(username character varying, pass character varying, email character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION add_user(username character varying, pass character varying, email character varying) IS 'Agrega un usuario nuevo a la base de datos';


--
-- TOC entry 299 (class 1255 OID 41492)
-- Name: after_delete_empresa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION after_delete_empresa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE registracion SET completo = FALSE 
		WHERE registracion.id_usuario = OLD.id_usuario;
	DELETE FROM cuota WHERE cuota.id_empresa = OLD.id_usuario;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.after_delete_empresa() OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 41459)
-- Name: after_insert_empresa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION after_insert_empresa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO cuota(id_empresa,id_estado) VALUES(
		NEW.id_usuario, 'b052525083c3a75425a559e288b8077f'
	);
	UPDATE registracion SET completo = TRUE 
		WHERE registracion.id_usuario = NEW.id_usuario;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.after_insert_empresa() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 41456)
-- Name: after_insert_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION after_insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO registracion(completo,id_usuario,token,email) VALUES(
		FALSE, NEW.id, uuid(),NEW.email
	);
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.after_insert_user() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 33273)
-- Name: arg_month(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION arg_month(fecha date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE 
	mes integer;
	mes_salida character varying;
BEGIN 
	IF (fecha IS NOT NULL) THEN
		mes = date_part('month',fecha);
		CASE mes
			WHEN 1 THEN mes_salida = 'Enero';
			WHEN 2 THEN mes_salida = 'Febrero';
			WHEN 3 THEN mes_salida = 'Marzo';
			WHEN 4 THEN mes_salida = 'Abril';
			WHEN 5 THEN mes_salida = 'Mayo';
			WHEN 6 THEN mes_salida = 'Junio';
			WHEN 7 THEN mes_salida = 'Julio';
			WHEN 8 THEN mes_salida = 'Agosto';
			WHEN 9 THEN mes_salida = 'Septiembre';
			WHEN 10 THEN mes_salida = 'Octubre';
			WHEN 11 THEN mes_salida = 'Noviembre';
			WHEN 12 THEN mes_salida = 'Diciembre';
		END CASE;
	ELSE
		RAISE EXCEPTION 'La fecha es nula, no se puede castear';
	END IF;
	RETURN mes_salida;
END;
$$;


ALTER FUNCTION public.arg_month(fecha date) OWNER TO postgres;

--
-- TOC entry 2343 (class 0 OID 0)
-- Dependencies: 267
-- Name: FUNCTION arg_month(fecha date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION arg_month(fecha date) IS 'Devuelve una cadena de caracters que representa el mes en español Argentino';


--
-- TOC entry 202 (class 1255 OID 33127)
-- Name: betweendays(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION betweendays(fecha date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	output integer;
BEGIN
	IF fecha IS NOT NULL THEN
		SELECT current_date - fecha INTO output;
	ELSE
		RAISE EXCEPTION 'La fecha es nula';
	END IF;
	RETURN output;
END;
$$;


ALTER FUNCTION public.betweendays(fecha date) OWNER TO postgres;

--
-- TOC entry 2344 (class 0 OID 0)
-- Dependencies: 202
-- Name: FUNCTION betweendays(fecha date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION betweendays(fecha date) IS 'Devuelve la diferencia de dias entre dos fechas dadas. Dependiendo de cual sea mayor los valores pueden ser positivios, negativos o cero si ambas fechas son iguales';


--
-- TOC entry 259 (class 1255 OID 41500)
-- Name: change_password(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION change_password(id_user character varying, pass character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	result boolean;
	b_pass character varying;
	n_pass character varying;
BEGIN
	result = FALSE;
	SELECT u.password INTO b_pass FROM usuario u WHERE u.id = id_user;
	IF (b_pass IS NOT NULL) THEN
		UPDATE usuario SET password = encode(pass) WHERE usuario.id = id_user RETURNING password INTO n_pass;
		IF (b_pass <> n_pass) THEN
			result = TRUE;
		END IF;
	END IF;
	RETURN result;
END;	
$$;


ALTER FUNCTION public.change_password(id_user character varying, pass character varying) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 33286)
-- Name: compare_fecha_hoy(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION compare_fecha_hoy(fecha date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	
BEGIN 
	IF (fecha > now()::date) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;


ALTER FUNCTION public.compare_fecha_hoy(fecha date) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 33130)
-- Name: config_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION config_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	count integer;
BEGIN
	SELECT COUNT(*) INTO count FROM config;
	IF (count = 0) count THEN
		NEW.id = uuid();
		IF (NEW.dia_emision < 1 OR NEW.dia_emision > 31) THEN
			NEW.dia_emision = 1;
		END IF;
		IF (NEW.dia_vencimiento < 1 OR NEW.dia_vencimiento > 31) THEN
			NEW.dia_vencimiento = 15;
		END IF;
		IF (NEW.fecha_creacion IS NULL) THEN
			NEW.fecha_creacion = now();
		END IF;
		IF (NEW.fecha_ultima_modificacion IS NULL) THEN
			NEW.fecha_ultima_modificacion = now();
		END IF;
		RETURN NEW;
	ELSE
		RAISE NOTICE 'La tabla de configuracion no esta vacía. Registro rechazado';
		RETURN OLD;
	END IF;
END;
$$;


ALTER FUNCTION public.config_insert() OWNER TO postgres;

--
-- TOC entry 302 (class 1255 OID 41499)
-- Name: count_admins(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_admins() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;
BEGIN
	SELECT COUNT(*) INTO result FROM usuario u 
		INNER JOIN rol r ON r.id = u.id_rol AND r.descripcion = 'ADMINISTRADOR';
	RETURN result;
END;	
$$;


ALTER FUNCTION public.count_admins() OWNER TO postgres;

--
-- TOC entry 2345 (class 0 OID 0)
-- Dependencies: 302
-- Name: FUNCTION count_admins(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION count_admins() IS 'Cuenta la cantidad de usuarios registrados con el rol "ADMINISTRADOR" en el sistema';


--
-- TOC entry 301 (class 1255 OID 41498)
-- Name: count_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_users() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	result integer;
BEGIN
	SELECT COUNT(*) INTO result FROM usuario u 
		INNER JOIN rol r ON r.id = u.id_rol AND r.descripcion = 'USUARIO';
	RETURN result;
END;	
$$;


ALTER FUNCTION public.count_users() OWNER TO postgres;

--
-- TOC entry 2346 (class 0 OID 0)
-- Dependencies: 301
-- Name: FUNCTION count_users(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION count_users() IS 'Cuenta la cantidad de usuarios con el rol "USUARIO" registrados en el sistema';


--
-- TOC entry 253 (class 1255 OID 33187)
-- Name: date_arg_format(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION date_arg_format(fecha date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	mes double precision;
	mes_salida character varying(20);
BEGIN
	IF (fecha IS NOT NULL) THEN
		mes = date_part('month',fecha);
		CASE mes
			WHEN 1 THEN mes_salida = 'Enero';
			WHEN 2 THEN mes_salida = 'Febrero';
			WHEN 3 THEN mes_salida = 'Marzo';
			WHEN 4 THEN mes_salida = 'Abril';
			WHEN 5 THEN mes_salida = 'Mayo';
			WHEN 6 THEN mes_salida = 'Junio';
			WHEN 7 THEN mes_salida = 'Julio';
			WHEN 8 THEN mes_salida = 'Agosto';
			WHEN 9 THEN mes_salida = 'Septiembre';
			WHEN 10 THEN mes_salida = 'Octubre';
			WHEN 11 THEN mes_salida = 'Noviembre';
			WHEN 12 THEN mes_salida = 'Diciembre';
		END CASE;
	ELSE
		RAISE EXCEPTION 'La fecha es nula, no se puede castear';
	END IF;
	RETURN date_part('day',fecha) || ' de ' || mes_salida || ' de ' || date_part('year',fecha);
END;
$$;


ALTER FUNCTION public.date_arg_format(fecha date) OWNER TO postgres;

--
-- TOC entry 2347 (class 0 OID 0)
-- Dependencies: 253
-- Name: FUNCTION date_arg_format(fecha date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION date_arg_format(fecha date) IS 'Obtiene la fecha en formato de cadena de caracteres y en estilo Argentino';


--
-- TOC entry 263 (class 1255 OID 33209)
-- Name: disable_user(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION disable_user(id_u character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE 
	result boolean;
BEGIN 
	SELECT COUNT(*) > 0 INTO result FROM usuario u WHERE u.id = id_u;
	IF (result IS NOT NULL) THEN
		UPDATE usuario SET activo = FALSE WHERE usuario.id = id_u;
		RETURN TRUE;
	END IF;
	RETURN FALSE;
END;
$$;


ALTER FUNCTION public.disable_user(id_u character varying) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 33190)
-- Name: encode(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION encode(val character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN encode(digest(val, 'sha1'), 'hex')::character varying;
END;
$$;


ALTER FUNCTION public.encode(val character varying) OWNER TO postgres;

--
-- TOC entry 310 (class 1255 OID 41602)
-- Name: generate_cuota(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION generate_cuota(id_emp character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	output boolean;
	id_est character varying;
	tiene_pendiente boolean;
	updated boolean;
BEGIN
	output = FALSE;
	tiene_pendiente = FALSE;
	updated = FALSE;
	SELECT ec.id INTO id_est FROM estado_cuota ec WHERE ec.nombre = 'PENDIENTE';
	IF (id_emp IS NOT NULL) THEN
		--Busco las cuotas pendientes
		SELECT COUNT(*)>0 INTO tiene_pendiente FROM cuota c
			INNER JOIN estado_cuota ec ON ec.id = c.id_estado AND ec.nombre = 'PENDIENTE'
			WHERE c.id_empresa = id_emp;
		IF (NOT tiene_pendiente) THEN
			INSERT INTO cuota(id_empresa,id_estado) VALUES(id_emp,id_est) RETURNING (id IS NOT NULL) INTO output;
			IF (output) THEN
				UPDATE empresa SET fecha_emision_proxima_cuota = (get_fecha_emision() + '1 month'::interval) 
				WHERE id_usuario = id_emp RETURNING (id_usuario IS NOT NULL) INTO updated;
				IF (NOT updated) THEN
					RAISE EXCEPTION 'Sucedi� un error al modificar la fecha de emision siguiente';
				END IF;
			END IF;
		ELSE
			RAISE EXCEPTION 'No se puede agregar, ya tiene cuotas pendientes';
		END IF;
	ELSE
		RAISE EXCEPTION 'Debe ingresar un ID de empresa';
	END IF;
	RETURN updated;
END;
$$;


ALTER FUNCTION public.generate_cuota(id_emp character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 33278)
-- Name: get_fecha_emision(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_fecha_emision() RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
	dia_em integer;
	today integer;
	result date;
BEGIN 
	SELECT c.dia_emision INTO dia_em FROM config c LIMIT 1;
	IF (dia_em IS NULL) THEN
		RAISE EXCEPTION 'Error grave: no existe dia de emision en la tabla de configuración';
	END IF;
	today = date_part('day',now()::date);
	--Todavia no llegó el dia de emision
	result = dia_em || '-' || date_part('month',now()) || '-' || date_part('year',now());
	IF (today > dia_em) THEN
		result = result + '1 month'::interval;
	END IF;
	RETURN result;
END;
$$;


ALTER FUNCTION public.get_fecha_emision() OWNER TO postgres;

--
-- TOC entry 2348 (class 0 OID 0)
-- Dependencies: 254
-- Name: FUNCTION get_fecha_emision(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_fecha_emision() IS 'Obtiene la fecha de emision de la cuota en función de la fecha actual';


--
-- TOC entry 274 (class 1255 OID 33283)
-- Name: get_fecha_vencimiento(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_fecha_vencimiento() RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
	dia_ven integer;
	today integer;
	result date;
BEGIN 
	SELECT c.dia_vencimiento INTO dia_ven FROM config c LIMIT 1;
	IF (dia_ven IS NULL) THEN
		RAISE EXCEPTION 'Error grave: no existe dia de vencimiento en la tabla de configuración';
	END IF;
	today = date_part('day',now()::date);
	--Todavia no llegó el dia de emision
	result = dia_ven || '-' || date_part('month',now()) || '-' || date_part('year',now());
	IF (today > dia_ven) THEN
		result = result + '1 month'::interval;
	END IF;
	RETURN result;
END;
$$;


ALTER FUNCTION public.get_fecha_vencimiento() OWNER TO postgres;

--
-- TOC entry 2349 (class 0 OID 0)
-- Dependencies: 274
-- Name: FUNCTION get_fecha_vencimiento(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION get_fecha_vencimiento() IS 'Obtiene la fecha de vencimiento de la cuota en funcion de la fecha actual. Esta funcion se debe llamar cuando se realiza la agregacion de nuevas cuotas unicamente';


--
-- TOC entry 311 (class 1255 OID 33274)
-- Name: insert_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_emp character varying;
	id_st character varying;
	emitir boolean;
BEGIN 
	emitir = FALSE;
	NEW.id = uuid();
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	NEW.importe = 0.0;
	NEW.cantidad_empleados = 0;
	NEW.intereses = 0.0;
	NEW.periodo = arg_month((get_fecha_emision() - '1 month'::interval)::date);
	NEW.fecha_emision = get_fecha_emision();
	NEW.fecha_vencimiento = get_fecha_vencimiento();
	NEW.remuneracion_total = 0.0;
	--Verifico que la fecha de emision y la fecha de vencimiento sean coherentes
	IF (NEW.fecha_emision > NEW.fecha_vencimiento) THEN
		NEW.fecha_vencimiento = NEW.fecha_vencimiento + '1 month'::interval;
	END IF;
	IF (NEW.id_empresa IS NULL) THEN
		RAISE EXCEPTION 'ID de usuario no puede ser nulo. Solicitud rechazada';
	ELSE
		SELECT e.id_usuario INTO id_emp FROM empresa e WHERE e.id_usuario = NEW.id_empresa LIMIT 1;
		IF (id_emp IS NULL) THEN
			RAISE EXCEPTION 'No existe la empresa con el ID %',NEW.id_empresa;
		END IF;
	END IF;
	IF (NEW.id_estado IS NULL) THEN
		RAISE EXCEPTION 'El ID del estado no puede ser nulo';
	ELSE
		SELECT e.id INTO id_st FROM estado_cuota e WHERE e.id = NEW.id_estado LIMIT 1;
		IF (id_st IS NULL) THEN
			RAISE EXCEPTION 'El estado con ID % no existe', NEW.id_estado;
		END IF;
	END IF;
	--Verifico que sea el momento de emitir la cuota
	SELECT COUNT(*)>0 INTO emitir FROM empresa e WHERE e.id_usuario = NEW.id_empresa OR e.id_usuario IS NULL AND e.fecha_emision_proxima_cuota < now()::date;
	IF (NOT emitir) THEN
		RAISE EXCEPTION 'Aun no es el momento de emitir una nueva cuota';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_cuota() OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 33238)
-- Name: insert_empresa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_empresa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_usr character varying;
BEGIN
	IF (NEW.responsable IS NULL) THEN
		NEW.responsable = 'DESCONOCIDO';
	END IF;
	IF (NEW.actividad_principal IS NULL) THEN
		NEW.actividad_principal = 'NO ESPECIFICADO';
	END IF;
	IF (NOT validateEmail(NEW.email)) THEN
		RAISE EXCEPTION 'Email no valido. Verifiquelo.';
	END IF;
	IF (NEW.id_usuario IS NULL) THEN
		RAISE EXCEPTION 'ID de usuario no especificado';
	ELSE
		--Verifico que exista el usuario
		SELECT u.id INTO id_usr FROM usuario u WHERE u.id = NEW.id_usuario LIMIT 1;
		IF (id_usr IS NULL) THEN
			RAISE EXCEPTION 'No existe el usuario con el ID %',NEW.id_usuario ;
		END IF;
	END IF;
	--Verifico que el CUIT sea valido
	IF (NOT validate_cuit(NEW.cuit)) THEN
		RAISE EXCEPTION 'CUIT no valido, verifiquelo. Solicitud rechazada';
	END IF;
	--Verifico que la fecha de inicio de actividad sea valido
	IF (NEW.fecha_inicio_actividad > now()::date) THEN 
		RAISE EXCEPTION 'La fecha de inicio de actividad de la empresa no puede ser mayor a hoy. Solicitud rechazada.';
	END IF;
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	--Cargo la fecha de emision de la proxima cuota
	NEW.fecha_emision_proxima_cuota = get_fecha_emision();
	--Verifico que la fecha de la proxima emision sea siempre mayor a la de la ultima cuota
	IF (NEW.fecha_emision_proxima_cuota > now()::date) THEN
		NEW.fecha_emision_proxima_cuota = NEW.fecha_emision_proxima_cuota + '1 month'::interval;
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_empresa() OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 33257)
-- Name: insert_estado_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_estado_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	NEW.id = uuid();
	IF (NEW.nombre IS NULL) THEN
		RAISE EXCEPTION 'El nombre de estado no puede ser nulo';
	ELSE
		NEW.nombre = upper(NEW.nombre);
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_estado_cuota() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 41422)
-- Name: insert_mensaje(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_mensaje() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.id = uuid();
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	NEW.leido = FALSE; --Todo mensaje insertado es no leido
	--Verifico que el contenido no sea vacio
	IF (NEW.contenido IS NULL) THEN
		--Contenido del mensaje lleno
		RAISE EXCEPTION 'Debe ingresar algun mensaje. Solicitud rechazada';
	END IF;
	--Verifico que el nombre sea valido
	IF (NEW.nombre IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar algun nombre. Solicitud rechazada';
	END IF;
	--Verifico que el email sea no nulo
	IF (NEW.email IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar algun email. Solicitud rechazada';
	ELSE
		--Verifico que el email ingresado sea valido
		IF (NOT validateemail(NEW.email)) THEN
			RAISE EXCEPTION 'El email ingresado no es válido. Solicitud rechazada';
		END IF;
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_mensaje() OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 41406)
-- Name: insert_registracion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_registracion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	user_id character varying;
	tiene_empresa boolean;
BEGIN
	IF (NEW.id_usuario IS NULL) THEN
		RAISE EXCEPTION 'El ID del usuario no puede ser nulo';
	ELSE
		--Verifico que el usuario exista en la tabla "usuario"
		SELECT u.id INTO user_id FROM usuario u WHERE u.id = NEW.id_usuario;
		IF (user_id IS NULL) THEN
			RAISE EXCEPTION 'No se encontró el usuario con el id %. Operación rechazada', NEW.id_usuario;
		END IF;
		--Verifico que el usuario no exista en la tabla "registracion"
		SELECT r.id_usuario INTO user_id FROM registracion r WHERE r.id_usuario = NEW.id_usuario;
		IF (user_id IS NOT NULL) THEN
			RAISE EXCEPTION 'El usuario que intenta agregar ya existe';
		END IF;
		--Verifico que exista la empresa
		SELECT COUNT(*)>0 INTO tiene_empresa FROM empresa e WHERE e.id_usuario = new.id_usuario;
		IF (tiene_empresa) THEN
			NEW.completo = TRUE;
		ELSE
			NEW.completo = FALSE;
		END IF;
	END IF;
	NEW.token = uuid();
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	IF (NOT validateemail(NEW.email)) THEN
		RAISE EXCEPTION 'El email no es válido. Formato incorrecto';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_registracion() OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 33206)
-- Name: insert_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	rol character varying;
BEGIN
	NEW.id = uuid();
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	IF(NEW.username IS NULL) THEN
		RAISE EXCEPTION 'Nombre de usuario nulo';
	END IF;
	IF(NEW.password IS NULL) THEN
		RAISE EXCEPTION 'Contraseña nula';
	END IF;
	IF (NEW.activo IS NULL) THEN
		NEW.activo = TRUE;
	END IF;
	--Verifico si esta cargado el rol, si no cargo el rol de Usuario por defecto
	IF (NEW.id_rol IS NULL) THEN
		SELECT r.id INTO rol FROM rol r WHERE r.descripcion = 'USUARIO';
		IF (rol IS NULL) THEN
			RAISE EXCEPTION 'No se encontró el rol USUARIO para cargarlo automaticamente. El id del rol foraneo no fue especificado';
		ELSE
			SELECT r.id INTO rol FROM rol r WHERE r.id = NEW.id_rol;
			IF (rol IS NULL) THEN
				SELECT r.id INTO NEW.id_rol FROM rol r WHERE r.descripcion = 'USUARIO';
			END IF;
		END IF;
	END IF;
	--Verifico que el email no sea nulo
	IF (NEW.email IS NOT NULL) THEN
		--Verifico que el email sea valido
		IF (NOT validateemail(NEW.email)) THEN
			RAISE EXCEPTION 'Email con formato invalido. Solicitud rechazada';
		END IF;
	ELSE
		RAISE EXCEPTION 'Debe ingresar un email. Solicitud rechazada';
	END IF;
	NEW.password = encode(digest(NEW.password, 'sha1'), 'hex')::character varying;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_user() OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 33192)
-- Name: login(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION login(usr character varying, pass character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE 
	output boolean;
BEGIN
	SELECT COUNT(*) > 0 INTO output FROM usuario u WHERE u.username = usr AND u.password = encode(pass) AND u.activo = TRUE;
	IF (output) THEN
		UPDATE usuario u SET ultima_conexion = now() WHERE u.username = usr AND u.password = encode(pass);
	END IF;
	RETURN output;
END;
$$;


ALTER FUNCTION public.login(usr character varying, pass character varying) OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 41561)
-- Name: pagar_cuota(character varying, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pagar_cuota(id_empresa character varying, remuneracion_total double precision, cantidad_empleados integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_emp character varying;
	result boolean;
BEGIN
	result = false;
	--Verifico que los datos sean correctos
	IF (id_empresa IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar un ID de la empresa. Solicitud rechazada';
	ELSE
		SELECT e.id_usuario INTO id_emp FROM empresa e WHERE e.id_usuario = id_empresa;
		IF (id_emp IS NULL) THEN
			RAISE EXCEPTION 'No existe el usuario con ID %',id_emp;
		END IF;
	END IF;
	IF (remuneracion_total IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar las remuneraciones totales. Solicitud rechazada';
	END IF;
	IF (cantidad_empleados IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar la cantidad de empleados. Solicitud rechazada';
	END IF;
	IF (remuneracin_total <= 0) THEN
		RAISE EXCEPTION 'Debe ingresar un monto de remuneraciones percibidas. Solicitud rechazada';
	END IF;
	IF (cantidad_empleados <= 0) THEN
		RAISE EXCEPTION 'Debe ingresar una cantidad de empleados. Solicitud rechazada';
	END IF;
	RETURN result;
END;
$$;


ALTER FUNCTION public.pagar_cuota(id_empresa character varying, remuneracion_total double precision, cantidad_empleados integer) OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 41562)
-- Name: random_string(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION random_string(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$;


ALTER FUNCTION public.random_string(length integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 33180)
-- Name: rol_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rol_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--Genero un ID seguro
	NEW.id = uuid();
	IF (NEW.descripcion IS NULL) THEN
		NEW.descripcion = 'DESCONOCIDO';
		RAISE NOTICE 'ROL NULO';
	END IF;
	--A mayusculas
	NEW.descripcion = upper(descripcion);
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.rol_insert() OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 33279)
-- Name: update_config(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_config() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (NEW.dia_emision < 1 OR NEW.dia_emision > 31) THEN
		NEW.dia_emision = 1;
	END IF;

	IF (NEW.dia_vencimiento < 1 OR NEW.dia_vencimiento > 31) THEN
		NEW.dia_vencimiento = 15;
	END IF;
	--Verifico que no se cambie la fecha de creacion
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--Verifico que no se cambie el ID
	IF(NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	NEW.fecha_ultima_modificacion = now();
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_config() OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 33276)
-- Name: update_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_emp character varying;
	id_st character varying;
BEGIN 
	--Guardo la fecha de ultima modificacion para estadisticas
	NEW.fecha_ultima_modificacion = now();
	IF (NEW.periodo <> OLD.periodo) THEN
		NEW.periodo = OLD.periodo;
	END IF;
	--La fecha de creacion no es modificable
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN 
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--El periodo no es modificabre
	IF (NEW.periodo <> OLD.periodo) THEN
		NEW.periodo = OLD.periodo;
	END IF;
	--Los intereses pueden ser 0 o mayores
	IF (NEW.intereses < 0) THEN
		NEW.intereses = 0;
	END IF;
	--El importe debe ser 0 o mayor
	IF (NEW.importe < 0) THEN
		NEW.importe = 0;
	END IF;
	--La remuneracion debe ser 0 o mayor
	IF (NEW.remuneracion_total < 0) THEN
		NEW.remuneracion_total = 0;
	END IF;
	--La fecha de emision no es modificable (Lo genera el sistema automaticamente)
	IF (NEW.fecha_emision <> OLD.fecha_emision) THEN
		NEW.fecha_emision = OLD.fecha_emision;
	END IF;
	--La fecha de vencimiento no es modificable (Lo genera el sistema automaticamente)
	IF (NEW.fecha_vencimiento IS NULL) THEN
		NEW.fecha_vencimiento = OLD.fecha_vencimiento;
	END IF;
	--La cantidad de empleados debe ser mayor o igual a 0
	IF (NEW.cantidad_empleados < 0) THEN
		RAISE EXCEPTION 'Cantidad de empleados no valido';
	END IF;
	--El id no es modificable (Lo genera el sistema auotmaticamente)
	IF (NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	--Verifico que el id de la empresa no sea nula
	IF (NEW.id_empresa IS NULL) THEN
		RAISE EXCEPTION 'ID de empresa no válido';
	ELSE
		--Verifico que la empresa exista
		SELECT e.id_usuario INTO id_emp FROM empresa e WHERE e.id_usuario = NEW.id_empresa LIMIT 1;
		IF (id_emp IS NULL) THEN
			RAISE EXCEPTION 'No existe la empresa con el ID %',NEW.id_empresa;
		END IF;
	END IF;
	--El estado de la cuota no puede ser nulo
	IF (NEW.id_estado IS NULL) THEN
		RAISE EXCEPTION 'El ID del estado no puede ser nulo';
	ELSE
		--Verifico que el estado exista en la tabla de estados cuota
		SELECT e.id INTO id_st FROM estado_cuota e WHERE e.id = NEW.id_estado LIMIT 1;
		IF (id_st IS NULL) THEN
			RAISE EXCEPTION 'El estado con ID % no existe', NEW.id_estado;
		END IF;
		
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_cuota() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 33240)
-- Name: update_empresa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_empresa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_usr character varying;
BEGIN 
	IF (NEW.responsable IS NULL) THEN
		NEW.responsable = 'DESCONOCIDO';
	END IF;
	IF (NEW.actividad_principal IS NULL) THEN
		NEW.actividad_principal = 'NO ESPECIFICADO';
	END IF;
	IF (NOT validateEmail(NEW.email)) THEN
		RAISE EXCEPTION 'Email no valido. Verifiquelo.';
	END IF;
	IF (NEW.id_usuario IS NULL) THEN
		RAISE EXCEPTION 'ID de usuario no especificado';
	ELSE
		--Verifico que exista el usuario
		SELECT u.id INTO id_usr FROM usuario u WHERE u.id = NEW.id_usuario LIMIT 1;
		IF (id_usr IS NULL) THEN
			NEW.id_usuario = OLD.id_usuario;
		END IF;
	END IF;
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--Verifico que el CUIT no haya cambiado
	IF (NEW.cuit <> OLD.cuit) THEN
		--Verifico que el nuevo CUIT sea valido
		IF (NOT validate_cuit(NEW.cuit)) THEN
			RAISE EXCEPTION 'CUIT inválido, verifiquelo. Solicitud rechazada';
		END IF;
	END IF;
	--Verifico que no se modifique la fecha de emision de la proxima cuota
	IF (NEW.fecha_emision_proxima_cuota IS NULL) THEN
		NEW.fecha_emision_proxima_cuota = OLD.fecha_emision_proxima_cuota;
	END IF;
	NEW.fecha_ultima_modificacion = now();
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_empresa() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 33259)
-- Name: update_estado_cuota(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_estado_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	IF (NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	IF (NEW.nombre IS NULL) THEN
		RAISE EXCEPTION 'EL nombre del estado no puede ser nulo';
	ELSE
		NEW.nombre = upper(NEW.nombre);
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_estado_cuota() OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 41424)
-- Name: update_mensaje(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_mensaje() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--Verifico que el ID no haya cambiado
	IF (NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	--Verifico que no se cambie la fecha de creacion
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--Verfico que el email ingresado sea valido
	IF(NEW.email IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar un email. Solicitud rechazada';
	ELSE
		--Verifico que el email sea valido
		IF (NOT validateemail(NEW.email)) THEN
			RAISE EXCEPTION 'Debe ingresar un email válido. Solicitud rechazada';
		END IF;
	END IF;
	--Verifico que el nombre no sea nulo
	IF (NEW.nombre IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar un nombre. Solicitud rechazada';
	END IF;
	--Verifico que el contenido no sea nulo
	IF (NEW.contenido IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar un mensaje. Solicitud rechazada';
	END IF;
	--Verifico que el campo "leido" no sea nulo
	IF (NEW.leido IS NULL) THEN
		IF (OLD.leido IS NOT NULL) THEN
			NEW.leido = OLD.leido;
		ELSE
			NEW.leido = FALSE;
		END IF;
	END IF;
	NEW.fecha_ultima_modificacion = now();
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_mensaje() OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 41408)
-- Name: update_registracion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_registracion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	user_id character varying;
	tiene_empresa boolean;
BEGIN
	NEW.fecha_ultima_modificacion = now();
	--Verifico que no se haya cambiado la fecha de creacion
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--Verifico que el token no cambie
	IF (NEW.token <> OLD.token) THEN
		NEW.token = OLD.token;
	END IF;
	--Verifico que el email sea valido
	IF (NOT validateemail(NEW.email)) THEN
		RAISE EXCEPTION 'El email ingresado no es válido. Formato incorrecto';
	END IF;
	--Verifico que el ID de usuario no sea nulo
	IF (NEW.id_usuario IS NOT NULL) THEN
		--Verifico que el usuario exista en la tabla de usuarios
		SELECT u.id INTO user_id FROM usuario u WHERE u.id = NEW.id_usuario;
		IF (user_id IS NOT NULL) THEN
			--Verifico que el nuevo estado "completado" se corresponda con la existencia de la registracion en la tabla empresa
			SELECT COUNT(*) > 0 INTO tiene_empresa FROM empresa e WHERE e.id_usuario = NEW.id_usuario;
			IF(tiene_empresa) THEN
				NEW.completo = TRUE;
			ELSE
				NEW.completo = FALSE;
			END IF;
		ELSE
			RAISE EXCEPTION 'No existe el usuario con ID "%"',NEW.id_usuario;
		END IF;
	ELSE
		RAISE EXCEPTION 'El ID del usuario es obligatorio.';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_registracion() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 33185)
-- Name: update_rol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_rol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	output integer;
BEGIN
	IF (NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	IF(NEW.descripcion IS NOT NULL) THEN
		NEW.descripcion = upper(OLD.descripcion);
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_rol() OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 33204)
-- Name: update_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	rol character varying(40);
BEGIN 
	--Verifico que no se haya modificado el id del usuario, el sistema genera esto automaticamente
	IF(NEW.id <> OLD.id) THEN 
		NEW.id = OLD.id;
	END IF;
	--Verifico que no se haya modificado la fecha de creacion
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	--Verifico que el campo foraneo "id_rol" no este vacio
	IF (NEW.id_rol IS NULL) THEN
		SELECT r.id INTO rol FROM rol r WHERE r.descripcion = 'USUARIO';
		IF (rol IS NULL) THEN
			RAISE EXCEPTION 'El rol Usuario no existe. No se puede asignar el rol automaticamente ya que no esta presente en la tabla de roles';
		END IF;
		NEW.id_rol = rol;
	ELSE
		--Verifico que el rol exista en la tabla roles
		SELECT r.id INTO rol FROM rol r WHERE r.id = NEW.id_rol;
		IF (rol IS NULL) THEN
			SELECT r.id INTO rol FROM rol r WHERE r.descripcion = 'USUARIO';
			IF (rol IS NULL) THEN
				RAISE EXCEPTION 'El rol Usuario no existe. No se puede asignar el rol automaticamente ya que no esta presente en la tabla de roles';
			END IF;
			NEW.id_rol = rol;
		END IF;
	END IF;
	--Verifico que el nombre de usuario no sea vacio
	IF (NEW.username IS NULL) THEN
		RAISE EXCEPTION 'Usuario nulo. No valido. Se requiere un valor';
	END IF;
	--Verifico que la contraseña sea valida
	IF (NEW.password IS NULL) THEN
		RAISE EXCEPTION 'Contraseña nula. No valida. Se requiere un valor';
	ELSE
		IF(NEW.password <> OLD.password) THEN
			NEW.password = encode(digest(NEW.password, 'sha1'), 'hex')::character varying;
		END IF;
	END IF;
	--Verifico que no se modifique la fecha de creacion
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	NEW.fecha_ultima_modificacion = now();
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_user() OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 33222)
-- Name: user_by_username(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION user_by_username(usr character varying) RETURNS registro_usuario
    LANGUAGE plpgsql
    AS $$
DECLARE
	result registro_usuario;
BEGIN 
	SELECT * into result FROM usuario u WHERE u.username = usr LIMIT 1;
	RETURN result;
END;
$$;


ALTER FUNCTION public.user_by_username(usr character varying) OWNER TO postgres;

--
-- TOC entry 2350 (class 0 OID 0)
-- Dependencies: 264
-- Name: FUNCTION user_by_username(usr character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION user_by_username(usr character varying) IS 'Obtiene todos los datos de un usuario a partir del nombre de usuario';


--
-- TOC entry 201 (class 1255 OID 33116)
-- Name: uuid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION uuid() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	output character varying(255);
BEGIN
	SELECT md5(random()::text || clock_timestamp()::text)::uuid INTO output;
	output = replace(output,'-','');
	RETURN output;
END;
$$;


ALTER FUNCTION public.uuid() OWNER TO postgres;

--
-- TOC entry 2351 (class 0 OID 0)
-- Dependencies: 201
-- Name: FUNCTION uuid(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION uuid() IS 'Genera un ID universal de 32 caracteres aleatorios. Evita las colisiones.';


--
-- TOC entry 305 (class 1255 OID 41503)
-- Name: validate_cuit(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION validate_cuit(cuit character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	cuit_array text[];
	serie integer[];
	aux integer;
	result boolean;
BEGIN
	result = false;
	--Varifico que el cuit no sea nulo
	IF (cuit IS NULL) THEN
		RAISE EXCEPTION 'Debe ingresar un cuit. Solicitud rechazada';
	ELSE
		--Verifico que el cuit este bien formado
		IF (cuit ~ '^(\d){2}-(\d){8}-(\d)|(\d){11}') THEN
			--Elimino los '-' si es necesario
			IF (char_length(cuit) = 13) THEN
				cuit = regexp_replace(cuit,'-','','g');
			END IF;
			cuit_array = regexp_split_to_array(cuit,'');
			serie = array[5,4,3,2,7,6,5,4,3,2];
			aux = 0;
			FOR i IN 1..10 LOOP
				aux = aux + cuit_array[i]::integer * serie[i];
			END LOOP;
			aux = 11 - (aux % 11);
			IF (aux = 11) THEN
				aux = 0;
			ELSE
				IF (aux = 10) THEN
					aux = 9;
				END IF;
			END IF;
			IF (aux = cuit_array[11]::integer) THEN 
				result = true;
			END IF;
		ELSE
			RAISE EXCEPTION 'CUIT con formato incorrecto. Solicitud rechazada.';
		END IF;
	END IF;
	return result;
END;
$$;


ALTER FUNCTION public.validate_cuit(cuit character varying) OWNER TO postgres;

--
-- TOC entry 2352 (class 0 OID 0)
-- Dependencies: 305
-- Name: FUNCTION validate_cuit(cuit character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION validate_cuit(cuit character varying) IS 'Valida si una cadena de caracteres tiene el formato aceptado por la Argentina del Numero de CUIL/CUIT';


--
-- TOC entry 255 (class 1255 OID 33203)
-- Name: validateemail(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION validateemail(email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
	IF (email !~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9-]+[.][A-Za-z]+$') THEN
		RETURN FALSE;
	ELSE
		RETURN TRUE;
	END IF;
END
$_$;


ALTER FUNCTION public.validateemail(email character varying) OWNER TO postgres;

--
-- TOC entry 2353 (class 0 OID 0)
-- Dependencies: 255
-- Name: FUNCTION validateemail(email character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION validateemail(email character varying) IS 'Valida un email retornando TRUE si cumple con el formato estandar y FALSE en caso contrario.';


--
-- TOC entry 276 (class 1255 OID 33285)
-- Name: vencio(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION vencio(fecha date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	
BEGIN 
	IF (fecha > now()::date) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;


ALTER FUNCTION public.vencio(fecha date) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 33284)
-- Name: verificar_vencimiento(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION verificar_vencimiento(fecha date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	
BEGIN 
	IF (fecha > now()::date) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;


ALTER FUNCTION public.verificar_vencimiento(fecha date) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 188 (class 1259 OID 41413)
-- Name: mensaje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE mensaje (
    id character varying(32) NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    fecha_ultima_modificacion timestamp with time zone NOT NULL,
    contenido text NOT NULL,
    nombre character varying(75) NOT NULL,
    email character varying(75) NOT NULL,
    leido boolean DEFAULT false NOT NULL
);


ALTER TABLE mensaje OWNER TO postgres;

--
-- TOC entry 2354 (class 0 OID 0)
-- Dependencies: 188
-- Name: TABLE mensaje; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE mensaje IS 'Representa la acción de enviar un mensaje al administrador del sistema.';


--
-- TOC entry 2355 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN mensaje.contenido; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN mensaje.contenido IS 'Representa el texto que envia la persona';


--
-- TOC entry 2356 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN mensaje.nombre; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN mensaje.nombre IS 'Nombre de la persona que envia el mensaje. Si el usuario esta registrado entonces el nombre debe ser igual al nombre del responsable de la empresa.';


--
-- TOC entry 2357 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN mensaje.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN mensaje.email IS 'Representa el mail del usuario que envia el mensaje. Si el usuario esta registrado este dato es igual al email de la tabla "Registracion" del mismo usuario.';


--
-- TOC entry 2358 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN mensaje.leido; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN mensaje.leido IS 'Representa el estado del mensaje. TRUE si el administrador ya lo leyo, FALSE en otro caso.';


--
-- TOC entry 181 (class 1259 OID 33169)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuario (
    id character varying(32) NOT NULL,
    username character varying(32) NOT NULL,
    password character varying(40) NOT NULL,
    fecha_creacion timestamp with time zone,
    fecha_ultima_modificacion timestamp with time zone,
    activo boolean DEFAULT true NOT NULL,
    id_rol character varying(32),
    ultima_conexion timestamp with time zone,
    email character varying(75) NOT NULL
);


ALTER TABLE usuario OWNER TO postgres;

--
-- TOC entry 2360 (class 0 OID 0)
-- Dependencies: 181
-- Name: TABLE usuario; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE usuario IS 'Contiene al conjunto de usuarios registrados para utilizar el sistema';


--
-- TOC entry 195 (class 1259 OID 41585)
-- Name: cantidad_tipo_mensajes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cantidad_tipo_mensajes AS
 SELECT registrados.total_r,
    no_registrados.total_nr
   FROM ( SELECT count(m.email) AS total_r
           FROM mensaje m
          WHERE (NOT ((m.email)::text IN ( SELECT u.email
                   FROM usuario u)))) registrados,
    ( SELECT count(m.email) AS total_nr
           FROM mensaje m
          WHERE ((m.email)::text IN ( SELECT u.email
                   FROM usuario u))) no_registrados;


ALTER TABLE cantidad_tipo_mensajes OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 33120)
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE config (
    id character varying(32) NOT NULL,
    dia_emision integer NOT NULL,
    dia_vencimiento integer NOT NULL,
    fecha_creacion timestamp with time zone,
    fecha_ultima_modificacion timestamp with time zone
);


ALTER TABLE config OWNER TO postgres;

--
-- TOC entry 2363 (class 0 OID 0)
-- Dependencies: 180
-- Name: TABLE config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE config IS 'Esta tabla solo puede contener un registro y solo uno. Contiene los dias del mes en los cuales se emite y vencen las cuotas de las empresas.';


--
-- TOC entry 182 (class 1259 OID 33175)
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE rol (
    id character varying(32) NOT NULL,
    descripcion character varying(40) NOT NULL
);


ALTER TABLE rol OWNER TO postgres;

--
-- TOC entry 2365 (class 0 OID 0)
-- Dependencies: 182
-- Name: TABLE rol; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE rol IS 'Representa el rol de cada usuario. Siempre un usuario debe tener un rol y solo uno.';


--
-- TOC entry 196 (class 1259 OID 41589)
-- Name: count_user_actives; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW count_user_actives AS
 SELECT count(*) AS count
   FROM usuario u,
    rol r
  WHERE (((u.id_rol)::text = (r.id)::text) AND (u.activo = true) AND ((r.descripcion)::text = 'USUARIO'::text));


ALTER TABLE count_user_actives OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 41593)
-- Name: count_user_inactives; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW count_user_inactives AS
 SELECT count(*) AS count
   FROM usuario u,
    rol r
  WHERE (((u.id_rol)::text = (r.id)::text) AND (u.activo = false) AND ((r.descripcion)::text = 'USUARIO'::text));


ALTER TABLE count_user_inactives OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 33242)
-- Name: cuota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cuota (
    id character varying(32) NOT NULL,
    id_empresa character varying(32) NOT NULL,
    fecha_emision date NOT NULL,
    fecha_vencimiento date NOT NULL,
    cantidad_empleados integer,
    importe double precision,
    intereses double precision,
    periodo character varying(32),
    id_estado character varying(32) NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    fecha_ultima_modificacion timestamp with time zone NOT NULL,
    remuneracion_total double precision DEFAULT 0
);


ALTER TABLE cuota OWNER TO postgres;

--
-- TOC entry 2369 (class 0 OID 0)
-- Dependencies: 185
-- Name: TABLE cuota; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE cuota IS 'Representa la cuota mensual que abona el responsable de cada empresa';


--
-- TOC entry 2370 (class 0 OID 0)
-- Dependencies: 185
-- Name: COLUMN cuota.periodo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN cuota.periodo IS 'Representa el mes en el cual se cobra la cuota';


--
-- TOC entry 184 (class 1259 OID 33223)
-- Name: empresa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE empresa (
    responsable character varying(75) NOT NULL,
    actividad_principal character varying(75) NOT NULL,
    fecha_inicio_actividad date NOT NULL,
    email character varying(75) NOT NULL,
    domicilio character varying(75) NOT NULL,
    telefono_uno character varying(20),
    telefono_dos character varying(20),
    id_usuario character varying(32) NOT NULL,
    fecha_emision_proxima_cuota date,
    fecha_creacion timestamp with time zone,
    fecha_ultima_modificacion timestamp with time zone,
    razon_social character varying(75) NOT NULL,
    cuit character varying(13) NOT NULL
);


ALTER TABLE empresa OWNER TO postgres;

--
-- TOC entry 2372 (class 0 OID 0)
-- Dependencies: 184
-- Name: TABLE empresa; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE empresa IS 'Representa la entidad afiliada al sindicato';


--
-- TOC entry 186 (class 1259 OID 33252)
-- Name: estado_cuota; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE estado_cuota (
    id character varying(32) NOT NULL,
    nombre character varying(32) NOT NULL,
    descripcion text
);


ALTER TABLE estado_cuota OWNER TO postgres;

--
-- TOC entry 2374 (class 0 OID 0)
-- Dependencies: 186
-- Name: TABLE estado_cuota; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE estado_cuota IS 'Representa los posibles estados de las cuotas emitidas por el sistema';


--
-- TOC entry 194 (class 1259 OID 41565)
-- Name: mensajes_from_user; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW mensajes_from_user AS
 SELECT m.id,
    m.fecha_creacion,
    m.fecha_ultima_modificacion,
    m.contenido,
    m.nombre,
    m.email,
    m.leido,
    mails.em
   FROM mensaje m,
    ( SELECT u.email AS em
           FROM usuario u) mails
  WHERE ((mails.em)::text = (m.email)::text);


ALTER TABLE mensajes_from_user OWNER TO postgres;

--
-- TOC entry 2376 (class 0 OID 0)
-- Dependencies: 194
-- Name: VIEW mensajes_from_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW mensajes_from_user IS 'Devuelve todos los registros de la tabla mensajes si y solo si dichos mensajes fueron enviados por usuarios registrados al sistema (email del mensaje es igual al email de algun registro de la tabla usuario)';


--
-- TOC entry 187 (class 1259 OID 41395)
-- Name: registracion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE registracion (
    completo boolean DEFAULT false,
    id_usuario character varying(32) NOT NULL,
    token character varying(32),
    email character varying(75) NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    fecha_ultima_modificacion timestamp with time zone NOT NULL
);


ALTER TABLE registracion OWNER TO postgres;

--
-- TOC entry 2378 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE registracion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE registracion IS 'Representa la accion de registración de los responsables a cargo de la empresa (usuarios comunes).';


--
-- TOC entry 2323 (class 0 OID 33120)
-- Dependencies: 180
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO config (id, dia_emision, dia_vencimiento, fecha_creacion, fecha_ultima_modificacion) VALUES ('66ad9ebf7f50621f018a1cb260ca56ce', 2, 15, '2015-12-01 03:17:07.086097-03', '2015-12-02 17:56:48.875111-03');


--
-- TOC entry 2327 (class 0 OID 33242)
-- Dependencies: 185
-- Data for Name: cuota; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cuota (id, id_empresa, fecha_emision, fecha_vencimiento, cantidad_empleados, importe, intereses, periodo, id_estado, fecha_creacion, fecha_ultima_modificacion, remuneracion_total) VALUES ('5265f33b82cbc8b1dfccfcec38fd0da3', '929e6e49d13d80e8866632a14ed2d9cc', '2016-01-02', '2016-01-15', 586, 64202.160000000003, 0, 'Diciembre', '537f283e05b578760e3d4c375472aeeb', '2015-12-08 21:22:46.23643-03', '2015-12-08 21:23:27.802363-03', 5478);
INSERT INTO cuota (id, id_empresa, fecha_emision, fecha_vencimiento, cantidad_empleados, importe, intereses, periodo, id_estado, fecha_creacion, fecha_ultima_modificacion, remuneracion_total) VALUES ('9354b25f5808f32fae965564c21e8dee', '929e6e49d13d80e8866632a14ed2d9cc', '2016-01-02', '2016-01-15', 587, 2981.96, 0, 'Diciembre', '537f283e05b578760e3d4c375472aeeb', '2015-12-08 21:16:00.012388-03', '2015-12-08 21:24:13.151643-03', 254);
INSERT INTO cuota (id, id_empresa, fecha_emision, fecha_vencimiento, cantidad_empleados, importe, intereses, periodo, id_estado, fecha_creacion, fecha_ultima_modificacion, remuneracion_total) VALUES ('9663138d5c4a9a5fb6be2c8054e3ce26', '929e6e49d13d80e8866632a14ed2d9cc', '2016-01-02', '2015-12-07', 451, 13791.58, 0, 'Diciembre', '2dc29815f2f16885d7755bdec79162c9', '2015-12-08 21:50:00.168984-03', '2015-12-08 22:36:59.802257-03', 1529);


--
-- TOC entry 2326 (class 0 OID 33223)
-- Dependencies: 184
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO empresa (responsable, actividad_principal, fecha_inicio_actividad, email, domicilio, telefono_uno, telefono_dos, id_usuario, fecha_emision_proxima_cuota, fecha_creacion, fecha_ultima_modificacion, razon_social, cuit) VALUES ('Gonzalo', 'Venta de Productos', '2015-12-07', 'gonzalohumen@hotmail.com', 'B� Pujol M4 C7', '12345678901234567890', '', '929e6e49d13d80e8866632a14ed2d9cc', '2016-01-02', '2015-12-08 21:22:46.23643-03', '2015-12-08 22:26:18.588582-03', 'Kiosco Humen', '20-34093153-0');


--
-- TOC entry 2328 (class 0 OID 33252)
-- Dependencies: 186
-- Data for Name: estado_cuota; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO estado_cuota (id, nombre, descripcion) VALUES ('2dc29815f2f16885d7755bdec79162c9', 'EN MORA', 'Cuando la fecha actual es posterior a la fecha de vencimiento de la cuota');
INSERT INTO estado_cuota (id, nombre, descripcion) VALUES ('9a9e8e3f0bf3bb71968caa0d741eddab', 'GESTIONADO', 'Cuando el administrador verifica que el pago fue impactado en la cuenta corriente del Banco ');
INSERT INTO estado_cuota (id, nombre, descripcion) VALUES ('b052525083c3a75425a559e288b8077f', 'PENDIENTE', 'Cuando la cuota se encuentra dentro del rango de validez, es decir que desde que se emitió todavia no ha alcanzado la fecha de vencimiento');
INSERT INTO estado_cuota (id, nombre, descripcion) VALUES ('537f283e05b578760e3d4c375472aeeb', 'AVISADO', 'Cuando la empresa realiza el pago de la cuota correspondiente y da aviso al sistema');


--
-- TOC entry 2330 (class 0 OID 41413)
-- Dependencies: 188
-- Data for Name: mensaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('35e9247b323133dcec501be70e5973ba', '2015-12-05 20:42:24.707966-03', '2015-12-05 20:42:24.707966-03', 'Mensaje de desconocido', 'Pepe', 'pepe@gmail.com', false);
INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('e1b6bf37d50be699334f442e876af81c', '2015-12-05 19:51:48.273292-03', '2015-12-05 22:14:30.727037-03', 'Mensaje de un usuario', 'Gonza', 'gonzalo@gmail.com', false);
INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('5a87b80a3ecfcdb7548e7be2263798bd', '2015-12-07 01:28:45.635004-03', '2015-12-07 01:28:45.635004-03', 'copado', 'Gonzalo', 'gonza524@gmail.com', false);
INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('50aa93a94e3ec752326feccf137706f7', '2015-12-07 01:32:31.586928-03', '2015-12-07 01:32:31.586928-03', 'Esta es una prueba', 'Gonza', 'copado@gmail.com', false);
INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('93757e7bac13edb289db8c18daa6d1fb', '2015-12-07 01:34:39.485243-03', '2015-12-07 01:34:39.485243-03', '', 'hjjh', 'sdasdads@gmail.com', false);
INSERT INTO mensaje (id, fecha_creacion, fecha_ultima_modificacion, contenido, nombre, email, leido) VALUES ('11342a56391ae12448efb6181d4f408f', '2015-12-08 05:33:43.708714-03', '2015-12-08 05:33:43.708714-03', 'Bueno esta bien', 'Gonza', 'sdasdads@gmail.com', false);


--
-- TOC entry 2329 (class 0 OID 41395)
-- Dependencies: 187
-- Data for Name: registracion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO registracion (completo, id_usuario, token, email, fecha_creacion, fecha_ultima_modificacion) VALUES (true, '929e6e49d13d80e8866632a14ed2d9cc', '32046e312c2d13cb60f0155f9cf36a13', 'yogonza524@gmail.com', '2015-12-08 21:22:00.363806-03', '2015-12-08 21:22:46.23643-03');


--
-- TOC entry 2325 (class 0 OID 33175)
-- Dependencies: 182
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO rol (id, descripcion) VALUES ('63dddf6eff57bfc926b838f5af0e3c4d', 'ADMINISTRADOR');
INSERT INTO rol (id, descripcion) VALUES ('367925a5490635e6733de20d33e4a678', 'USUARIO');


--
-- TOC entry 2324 (class 0 OID 33169)
-- Dependencies: 181
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO usuario (id, username, password, fecha_creacion, fecha_ultima_modificacion, activo, id_rol, ultima_conexion, email) VALUES ('929e6e49d13d80e8866632a14ed2d9cc', 'gonza', 'aa2e057f0e1cfe9aab382480f5caebc8f449d739', '2015-12-08 21:22:00.363806-03', '2015-12-09 00:23:40.178338-03', true, '367925a5490635e6733de20d33e4a678', NULL, 'yogonza524@gmail.com');


--
-- TOC entry 2156 (class 2606 OID 33288)
-- Name: config_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pk PRIMARY KEY (id);


--
-- TOC entry 2180 (class 2606 OID 41421)
-- Name: contacto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY mensaje
    ADD CONSTRAINT contacto_pk PRIMARY KEY (id);


--
-- TOC entry 2170 (class 2606 OID 33246)
-- Name: cuota_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cuota
    ADD CONSTRAINT cuota_pk PRIMARY KEY (id, id_empresa);


--
-- TOC entry 2176 (class 2606 OID 41411)
-- Name: email_registrado_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registracion
    ADD CONSTRAINT email_registrado_unique UNIQUE (email);


--
-- TOC entry 2168 (class 2606 OID 41430)
-- Name: emp_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY empresa
    ADD CONSTRAINT emp_pk PRIMARY KEY (id_usuario);


--
-- TOC entry 2172 (class 2606 OID 33256)
-- Name: estado_cuota_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estado_cuota
    ADD CONSTRAINT estado_cuota_pk PRIMARY KEY (id);


--
-- TOC entry 2178 (class 2606 OID 41455)
-- Name: register_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registracion
    ADD CONSTRAINT register_pk PRIMARY KEY (id_usuario);


--
-- TOC entry 2164 (class 2606 OID 33179)
-- Name: rol_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rol
    ADD CONSTRAINT rol_id PRIMARY KEY (id);


--
-- TOC entry 2158 (class 2606 OID 41462)
-- Name: unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 2174 (class 2606 OID 33263)
-- Name: unique_nombre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY estado_cuota
    ADD CONSTRAINT unique_nombre UNIQUE (nombre);


--
-- TOC entry 2166 (class 2606 OID 41564)
-- Name: unique_rol; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rol
    ADD CONSTRAINT unique_rol UNIQUE (descripcion);


--
-- TOC entry 2160 (class 2606 OID 41439)
-- Name: unique_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT unique_user UNIQUE (username);


--
-- TOC entry 2162 (class 2606 OID 41432)
-- Name: user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 2196 (class 2620 OID 41493)
-- Name: after_delete_empresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_delete_empresa AFTER DELETE ON empresa FOR EACH ROW EXECUTE PROCEDURE after_delete_empresa();


--
-- TOC entry 2195 (class 2620 OID 41460)
-- Name: after_insert_empresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_empresa AFTER INSERT ON empresa FOR EACH ROW EXECUTE PROCEDURE after_insert_empresa();


--
-- TOC entry 2190 (class 2620 OID 41457)
-- Name: after_insert_user; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_user AFTER INSERT ON usuario FOR EACH ROW EXECUTE PROCEDURE after_insert_user();


--
-- TOC entry 2186 (class 2620 OID 33281)
-- Name: config_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER config_insert BEFORE INSERT ON config FOR EACH ROW EXECUTE PROCEDURE config_insert();


--
-- TOC entry 2197 (class 2620 OID 33275)
-- Name: insert_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_cuota BEFORE INSERT ON cuota FOR EACH ROW EXECUTE PROCEDURE insert_cuota();


--
-- TOC entry 2193 (class 2620 OID 33239)
-- Name: insert_empresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_empresa BEFORE INSERT ON empresa FOR EACH ROW EXECUTE PROCEDURE insert_empresa();


--
-- TOC entry 2199 (class 2620 OID 33258)
-- Name: insert_estado_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_estado_cuota BEFORE INSERT ON estado_cuota FOR EACH ROW EXECUTE PROCEDURE insert_estado_cuota();


--
-- TOC entry 2203 (class 2620 OID 41423)
-- Name: insert_mensaje; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_mensaje BEFORE INSERT ON mensaje FOR EACH ROW EXECUTE PROCEDURE insert_mensaje();


--
-- TOC entry 2201 (class 2620 OID 41407)
-- Name: insert_registracion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_registracion BEFORE INSERT ON registracion FOR EACH ROW EXECUTE PROCEDURE insert_registracion();


--
-- TOC entry 2189 (class 2620 OID 33207)
-- Name: insert_user; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_user BEFORE INSERT ON usuario FOR EACH ROW EXECUTE PROCEDURE insert_user();


--
-- TOC entry 2191 (class 2620 OID 33181)
-- Name: rol_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER rol_insert BEFORE INSERT ON rol FOR EACH ROW EXECUTE PROCEDURE rol_insert();


--
-- TOC entry 2187 (class 2620 OID 33282)
-- Name: update_config; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_config BEFORE UPDATE ON config FOR EACH ROW EXECUTE PROCEDURE update_config();


--
-- TOC entry 2198 (class 2620 OID 33277)
-- Name: update_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_cuota BEFORE UPDATE ON cuota FOR EACH ROW EXECUTE PROCEDURE update_cuota();


--
-- TOC entry 2194 (class 2620 OID 33241)
-- Name: update_empresa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_empresa BEFORE UPDATE ON empresa FOR EACH ROW EXECUTE PROCEDURE update_empresa();


--
-- TOC entry 2200 (class 2620 OID 33261)
-- Name: update_estado_cuota; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_estado_cuota BEFORE UPDATE ON estado_cuota FOR EACH ROW EXECUTE PROCEDURE update_estado_cuota();


--
-- TOC entry 2204 (class 2620 OID 41425)
-- Name: update_mensaje; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_mensaje BEFORE UPDATE ON mensaje FOR EACH ROW EXECUTE PROCEDURE update_mensaje();


--
-- TOC entry 2202 (class 2620 OID 41409)
-- Name: update_registracion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_registracion BEFORE UPDATE ON registracion FOR EACH ROW EXECUTE PROCEDURE update_registracion();


--
-- TOC entry 2192 (class 2620 OID 33186)
-- Name: update_rol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_rol BEFORE UPDATE ON rol FOR EACH ROW EXECUTE PROCEDURE update_rol();


--
-- TOC entry 2188 (class 2620 OID 33205)
-- Name: update_user; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user BEFORE UPDATE ON usuario FOR EACH ROW EXECUTE PROCEDURE update_user();


--
-- TOC entry 2183 (class 2606 OID 41468)
-- Name: cuota_emp_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cuota
    ADD CONSTRAINT cuota_emp_fk FOREIGN KEY (id_empresa) REFERENCES empresa(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 2184 (class 2606 OID 41478)
-- Name: email_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registracion
    ADD CONSTRAINT email_user_fk FOREIGN KEY (email) REFERENCES usuario(email) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2182 (class 2606 OID 41473)
-- Name: emp_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY empresa
    ADD CONSTRAINT emp_user_fk FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;


--
-- TOC entry 2185 (class 2606 OID 41483)
-- Name: register_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY registracion
    ADD CONSTRAINT register_user_fk FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;


--
-- TOC entry 2181 (class 2606 OID 33193)
-- Name: rol_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT rol_fk FOREIGN KEY (id_rol) REFERENCES rol(id);


--
-- TOC entry 2337 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2359 (class 0 OID 0)
-- Dependencies: 188
-- Name: mensaje; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mensaje FROM PUBLIC;
REVOKE ALL ON TABLE mensaje FROM postgres;
GRANT ALL ON TABLE mensaje TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mensaje TO adminfihclmu;


--
-- TOC entry 2361 (class 0 OID 0)
-- Dependencies: 181
-- Name: usuario; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE usuario FROM PUBLIC;
REVOKE ALL ON TABLE usuario FROM postgres;
GRANT ALL ON TABLE usuario TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE usuario TO adminfihclmu;


--
-- TOC entry 2362 (class 0 OID 0)
-- Dependencies: 195
-- Name: cantidad_tipo_mensajes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cantidad_tipo_mensajes FROM PUBLIC;
REVOKE ALL ON TABLE cantidad_tipo_mensajes FROM postgres;
GRANT ALL ON TABLE cantidad_tipo_mensajes TO postgres;
GRANT SELECT ON TABLE cantidad_tipo_mensajes TO adminfihclmu;


--
-- TOC entry 2364 (class 0 OID 0)
-- Dependencies: 180
-- Name: config; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE config FROM PUBLIC;
REVOKE ALL ON TABLE config FROM postgres;
GRANT ALL ON TABLE config TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE config TO adminfihclmu;


--
-- TOC entry 2366 (class 0 OID 0)
-- Dependencies: 182
-- Name: rol; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE rol FROM PUBLIC;
REVOKE ALL ON TABLE rol FROM postgres;
GRANT ALL ON TABLE rol TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE rol TO adminfihclmu;


--
-- TOC entry 2367 (class 0 OID 0)
-- Dependencies: 196
-- Name: count_user_actives; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE count_user_actives FROM PUBLIC;
REVOKE ALL ON TABLE count_user_actives FROM postgres;
GRANT ALL ON TABLE count_user_actives TO postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,UPDATE ON TABLE count_user_actives TO PUBLIC;
GRANT SELECT ON TABLE count_user_actives TO adminfihclmu;


--
-- TOC entry 2368 (class 0 OID 0)
-- Dependencies: 197
-- Name: count_user_inactives; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE count_user_inactives FROM PUBLIC;
REVOKE ALL ON TABLE count_user_inactives FROM postgres;
GRANT ALL ON TABLE count_user_inactives TO postgres;
GRANT SELECT ON TABLE count_user_inactives TO adminfihclmu;


--
-- TOC entry 2371 (class 0 OID 0)
-- Dependencies: 185
-- Name: cuota; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cuota FROM PUBLIC;
REVOKE ALL ON TABLE cuota FROM postgres;
GRANT ALL ON TABLE cuota TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cuota TO adminfihclmu;


--
-- TOC entry 2373 (class 0 OID 0)
-- Dependencies: 184
-- Name: empresa; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE empresa FROM PUBLIC;
REVOKE ALL ON TABLE empresa FROM postgres;
GRANT ALL ON TABLE empresa TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE empresa TO adminfihclmu;


--
-- TOC entry 2375 (class 0 OID 0)
-- Dependencies: 186
-- Name: estado_cuota; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE estado_cuota FROM PUBLIC;
REVOKE ALL ON TABLE estado_cuota FROM postgres;
GRANT ALL ON TABLE estado_cuota TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE estado_cuota TO adminfihclmu;


--
-- TOC entry 2377 (class 0 OID 0)
-- Dependencies: 194
-- Name: mensajes_from_user; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE mensajes_from_user FROM PUBLIC;
REVOKE ALL ON TABLE mensajes_from_user FROM postgres;
GRANT ALL ON TABLE mensajes_from_user TO postgres;
GRANT SELECT ON TABLE mensajes_from_user TO adminfihclmu;


--
-- TOC entry 2379 (class 0 OID 0)
-- Dependencies: 187
-- Name: registracion; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE registracion FROM PUBLIC;
REVOKE ALL ON TABLE registracion FROM postgres;
GRANT ALL ON TABLE registracion TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE registracion TO adminfihclmu;


-- Completed on 2015-12-09 01:26:53

--
-- PostgreSQL database dump complete
--

