CREATE OR REPLACE PACKAGE gestiondepartamentos AS

		--######################## FUNCIONES DE VALIDACIÓN
    FUNCTION f_validarexiste (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN BOOLEAN;

    FUNCTION f_validarnulos (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN BOOLEAN;

		--######################## PROCEDIMIENTOS DE MANTENIMIENTO

    PROCEDURE p_gestiondepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    );

    PROCEDURE p_creadepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    );

    PROCEDURE p_modificadepartamento (
        iddepartamento_       tbldepartamentos.iddepartamento%TYPE,
        nombredepartamento_   tbldepartamentos.nombredepartamento%TYPE,
        idpais_               tbldepartamentos.idpais%TYPE
    );

    PROCEDURE p_eliminadepartamento (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    );

		--######################## FUNCIONES DE VISUALIZACIÓN

    FUNCTION f_seleccionadepartamentos RETURN SYS_REFCURSOR;

    FUNCTION f_buscadepartamento (
        iddepartamento_ tbldepartamentos.iddepartamento%TYPE
    ) RETURN SYS_REFCURSOR;

    FUNCTION f_buscadepartamento (
        nombredepartamento_ tbldepartamentos.nombredepartamento%TYPE
    ) RETURN SYS_REFCURSOR;

		--######################## EXCEPCIONES

    registro_no_encontrado EXCEPTION;
    registro_invalido EXCEPTION;
END gestiondepartamentos;
