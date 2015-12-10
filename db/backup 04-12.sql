PGDMP          )                s           sindicatopgp    9.5beta1    9.5beta1 �    	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            	           1262    33106    sindicatopgp    DATABASE     �   CREATE DATABASE sindicatopgp WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE sindicatopgp;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            		           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6            �            3079    12355    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            
	           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    194            �            3079    33132    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                  false    6            	           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                       false    196            �            3079    41504    pldbgapi 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;
    DROP EXTENSION pldbgapi;
                  false    6            	           0    0    EXTENSION pldbgapi    COMMENT     Y   COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';
                       false    195            �           1247    33221    registro_usuario    TYPE     .  CREATE TYPE registro_usuario AS (
	id character varying(32),
	username character varying(32),
	password character varying(40),
	fecha_creacion timestamp with time zone,
	fecha_ultima_modificacion timestamp with time zone,
	activo boolean,
	id_rol character varying(32),
	email character varying(75)
);
 #   DROP TYPE public.registro_usuario;
       public       postgres    false    6            �            1255    41502 B   add_admin(character varying, character varying, character varying)    FUNCTION     k  CREATE FUNCTION add_admin(username character varying, pass character varying, email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	result boolean;
BEGIN
	INSERT INTO usuario(username,password,email,id_rol) VALUES(username,pass,email,'63dddf6eff57bfc926b838f5af0e3c4d') RETURNING (id IS NOT NULL) INTO result;
	RETURN result;
END;	
$$;
 m   DROP FUNCTION public.add_admin(username character varying, pass character varying, email character varying);
       public       postgres    false    194    6            	           0    0 _   FUNCTION add_admin(username character varying, pass character varying, email character varying)    COMMENT     �   COMMENT ON FUNCTION add_admin(username character varying, pass character varying, email character varying) IS 'Agrega un usuario con el Rol de Administrador a la Base de datos';
            public       postgres    false    255            +           1255    41495 A   add_user(character varying, character varying, character varying)    FUNCTION     @  CREATE FUNCTION add_user(username character varying, pass character varying, email character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	result boolean;
BEGIN
	INSERT INTO usuario(username,password,email) VALUES(username,pass,email) RETURNING (id IS NOT NULL) INTO result;
	RETURN result;
END;	
$$;
 l   DROP FUNCTION public.add_user(username character varying, pass character varying, email character varying);
       public       postgres    false    194    6            	           0    0 ^   FUNCTION add_user(username character varying, pass character varying, email character varying)    COMMENT     �   COMMENT ON FUNCTION add_user(username character varying, pass character varying, email character varying) IS 'Agrega un usuario nuevo a la base de datos';
            public       postgres    false    299            *           1255    41492    after_delete_empresa()    FUNCTION       CREATE FUNCTION after_delete_empresa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE registracion SET completo = FALSE 
		WHERE registracion.id_usuario = OLD.id_usuario;
	DELETE FROM cuota WHERE cuota.id_empresa = OLD.id_usuario;
	RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.after_delete_empresa();
       public       postgres    false    6    194            )           1255    41459    after_insert_empresa()    FUNCTION     8  CREATE FUNCTION after_insert_empresa() RETURNS trigger
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
 -   DROP FUNCTION public.after_insert_empresa();
       public       postgres    false    6    194            (           1255    41456    after_insert_user()    FUNCTION     �   CREATE FUNCTION after_insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO registracion(completo,id_usuario,token,email) VALUES(
		FALSE, NEW.id, uuid(),NEW.email
	);
	RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.after_insert_user();
       public       postgres    false    194    6            	           1255    33273    arg_month(date)    FUNCTION     )  CREATE FUNCTION arg_month(fecha date) RETURNS character varying
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
 ,   DROP FUNCTION public.arg_month(fecha date);
       public       postgres    false    6    194            	           0    0    FUNCTION arg_month(fecha date)    COMMENT     }   COMMENT ON FUNCTION arg_month(fecha date) IS 'Devuelve una cadena de caracters que representa el mes en español Argentino';
            public       postgres    false    265            �            1255    33127    betweendays(date)    FUNCTION     
  CREATE FUNCTION betweendays(fecha date) RETURNS integer
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
 .   DROP FUNCTION public.betweendays(fecha date);
       public       postgres    false    194    6            	           0    0     FUNCTION betweendays(fecha date)    COMMENT     �   COMMENT ON FUNCTION betweendays(fecha date) IS 'Devuelve la diferencia de dias entre dos fechas dadas. Dependiendo de cual sea mayor los valores pueden ser positivios, negativos o cero si ambas fechas son iguales';
            public       postgres    false    198                        1255    41500 5   change_password(character varying, character varying)    FUNCTION       CREATE FUNCTION change_password(id_user character varying, pass character varying) RETURNS boolean
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
 Y   DROP FUNCTION public.change_password(id_user character varying, pass character varying);
       public       postgres    false    6    194                       1255    33286    compare_fecha_hoy(date)    FUNCTION     �   CREATE FUNCTION compare_fecha_hoy(fecha date) RETURNS boolean
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
 4   DROP FUNCTION public.compare_fecha_hoy(fecha date);
       public       postgres    false    194    6            
           1255    33130    config_insert()    FUNCTION     �  CREATE FUNCTION config_insert() RETURNS trigger
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
 &   DROP FUNCTION public.config_insert();
       public       postgres    false    194    6            -           1255    41499    count_admins()    FUNCTION     �   CREATE FUNCTION count_admins() RETURNS integer
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
 %   DROP FUNCTION public.count_admins();
       public       postgres    false    6    194            	           0    0    FUNCTION count_admins()    COMMENT     }   COMMENT ON FUNCTION count_admins() IS 'Cuenta la cantidad de usuarios registrados con el rol "ADMINISTRADOR" en el sistema';
            public       postgres    false    301            ,           1255    41498    count_users()    FUNCTION     �   CREATE FUNCTION count_users() RETURNS integer
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
 $   DROP FUNCTION public.count_users();
       public       postgres    false    6    194            	           0    0    FUNCTION count_users()    COMMENT     v   COMMENT ON FUNCTION count_users() IS 'Cuenta la cantidad de usuarios con el rol "USUARIO" registrados en el sistema';
            public       postgres    false    300            �            1255    33187    date_arg_format(date)    FUNCTION     �  CREATE FUNCTION date_arg_format(fecha date) RETURNS character varying
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
 2   DROP FUNCTION public.date_arg_format(fecha date);
       public       postgres    false    194    6            	           0    0 $   FUNCTION date_arg_format(fecha date)    COMMENT     �   COMMENT ON FUNCTION date_arg_format(fecha date) IS 'Obtiene la fecha en formato de cadena de caracteres y en estilo Argentino';
            public       postgres    false    250            �            1255    33201    delete_rol()    FUNCTION     �   CREATE FUNCTION delete_rol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	RAISE EXCEPTION 'No se puede eliminar. Solo se permite lectura';
