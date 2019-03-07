CREATE OR REPLACE PACKAGE BODY gestiondepartamentos AS
		--######################## FUNCIONES DE VALIDACIÓN

    FUNCTION f_validarexiste (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN BOOLEAN IS
        existe_ INT := 0;
    BEGIN
        SELECT
            COUNT(*)
        INTO existe_
        FROM
            tbldepartamentos
        WHERE
            iddepartamento = iddepartamento_;

        IF existe_ > 0 THEN
            RETURN true;
        ELSE
            RETURN false;
        END IF;
    END;

    FUNCTION f_validarnulos (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN BOOLEAN IS
        valido_ BOOLEAN := false;
    BEGIN
        IF iddepartamento_ IS NOT NULL THEN
            valido_ := true;
        END IF;
        RETURN valido_;
    END;

		--######################## PROCEDIMIENTOS DE MANTENIMIENTO

    PROCEDURE p_gestiondepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    ) IS
    BEGIN
			--VALIDAR NULOS
        IF NOT f_validarnulos(iddepartamento_) THEN
            RAISE registro_invalido;
        END IF;
			--VALIDAR EXISTE
        IF f_validarexiste(iddepartamento_) THEN
            p_modificadepartamento(iddepartamento_, nombredepartamento_, idpais_);
            COMMIT;
        ELSE
            p_creadepartamento(iddepartamento_, nombredepartamento_, idpais_);
            COMMIT;
        END IF;

        dbms_output.put_line('FINALIZADA LA ACTUALIZACIÓN CON ÉXITO PARA EL DEPARTAMENTO: ' || nombredepartamento_);

			--DML
    EXCEPTION
        WHEN registro_invalido THEN
            raise_application_error(-20001, 'EL REGISTRO CONTIENE CARACTERES NULOS EN CAMPOS QUE NO LO PERMITEN, VERIFIQUE... ('
                                            || sqlcode
                                            || ' - '
                                            || sqlerrm()
                                            || ')');
        WHEN OTHERS THEN
            raise_application_error(sqlcode, sqlerrm());
    END;

    PROCEDURE p_creadepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    ) IS
    BEGIN
        dbms_output.put_line('INSERTANDO REGISTRO...');
        INSERT INTO tbldepartamentos (
            iddepartamento,
            nombredepartamento,
            idpais
        ) VALUES (
            iddepartamento_,
            nombredepartamento_,
            idpais_
        );

    END;

    PROCEDURE p_modificadepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    ) IS
    BEGIN
        dbms_output.put_line('MODIFICANDO REGISTRO...');
        UPDATE tbldepartamentos
        SET
            nombredepartamento = nombredepartamento_,
            idpais = idpais_
        WHERE
            iddepartamento = iddepartamento_;

    END;

    PROCEDURE p_eliminadepartamento (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) IS
    BEGIN
        IF NOT f_validarnulos(iddepartamento_) THEN
            RAISE registro_invalido;
        END IF;
        IF NOT f_validarexiste(iddepartamento_) THEN
            RAISE registro_no_encontrado;
        END IF;
        dbms_output.put_line('ELIMINANDO REGISTRO...');
        DELETE FROM tbldepartamentos
        WHERE
            iddepartamento = iddepartamento_;

        COMMIT;
    EXCEPTION
        WHEN registro_invalido THEN
            raise_application_error(-20001, 'EL REGISTRO CONTIENE CARACTERES NULOS EN CAMPOS QUE NO LO PERMITEN, VERIFIQUE... ('
                                            || sqlcode
                                            || ' - '
                                            || sqlerrm()
                                            || ')');
        WHEN registro_no_encontrado THEN
            raise_application_error(-20001, 'NO SE ENCONTRÓ EL REGISTRO A ELIMINAR ('
                                            || sqlcode
                                            || ' - '
                                            || sqlerrm()
                                            || ')');
        WHEN OTHERS THEN
            raise_application_error(sqlcode, sqlerrm());
    END;

		--######################## FUNCIONES DE VISUALIZACIÓN

    FUNCTION f_seleccionadepartamentos RETURN SYS_REFCURSOR IS
        cur_ SYS_REFCURSOR;
    BEGIN
        OPEN cur_ FOR SELECT
                          iddepartamento,
                          nombredepartamento,
                          idpais
                      FROM
                          tbldepartamentos;
        return cur_;
    END;

    FUNCTION f_buscadepartamento (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN SYS_REFCURSOR IS
        cur_ SYS_REFCURSOR;
    BEGIN
        OPEN cur_ FOR SELECT
                          iddepartamento,
                          nombredepartamento,
                          idpais
                      FROM
                          tbldepartamentos
                      WHERE
                          iddepartamento = iddepartamento_;
        return cur_;
    END;

    FUNCTION f_buscadepartamento (
        nombredepartamento_ tbldepartamentos.nombredepartamento%TYPE
    ) RETURN SYS_REFCURSOR IS
        cur_ SYS_REFCURSOR;
    BEGIN
        OPEN cur_ FOR SELECT
                          iddepartamento,
                          nombredepartamento,
                          idpais
                      FROM
                          tbldepartamentos
                      WHERE
                          nombredepartamento = nombredepartamento_;
        return cur_;
    END;

END gestiondepartamentos;