END;
$$;
 #   DROP FUNCTION public.delete_rol();
       public       postgres    false    194    6                       1255    33209    disable_user(character varying)    FUNCTION     S  CREATE FUNCTION disable_user(id_u character varying) RETURNS boolean
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
 ;   DROP FUNCTION public.disable_user(id_u character varying);
       public       postgres    false    194    6            �            1255    33190    encode(character varying)    FUNCTION     �   CREATE FUNCTION encode(val character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN encode(digest(val, 'sha1'), 'hex')::character varying;
END;
$$;
 4   DROP FUNCTION public.encode(val character varying);
       public       postgres    false    194    6            �            1255    33278    get_fecha_emision()    FUNCTION     M  CREATE FUNCTION get_fecha_emision() RETURNS date
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
 *   DROP FUNCTION public.get_fecha_emision();
       public       postgres    false    6    194            	           0    0    FUNCTION get_fecha_emision()    COMMENT     u   COMMENT ON FUNCTION get_fecha_emision() IS 'Obtiene la fecha de emision de la cuota en función de la fecha actual';
            public       postgres    false    251                       1255    33283    get_fecha_vencimiento()    FUNCTION     ^  CREATE FUNCTION get_fecha_vencimiento() RETURNS date
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
 .   DROP FUNCTION public.get_fecha_vencimiento();
       public       postgres    false    194    6            	           0    0     FUNCTION get_fecha_vencimiento()    COMMENT     �   COMMENT ON FUNCTION get_fecha_vencimiento() IS 'Obtiene la fecha de vencimiento de la cuota en funcion de la fecha actual. Esta funcion se debe llamar cuando se realiza la agregacion de nuevas cuotas unicamente';
            public       postgres    false    271                        1255    33274    insert_cuota()    FUNCTION     �  CREATE FUNCTION insert_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_emp character varying;
	id_st character varying;
BEGIN 
	NEW.id = uuid();
	NEW.fecha_creacion = now();
	NEW.fecha_ultima_modificacion = now();
	NEW.importe = 0.0;
	NEW.cantidad_empleados = 0;
	NEW.intereses = 0.0;
	NEW.periodo = arg_month(now()::date);
	NEW.fecha_emision = get_fecha_emision();
	NEW.fecha_vencimiento = get_fecha_vencimiento();
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
	RETURN NEW;
END;
$$;
 %   DROP FUNCTION public.insert_cuota();
       public       postgres    false    6    194            1           1255    33238    insert_empresa()    FUNCTION       CREATE FUNCTION insert_empresa() RETURNS trigger
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
 '   DROP FUNCTION public.insert_empresa();
       public       postgres    false    194    6                       1255    33257    insert_estado_cuota()    FUNCTION       CREATE FUNCTION insert_estado_cuota() RETURNS trigger
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
 ,   DROP FUNCTION public.insert_estado_cuota();
       public       postgres    false    194    6            %           1255    41422    insert_mensaje()    FUNCTION     �  CREATE FUNCTION insert_mensaje() RETURNS trigger
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
 '   DROP FUNCTION public.insert_mensaje();
       public       postgres    false    194    6                       1255    41406    insert_registracion()    FUNCTION     �  CREATE FUNCTION insert_registracion() RETURNS trigger
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
 ,   DROP FUNCTION public.insert_registracion();
       public       postgres    false    6    194            '           1255    33206    insert_user()    FUNCTION     M  CREATE FUNCTION insert_user() RETURNS trigger
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
 $   DROP FUNCTION public.insert_user();
       public       postgres    false    194    6            �            1255    33192 +   login(character varying, character varying)    FUNCTION     �  CREATE FUNCTION login(usr character varying, pass character varying) RETURNS boolean
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
 K   DROP FUNCTION public.login(usr character varying, pass character varying);
       public       postgres    false    6    194            �            1255    33180    rol_insert()    FUNCTION     �   CREATE FUNCTION rol_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.id = uuid();
	IF (NEW.descripcion IS NULL) THEN
		NEW.descripcion = 'DESCONOCIDO';
		RAISE NOTICE 'ROL NULO';
	END IF;
	RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.rol_insert();
       public       postgres    false    194    6                       1255    33279    update_config()    FUNCTION     C  CREATE FUNCTION update_config() RETURNS trigger
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
 &   DROP FUNCTION public.update_config();
       public       postgres    false    194    6                       1255    33276    update_cuota()    FUNCTION     �  CREATE FUNCTION update_cuota() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_emp character varying;
	id_st character varying;
BEGIN 
	NEW.fecha_ultima_modificacion = now();
	IF (NEW.periodo <> OLD.periodo) THEN
		NEW.periodo = OLD.periodo;
	END IF;
	IF (NEW.fecha_creacion <> OLD.fecha_creacion) THEN 
		NEW.fecha_creacion = OLD.fecha_creacion;
	END IF;
	IF (NEW.periodo <> OLD.periodo) THEN
		NEW.periodo = OLD.periodo;
	END IF;
	IF (NEW.intereses < 0) THEN
		NEW.intereses = 0;
	END IF;
	IF (NEW.importe < 0) THEN
		NEW.importe = 0;
	END IF;
	IF (NEW.fecha_emision <> OLD.fecha_emision) THEN
		NEW.fecha_emision = OLD.fecha_emision;
	END IF;
	IF (NEW.fecha_vencimiento <> OLD.fecha_vencimiento) THEN
		NEW.fecha_vencimiento = OLD.fecha_vencimiento;
	END IF;
	IF (NEW.cantidad_empleados < 0) THEN
		RAISE EXCEPTION 'Cantidad de empleados no valido';
	END IF;
	IF (NEW.id <> OLD.id) THEN
		NEW.id = OLD.id;
	END IF;
	IF (NEW.id_empresa IS NULL) THEN
		RAISE EXCEPTION 'ID de empresa no válido';
	ELSE
		SELECT e.id INTO id_emp FROM empresa e WHERE e.id = NEW.id_empresa LIMIT 1;
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
	RETURN NEW;
END;
$$;
 %   DROP FUNCTION public.update_cuota();
       public       postgres    false    194    6                       1255    33240    update_empresa()    FUNCTION     -  CREATE FUNCTION update_empresa() RETURNS trigger
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
	IF (NEW.fecha_emision_proxima_cuota <> NEW.fecha_emision_proxima_cuota) THEN
		NEW.fecha_emision_proxima_cuota = OLD.fecha_emision_proxima_cuota;
	END IF;
	NEW.fecha_ultima_modificacion = now();
	RETURN NEW;
END;
$$;
 '   DROP FUNCTION public.update_empresa();
       public       postgres    false    6    194                       1255    33259    update_estado_cuota()    FUNCTION     5  CREATE FUNCTION update_estado_cuota() RETURNS trigger
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
 ,   DROP FUNCTION public.update_estado_cuota();
       public       postgres    false    194    6            &           1255    41424    update_mensaje()    FUNCTION     �  CREATE FUNCTION update_mensaje() RETURNS trigger
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
 '   DROP FUNCTION public.update_mensaje();
       public       postgres    false    194    6                       1255    41408    update_registracion()    FUNCTION     B  CREATE FUNCTION update_registracion() RETURNS trigger
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
 ,   DROP FUNCTION public.update_registracion();
       public       postgres    false    6    194            �            1255    33185    update_rol()    FUNCTION       CREATE FUNCTION update_rol() RETURNS trigger
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
 #   DROP FUNCTION public.update_rol();
       public       postgres    false    194    6                       1255    33204    update_user()    FUNCTION     J  CREATE FUNCTION update_user() RETURNS trigger
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
 $   DROP FUNCTION public.update_user();
       public       postgres    false    6    194                       1255    33222 #   user_by_username(character varying)    FUNCTION     �   CREATE FUNCTION user_by_username(usr character varying) RETURNS registro_usuario
    LANGUAGE plpgsql
    AS $$
DECLARE
	result registro_usuario;
BEGIN 
	SELECT * into result FROM usuario u WHERE u.username = usr LIMIT 1;
	RETURN result;
END;
$$;
 >   DROP FUNCTION public.user_by_username(usr character varying);
       public       postgres    false    194    6    669            	           0    0 0   FUNCTION user_by_username(usr character varying)    COMMENT     �   COMMENT ON FUNCTION user_by_username(usr character varying) IS 'Obtiene todos los datos de un usuario a partir del nombre de usuario';
            public       postgres    false    261            �            1255    33116    uuid()    FUNCTION       CREATE FUNCTION uuid() RETURNS character varying
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
    DROP FUNCTION public.uuid();
       public       postgres    false    6    194            	           0    0    FUNCTION uuid()    COMMENT     k   COMMENT ON FUNCTION uuid() IS 'Genera un ID universal de 32 caracteres aleatorios. Evita las colisiones.';
            public       postgres    false    197            0           1255    41503     validate_cuit(character varying)    FUNCTION     *  CREATE FUNCTION validate_cuit(cuit character varying) RETURNS boolean
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
 <   DROP FUNCTION public.validate_cuit(cuit character varying);
       public       postgres    false    6    194            	           0    0 .   FUNCTION validate_cuit(cuit character varying)    COMMENT     �   COMMENT ON FUNCTION validate_cuit(cuit character varying) IS 'Valida si una cadena de caracteres tiene el formato aceptado por la Argentina del Numero de CUIL/CUIT';
            public       postgres    false    304            �            1255    33203     validateemail(character varying)    FUNCTION     �   CREATE FUNCTION validateemail(email character varying) RETURNS boolean
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
 =   DROP FUNCTION public.validateemail(email character varying);
       public       postgres    false    194    6            	           0    0 /   FUNCTION validateemail(email character varying)    COMMENT     �   COMMENT ON FUNCTION validateemail(email character varying) IS 'Valida un email retornando TRUE si cumple con el formato estandar y FALSE en caso contrario.';
            public       postgres    false    252                       1255    33285    vencio(date)    FUNCTION     �   CREATE FUNCTION vencio(fecha date) RETURNS boolean
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
 )   DROP FUNCTION public.vencio(fecha date);
       public       postgres    false    194    6                       1255    33284    verificar_vencimiento(date)    FUNCTION     �   CREATE FUNCTION verificar_vencimiento(fecha date) RETURNS boolean
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
 8   DROP FUNCTION public.verificar_vencimiento(fecha date);
       public       postgres    false    6    194            �            1259    33120    config    TABLE     �   CREATE TABLE config (
    id character varying(32) NOT NULL,
    dia_emision integer NOT NULL,
    dia_vencimiento integer NOT NULL,
    fecha_creacion timestamp with time zone,
    fecha_ultima_modificacion timestamp with time zone
);
    DROP TABLE public.config;
       public         postgres    false    6            	           0    0    TABLE config    COMMENT     �   COMMENT ON TABLE config IS 'Esta tabla solo puede contener un registro y solo uno. Contiene los dias del mes en los cuales se emite y vencen las cuotas de las empresas.';
            public       postgres    false    180            	           0    0    config    ACL     �   REVOKE ALL ON TABLE config FROM PUBLIC;
REVOKE ALL ON TABLE config FROM postgres;
GRANT ALL ON TABLE config TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE config TO adminfihclmu;
            public       postgres    false    180            �            1259    33242    cuota    TABLE     �  CREATE TABLE cuota (
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
    fecha_ultima_modificacion timestamp with time zone NOT NULL
);
    DROP TABLE public.cuota;
       public         postgres    false    6            	           0    0    TABLE cuota    COMMENT     b   COMMENT ON TABLE cuota IS 'Representa la cuota mensual que abona el responsable de cada empresa';
            public       postgres    false    185            	           0    0    COLUMN cuota.periodo    COMMENT     U   COMMENT ON COLUMN cuota.periodo IS 'Representa el mes en el cual se cobra la cuota';
            public       postgres    false    185            	           0    0    cuota    ACL     �   REVOKE ALL ON TABLE cuota FROM PUBLIC;
REVOKE ALL ON TABLE cuota FROM postgres;
GRANT ALL ON TABLE cuota TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE cuota TO adminfihclmu;
            public       postgres    false    185            �            1259    33223    empresa    TABLE     g  CREATE TABLE empresa (
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
    DROP TABLE public.empresa;
       public         postgres    false    6            	           0    0    TABLE empresa    COMMENT     K   COMMENT ON TABLE empresa IS 'Representa la entidad afiliada al sindicato';
            public       postgres    false    184             	           0    0    empresa    ACL     �   REVOKE ALL ON TABLE empresa FROM PUBLIC;
REVOKE ALL ON TABLE empresa FROM postgres;
GRANT ALL ON TABLE empresa TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE empresa TO adminfihclmu;
            public       postgres    false    184            �            1259    33252    estado_cuota    TABLE     �   CREATE TABLE estado_cuota (
    id character varying(32) NOT NULL,
    nombre character varying(32) NOT NULL,
    descripcion text
);
     DROP TABLE public.estado_cuota;
       public         postgres    false    6            !	           0    0    TABLE estado_cuota    COMMENT     j   COMMENT ON TABLE estado_cuota IS 'Representa los posibles estados de las cuotas emitidas por el sistema';
            public       postgres    false    186            "	           0    0    estado_cuota    ACL     �   REVOKE ALL ON TABLE estado_cuota FROM PUBLIC;
REVOKE ALL ON TABLE estado_cuota FROM postgres;
GRANT ALL ON TABLE estado_cuota TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE estado_cuota TO adminfihclmu;
            public       postgres    false    186            �            1259    41413    mensaje    TABLE     S  CREATE TABLE mensaje (
    id character varying(32) NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    fecha_ultima_modificacion timestamp with time zone NOT NULL,
    contenido text NOT NULL,
    nombre character varying(75) NOT NULL,
    email character varying(75) NOT NULL,
    leido boolean DEFAULT false NOT NULL
);
    DROP TABLE public.mensaje;
       public         postgres    false    6            #	           0    0    TABLE mensaje    COMMENT     h   COMMENT ON TABLE mensaje IS 'Representa la acción de enviar un mensaje al administrador del sistema.';
            public       postgres    false    188            $	           0    0    COLUMN mensaje.contenido    COMMENT     S   COMMENT ON COLUMN mensaje.contenido IS 'Representa el texto que envia la persona';
            public       postgres    false    188            %	           0    0    COLUMN mensaje.nombre    COMMENT     �   COMMENT ON COLUMN mensaje.nombre IS 'Nombre de la persona que envia el mensaje. Si el usuario esta registrado entonces el nombre debe ser igual al nombre del responsable de la empresa.';
            public       postgres    false    188            &	           0    0    COLUMN mensaje.email    COMMENT     �   COMMENT ON COLUMN mensaje.email IS 'Representa el mail del usuario que envia el mensaje. Si el usuario esta registrado este dato es igual al email de la tabla "Registracion" del mismo usuario.';
            public       postgres    false    188            '	           0    0    COLUMN mensaje.leido    COMMENT     �   COMMENT ON COLUMN mensaje.leido IS 'Representa el estado del mensaje. TRUE si el administrador ya lo leyo, FALSE en otro caso.';
            public       postgres    false    188            (	           0    0    mensaje    ACL     �   REVOKE ALL ON TABLE mensaje FROM PUBLIC;
REVOKE ALL ON TABLE mensaje FROM postgres;
GRANT ALL ON TABLE mensaje TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mensaje TO adminfihclmu;
            public       postgres    false    188            �            1259    41395    registracion    TABLE     3  CREATE TABLE registracion (
    completo boolean DEFAULT false,
    id_usuario character varying(32) NOT NULL,
    token character varying(32),
    email character varying(75) NOT NULL,
    fecha_creacion timestamp with time zone NOT NULL,
    fecha_ultima_modificacion timestamp with time zone NOT NULL
);
     DROP TABLE public.registracion;
       public         postgres    false    6            )	           0    0    TABLE registracion    COMMENT     �   COMMENT ON TABLE registracion IS 'Representa la accion de registración de los responsables a cargo de la empresa (usuarios comunes).';
            public       postgres    false    187            *	           0    0    registracion    ACL     �   REVOKE ALL ON TABLE registracion FROM PUBLIC;
REVOKE ALL ON TABLE registracion FROM postgres;
GRANT ALL ON TABLE registracion TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE registracion TO adminfihclmu;
            public       postgres    false    187            �            1259    33175    rol    TABLE     l   CREATE TABLE rol (
    id character varying(32) NOT NULL,
    descripcion character varying(40) NOT NULL
);
    DROP TABLE public.rol;
       public         postgres    false    6            +	           0    0 	   TABLE rol    COMMENT     o   COMMENT ON TABLE rol IS 'Representa el rol de cada usuario. Siempre un usuario debe tener un rol y solo uno.';
            public       postgres    false    182            ,	           0    0    rol    ACL     �   REVOKE ALL ON TABLE rol FROM PUBLIC;
REVOKE ALL ON TABLE rol FROM postgres;
GRANT ALL ON TABLE rol TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE rol TO adminfihclmu;
            public       postgres    false    182            �            1259    33169    usuario    TABLE     �  CREATE TABLE usuario (
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
    DROP TABLE public.usuario;
       public         postgres    false    6            -	           0    0    TABLE usuario    COMMENT     e   COMMENT ON TABLE usuario IS 'Contiene al conjunto de usuarios registrados para utilizar el sistema';
            public       postgres    false    181            .	           0    0    usuario    ACL     �   REVOKE ALL ON TABLE usuario FROM PUBLIC;
REVOKE ALL ON TABLE usuario FROM postgres;
GRANT ALL ON TABLE usuario TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE usuario TO adminfihclmu;
            public       postgres    false    181            �          0    33120    config 
   TABLE DATA                     public       postgres    false    180   ��       �          0    33242    cuota 
   TABLE DATA                     public       postgres    false    185   l�       �          0    33223    empresa 
   TABLE DATA                     public       postgres    false    184   ��        	          0    33252    estado_cuota 
   TABLE DATA                     public       postgres    false    186   ��       	          0    41413    mensaje 
   TABLE DATA                     public       postgres    false    188   O�       	          0    41395    registracion 
   TABLE DATA                     public       postgres    false    187   i�       �          0    33175    rol 
   TABLE DATA                     public       postgres    false    182   m�       �          0    33169    usuario 
   TABLE DATA                     public       postgres    false    181   .�       Y           2606    33288 	   config_pk 
   CONSTRAINT     G   ALTER TABLE ONLY config
    ADD CONSTRAINT config_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.config DROP CONSTRAINT config_pk;
       public         postgres    false    180    180            o           2606    41421    contacto_pk 
   CONSTRAINT     J   ALTER TABLE ONLY mensaje
    ADD CONSTRAINT contacto_pk PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.mensaje DROP CONSTRAINT contacto_pk;
       public         postgres    false    188    188            e           2606    33246    cuota_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY cuota
    ADD CONSTRAINT cuota_pk PRIMARY KEY (id, id_empresa);
 8   ALTER TABLE ONLY public.cuota DROP CONSTRAINT cuota_pk;
       public         postgres    false    185    185    185            k           2606    41411    email_registrado_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY registracion
    ADD CONSTRAINT email_registrado_unique UNIQUE (email);
 N   ALTER TABLE ONLY public.registracion DROP CONSTRAINT email_registrado_unique;
       public         postgres    false    187    187            c           2606    41430    emp_pk 
   CONSTRAINT     M   ALTER TABLE ONLY empresa
    ADD CONSTRAINT emp_pk PRIMARY KEY (id_usuario);
 8   ALTER TABLE ONLY public.empresa DROP CONSTRAINT emp_pk;
       public         postgres    false    184    184            g           2606    33256    estado_cuota_pk 
   CONSTRAINT     S   ALTER TABLE ONLY estado_cuota
    ADD CONSTRAINT estado_cuota_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.estado_cuota DROP CONSTRAINT estado_cuota_pk;
       public         postgres    false    186    186            m           2606    41455    register_pk 
   CONSTRAINT     W   ALTER TABLE ONLY registracion
    ADD CONSTRAINT register_pk PRIMARY KEY (id_usuario);
 B   ALTER TABLE ONLY public.registracion DROP CONSTRAINT register_pk;
       public         postgres    false    187    187            a           2606    33179    rol_id 
   CONSTRAINT     A   ALTER TABLE ONLY rol
    ADD CONSTRAINT rol_id PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.rol DROP CONSTRAINT rol_id;
       public         postgres    false    182    182            [           2606    41462    unique_email 
   CONSTRAINT     I   ALTER TABLE ONLY usuario
    ADD CONSTRAINT unique_email UNIQUE (email);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT unique_email;
       public         postgres    false    181    181            i           2606    33263    unique_nombre 
   CONSTRAINT     P   ALTER TABLE ONLY estado_cuota
    ADD CONSTRAINT unique_nombre UNIQUE (nombre);
 D   ALTER TABLE ONLY public.estado_cuota DROP CONSTRAINT unique_nombre;
       public         postgres    false    186    186            ]           2606    41439    unique_user 
   CONSTRAINT     K   ALTER TABLE ONLY usuario
    ADD CONSTRAINT unique_user UNIQUE (username);
 =   ALTER TABLE ONLY public.usuario DROP CONSTRAINT unique_user;
       public         postgres    false    181    181            _           2606    41432    user_pk 
   CONSTRAINT     F   ALTER TABLE ONLY usuario
    ADD CONSTRAINT user_pk PRIMARY KEY (id);
 9   ALTER TABLE ONLY public.usuario DROP CONSTRAINT user_pk;
       public         postgres    false    181    181            �           2620    41493    after_delete_empresa    TRIGGER     s   CREATE TRIGGER after_delete_empresa AFTER DELETE ON empresa FOR EACH ROW EXECUTE PROCEDURE after_delete_empresa();
 5   DROP TRIGGER after_delete_empresa ON public.empresa;
       public       postgres    false    184    298                       2620    41460    after_insert_empresa    TRIGGER     s   CREATE TRIGGER after_insert_empresa AFTER INSERT ON empresa FOR EACH ROW EXECUTE PROCEDURE after_insert_empresa();
 5   DROP TRIGGER after_insert_empresa ON public.empresa;
       public       postgres    false    297    184            y           2620    41457    after_insert_user    TRIGGER     m   CREATE TRIGGER after_insert_user AFTER INSERT ON usuario FOR EACH ROW EXECUTE PROCEDURE after_insert_user();
 2   DROP TRIGGER after_insert_user ON public.usuario;
       public       postgres    false    296    181            u           2620    33281    config_insert    TRIGGER     e   CREATE TRIGGER config_insert BEFORE INSERT ON config FOR EACH ROW EXECUTE PROCEDURE config_insert();
 -   DROP TRIGGER config_insert ON public.config;
       public       postgres    false    180    266            |           2620    33202 
   delete_rol    TRIGGER     \   CREATE TRIGGER delete_rol BEFORE DELETE ON rol FOR EACH ROW EXECUTE PROCEDURE delete_rol();
 '   DROP TRIGGER delete_rol ON public.rol;
       public       postgres    false    253    182            �           2620    33275    insert_cuota    TRIGGER     b   CREATE TRIGGER insert_cuota BEFORE INSERT ON cuota FOR EACH ROW EXECUTE PROCEDURE insert_cuota();
 +   DROP TRIGGER insert_cuota ON public.cuota;
       public       postgres    false    288    185            }           2620    33239    insert_empresa    TRIGGER     h   CREATE TRIGGER insert_empresa BEFORE INSERT ON empresa FOR EACH ROW EXECUTE PROCEDURE insert_empresa();
 /   DROP TRIGGER insert_empresa ON public.empresa;
       public       postgres    false    305    184            �           2620    33258    insert_estado_cuota    TRIGGER     w   CREATE TRIGGER insert_estado_cuota BEFORE INSERT ON estado_cuota FOR EACH ROW EXECUTE PROCEDURE insert_estado_cuota();
 9   DROP TRIGGER insert_estado_cuota ON public.estado_cuota;
       public       postgres    false    186    263            �           2620    41423    insert_mensaje    TRIGGER     h   CREATE TRIGGER insert_mensaje BEFORE INSERT ON mensaje FOR EACH ROW EXECUTE PROCEDURE insert_mensaje();
 /   DROP TRIGGER insert_mensaje ON public.mensaje;
       public       postgres    false    188    293            �           2620    41407    insert_registracion    TRIGGER     w   CREATE TRIGGER insert_registracion BEFORE INSERT ON registracion FOR EACH ROW EXECUTE PROCEDURE insert_registracion();
 9   DROP TRIGGER insert_registracion ON public.registracion;
       public       postgres    false    286    187            x           2620    33207    insert_user    TRIGGER     b   CREATE TRIGGER insert_user BEFORE INSERT ON usuario FOR EACH ROW EXECUTE PROCEDURE insert_user();
 ,   DROP TRIGGER insert_user ON public.usuario;
       public       postgres    false    181    295            z           2620    33181 
   rol_insert    TRIGGER     \   CREATE TRIGGER rol_insert BEFORE INSERT ON rol FOR EACH ROW EXECUTE PROCEDURE rol_insert();
 '   DROP TRIGGER rol_insert ON public.rol;
       public       postgres    false    182    247            v           2620    33282    update_config    TRIGGER     e   CREATE TRIGGER update_config BEFORE UPDATE ON config FOR EACH ROW EXECUTE PROCEDURE update_config();
 -   DROP TRIGGER update_config ON public.config;
       public       postgres    false    180    270            �           2620    33277    update_cuota    TRIGGER     b   CREATE TRIGGER update_cuota BEFORE UPDATE ON cuota FOR EACH ROW EXECUTE PROCEDURE update_cuota();
 +   DROP TRIGGER update_cuota ON public.cuota;
       public       postgres    false    185    285            ~           2620    33241    update_empresa    TRIGGER     h   CREATE TRIGGER update_empresa BEFORE UPDATE ON empresa FOR EACH ROW EXECUTE PROCEDURE update_empresa();
 /   DROP TRIGGER update_empresa ON public.empresa;
       public       postgres    false    262    184            �           2620    33261    update_estado_cuota    TRIGGER     w   CREATE TRIGGER update_estado_cuota BEFORE UPDATE ON estado_cuota FOR EACH ROW EXECUTE PROCEDURE update_estado_cuota();
 9   DROP TRIGGER update_estado_cuota ON public.estado_cuota;
       public       postgres    false    264    186            �           2620    41425    update_mensaje    TRIGGER     h   CREATE TRIGGER update_mensaje BEFORE UPDATE ON mensaje FOR EACH ROW EXECUTE PROCEDURE update_mensaje();
 /   DROP TRIGGER update_mensaje ON public.mensaje;
       public       postgres    false    294    188            �           2620    41409    update_registracion    TRIGGER     w   CREATE TRIGGER update_registracion BEFORE UPDATE ON registracion FOR EACH ROW EXECUTE PROCEDURE update_registracion();
 9   DROP TRIGGER update_registracion ON public.registracion;
       public       postgres    false    287    187            {           2620    33186 
   update_rol    TRIGGER     \   CREATE TRIGGER update_rol BEFORE UPDATE ON rol FOR EACH ROW EXECUTE PROCEDURE update_rol();
 '   DROP TRIGGER update_rol ON public.rol;
       public       postgres    false    254    182            w           2620    33205    update_user    TRIGGER     b   CREATE TRIGGER update_user BEFORE UPDATE ON usuario FOR EACH ROW EXECUTE PROCEDURE update_user();
 ,   DROP TRIGGER update_user ON public.usuario;
       public       postgres    false    181    269            r           2606    41468    cuota_emp_fk    FK CONSTRAINT     �   ALTER TABLE ONLY cuota
    ADD CONSTRAINT cuota_emp_fk FOREIGN KEY (id_empresa) REFERENCES empresa(id_usuario) ON DELETE CASCADE;
 <   ALTER TABLE ONLY public.cuota DROP CONSTRAINT cuota_emp_fk;
       public       postgres    false    2147    185    184            s           2606    41478    email_user_fk    FK CONSTRAINT     �   ALTER TABLE ONLY registracion
    ADD CONSTRAINT email_user_fk FOREIGN KEY (email) REFERENCES usuario(email) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.registracion DROP CONSTRAINT email_user_fk;
       public       postgres    false    187    181    2139            q           2606    41473    emp_user_fk    FK CONSTRAINT     {   ALTER TABLE ONLY empresa
    ADD CONSTRAINT emp_user_fk FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.empresa DROP CONSTRAINT emp_user_fk;
       public       postgres    false    181    184    2143            t           2606    41483    register_user_fk    FK CONSTRAINT     �   ALTER TABLE ONLY registracion
    ADD CONSTRAINT register_user_fk FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.registracion DROP CONSTRAINT register_user_fk;
       public       postgres    false    187    181    2143            p           2606    33193    rol_fk    FK CONSTRAINT     \   ALTER TABLE ONLY usuario
    ADD CONSTRAINT rol_fk FOREIGN KEY (id_rol) REFERENCES rol(id);
 8   ALTER TABLE ONLY public.usuario DROP CONSTRAINT rol_fk;
       public       postgres    false    181    182    2145            �   }   x�Mʱ�0 н_q[5i���]K�H&��P������{�8���q�@y�������O���y����*�L)f*+�,Z6��8��$��#��B��`T��������Clb"��������      �   
   x���          �   
   x���           	   �  x������0��}���=$N];�T�E�m�^�Ğ,�;8i%�Z</�8��=���c�<���w���#��q4�h�7s
3������ o��Q�\v�˷ZK����%��|+L�~�u�����.�N�m��#��|g�����_���78�sHGn-��V��J,IS�emW���˭6��U����6!}��z���7����y7͑�Fƈ�s�ǉRwė �nY�;�JǨ��41t�ћ �cn3)xe�0*��,Ih��L�.Q~��Ǻj�ս��I�#&yDD��xx��Y�<$�9)Q�&�*��~��9X<; �����>��)���.(��TZm3*���U	$ZR�=ׇ�H�I�HB$Vp��9����x�������`����0q�4,�g���      	   
   x���          	   �   x���AK�@���{���3;ٙx�C�`����&�Z���Mz�wz|�������i��gs��py?k�ɼ=>�������ƣ$��9*s�[��R�,+lV&P�9�������	2Z���xe�y�ԇ���X���V`ml-���%����Z�xc�&W[*���+p{_4��`@�T�	�wm�b�l+��ZHp��Li���&�8@'+�c�1���妯�j�R��/?�ţ(� ze�      �   �   x���=k�0��ݿB�� �;�� hl�GvIw������Zh��;=�i�n�nҼ/��z���q�6s�D������K��BnV�z�/��{�Ӷ�㴬��ڥ�4@br�l�"�:+ �3R�֎�״��c,��)V_ɕ�(u\J��]��*Vr��2�����|%�"?���l�O�      �   �   x���MK1������V��I&3���"�����&qYh�R݋�ެ7E�����m֛��V5���_F9���߮vˍ��-rҨ�B�B�0ǖ�% 1����s�ޘ�� m,6�l%�5D�"G˺�r��dh7�f�.4��32�-�o��y̅�l�8���eS6��y���n�*�Nor��?��p�/���r���g<S2��61D�T΀������[v�n�4g&��5���t9tc�O����]z     